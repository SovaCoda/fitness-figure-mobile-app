import 'dart:async';
import 'dart:ui';

import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:ffapp/components/admin_panel.dart';
import 'package:ffapp/components/ff_app_button.dart';
import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/chat_bubble.dart';
import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/components/charge_bar.dart';
import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/resuables/streak_shower.dart';
import 'package:ffapp/components/resuables/week_goal_shower.dart';
import 'package:ffapp/components/resuables/week_to_go_shower.dart';
import 'package:ffapp/components/resuables/workout_time_shower.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/components/utils/chat_model.dart';
import 'package:ffapp/components/utils/history_model.dart';
import 'package:ffapp/components/utils/time_utils.dart';
import 'package:ffapp/components/workout_calendar.dart';
import 'package:ffapp/components/workout_progress_bar.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/dynamic_island_manager.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:ffapp/services/robot_dialog.dart';
import 'package:ffapp/services/routes.pb.dart' as routes;
import 'package:ffapp/services/routes.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class WorkoutAdder extends StatefulWidget {
  const WorkoutAdder({super.key});

  @override
  State<WorkoutAdder> createState() => _WorkoutAdderState();
}

class _WorkoutAdderState extends State<WorkoutAdder> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final logger = Logger();
  bool _logging = false;
  PersistantTimer _timer = PersistantTimer(
    prefs: null,
    timerName: "workout",
    onTick: () => {},
  );
  Int64 time = Int64(); // default value for Int64 is zero
  Int64 _timePassed = Int64();
  late Int64 _timegoal = Int64();
  late String _startTime;
  late String _endTime;
  late AuthService auth;
  late String figureURL = "robot1_skin0_cropped";
  RobotDialog robotDialog = RobotDialog();
  // final int RANDRANGE = 100;
  // final double OFFSET = 250 / 4;
  late double scoreIncrement;
  final int sigfigs = 2;
  bool _goalMet = false;
  int minWorkoutTime = 30;
  double _investment = 0;
  SharedPreferences? prefs;
  bool hasInvested = false;
  late Future<String>? _postWorkoutMessage;

  // ignore: unused_field
  late final AppLifecycleListener _listener;
  // ignore: unused_field
  late AppLifecycleState? _lifeState;
  // ignore: unused_field
  final List<String> _lifeStates = <String>[];
  DynamicIslandManager liveActivityManager = DynamicIslandManager(
    channelKey: "LI",
  ); // class that can use method channels to communicate with Ios App

  @override
  void initState() {
    super.initState();
    _lifeState = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onRestart: () {
        if (_logging) {
          logger.i("restarted");
        }
      },
      onResume: () async {
        if (_logging) {
          logger.i("resumed");
        }

        _timer.loadTime();
      },
      onExitRequested: () async {
        if (_logging) {
          logger.i('shutting down ');
        }
        if (Platform.isIOS) {
          liveActivityManager.stopLiveActivity();
        }
        return AppExitResponse.exit;
      },
      onDetach: () {
        if (_logging) {
          logger.i("detached");
        }
        if (Platform.isIOS) {
          liveActivityManager.stopLiveActivity();
        }
        if (states['logging']! && !states['paused']!) {
          prefs!.setBool("hasOngoingWorkout", true);
          prefs!.setBool("hasOngoingWorkoutPaused", false);
        }

        if (states['paused']!) prefs!.setBool("hasOngoingWorkoutPaused", true);
      },
    );
    initialize();

    auth = Provider.of<AuthService>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        minWorkoutTime = Provider.of<UserModel>(context, listen: false)
            .user!
            .workoutMinTime
            .toInt();
      });
    });
  }

  void stopLiveActivities(DynamicIslandManager liveActivityManager) {
    if (!Platform.isIOS) return; // function should only run for iOS users

    for (int i = 0; i < 5; i++) {
      try {
        liveActivityManager.stopLiveActivity();
        if (kDebugMode) {
          print('Successfully stopped live activity on attempt ${i + 1}');
        }
        break;
      } catch (err) {
        if (kDebugMode) {
          print('Attempt ${i + 1} failed: $err');
        }
      }
    }
    if (kDebugMode) {
      print('Finished trying to stop live activities.');
    }
  }

  Future<void> initialize({bool restartLiveActivity = true}) async {
    stopLiveActivities(liveActivityManager);
    prefs = await SharedPreferences.getInstance();
    final User user = await getUserModel().then((value) => value.user!);
    final Int64 timegoal = user.workoutMinTime;
    scoreIncrement = 1 / (timegoal.toDouble() * 60);
    if (_logging) {
      logger.i(timegoal);
    }

    setState(() {
      if (timegoal != Int64.ZERO) {
        _timegoal = timegoal * 60; //convert to seconds
        // _timegoal = Int64(5);
      }
    });

    startLogging(false);
    startTimer(true, restartLiveActivity);
  }

  Future<UserModel> getUserModel() async {
    UserModel userModel;
    do {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return Future.error("MountedException");
      userModel = Provider.of<UserModel>(context, listen: false);
    } while (userModel.user == User());
    return userModel;
  }

  Future<void> startTimer(bool isInit, bool restartLiveActivity) async {
    _timer = PersistantTimer(
      prefs: prefs,
      timerName: "workout_timer",
      onTick: () {
        if (mounted) {
          if (Platform.isIOS) {
            liveActivityManager.updateLiveActivity(
              jsonData: DynamicIslandStopwatchDataModel(
                elapsedSeconds: time.toInt() + 1,
                timeGoal: _timegoal.toInt(),
                paused: false,
              ).toMap(),
            );
          }
          setState(() {
            if (mounted) {
              time = Int64(_timer.getTimeInSeconds());
              if (time >= _timegoal) {
                _goalMet = true;
                if (time == _timegoal) {
                  LocalNotificationService().showNotification(
                    title: "Goal Met!",
                    body: "You have met your workout goal.",
                  );
                  if (_logging) {
                    logger.i('Goal met, sending user notification');
                  }
                }
              }
            }
          });
        }
      },
    );
    if (_timer.hasStoredTime()) {
      states["logging"] = true;
      states["paused"] = _timer.hasStoredPauseTime();
      states["pre-logging"] = false;
      await _timer.start();

      setState(() {
        time = Int64(_timer.getTimeInSeconds());
      });
      if (Platform.isIOS) {
        liveActivityManager.startLiveActivity(
          jsonData: DynamicIslandStopwatchDataModel(
            elapsedSeconds: time.toInt(),
            timeGoal: _timegoal.toInt(),
            paused: _timer.hasStoredPauseTime(),
          ).toMap(),
        );
      }
    } else {
      if (!isInit) {
        if (Platform.isIOS) {
          liveActivityManager.startLiveActivity(
            jsonData: DynamicIslandStopwatchDataModel(
              elapsedSeconds: 0,
              timeGoal: _timegoal.toInt(),
              paused: false,
            ).toMap(),
          );
        }
        await _timer.start();
        states["logging"] = true;
        states["paused"] = false;
        states["pre-logging"] = false;
      }
    }
  }

  void startLogging(bool paused) {
    setState(() {
      _logging = true;
      _startTime = DateTime.now().toUtc().toString();
    });
  }

  Future<void> resumeTimer() async {
    if (Platform.isIOS) {
      liveActivityManager.updateLiveActivity(
        jsonData: DynamicIslandStopwatchDataModel(
          elapsedSeconds: time.toInt() + 1,
          timeGoal: _timegoal.toInt(),
          paused: false,
        ).toMap(),
      );
    }
    _timer.resume();
    setState(() {
      states['paused'] = false;
    });
  }

  Future<void> pauseTimer() async {
    if (Platform.isIOS) {
      liveActivityManager.updateLiveActivity(
        jsonData: DynamicIslandStopwatchDataModel(
          elapsedSeconds: time.toInt() + 1,
          timeGoal: _timegoal.toInt(),
          paused: true,
        ).toMap(),
      );
    }
    _timer.pause();
    setState(() {
      states["paused"] = true;
    });
  }

  @override
  void dispose() {
    if (states['logging']! && !states['paused']!) {
      prefs!.setBool("hasOngoingWorkout", true);
      prefs!.setBool("hasOngoingWorkoutPaused", false);
    }

    if (states['paused']!) prefs!.setBool("hasOngoingWorkoutPaused", true);
    if (Platform.isIOS) {
      liveActivityManager.stopLiveActivity();
    }
    if (_timer.classTimer != null) {
      _timer.dispose();
    }
    super.dispose();
  }

  Future<void> endLogging() async {
    if (Platform.isIOS) {
      liveActivityManager.stopLiveActivity();
    }
    prefs!.setBool("hasOngoingWorkout", false);
    prefs!.setBool("hasOngoingWorkoutPaused", false);
    prefs!.remove("workout lastTicked");
    prefs!.remove("workout pausedAt");
    states["logging"] = false;
    _timePassed = time;
    setState(() {
      _timePassed = time;
    });
    _timer.deleteTimer();
    time = Int64.ZERO;
    _endTime = DateTime.now().toUtc().toString();
    await awardAll(
      weeklyGoalMet: false,
      timeGoalMet: _goalMet,
      investment: _investment,
    );
  }

  int addableEV = 50;
  int addableCharge = 0;
  //function that does all the awarding in one
  Future<void> awardAll({
    required bool weeklyGoalMet,
    required bool timeGoalMet,
    double investment = 0,
  }) async {
    final UserModel user = Provider.of<UserModel>(context, listen: false);
    FigureInstance figureInstance =
        Provider.of<FigureModel>(context, listen: false).figure!;
    final HistoryModel history =
        Provider.of<HistoryModel>(context, listen: false);

    final double workoutPercent =
        (_timePassed.toDouble() / _timegoal.toDouble()).clamp(0, 1);

    final double maxEVGain =
        figure1.evCutoffs[figureInstance.evLevel].toDouble() / 5;
    final double baseEVGain = user.isPremium() ? 75.00 : 50.00;
    final double eVConcistencyBonus = (10) * user.user!.streak.toDouble();
    addableEV = history.workedOutToday
        ? (baseEVGain * workoutPercent).ceil()
        : ((maxEVGain + eVConcistencyBonus) * workoutPercent).ceil();
    final int totalEV = figureInstance.evPoints + addableEV;

    final int baseChargeGain = user.isPremium() ? 6 : 5;
    final int chargeConcistencyBonus =
        ((0.25) * user.user!.streak.toInt()).ceil();
    addableCharge = history.workedOutToday
        ? 0
        : (baseChargeGain + chargeConcistencyBonus) * workoutPercent.floor();
    final int totalCharge = figureInstance.charge + addableCharge;

    setState(() {});

    Provider.of<FigureModel>(context, listen: false).setFigureEv(totalEV);
    Provider.of<FigureModel>(context, listen: false).setFigureCharge(
      !weeklyGoalMet
          ? (totalCharge > 100)
              ? 100
              : totalCharge
          : figureInstance.charge,
    );
    // update the figure instances provider for inventory to update charge and ev values
    final int index =
        Provider.of<SelectedFigureProvider>(context, listen: false)
            .selectedFigureIndex;
    Provider.of<FigureInstancesProvider>(context, listen: false)
        .setFigureInstanceCharge(index, totalCharge);
    Provider.of<FigureInstancesProvider>(context, listen: false)
        .setFigureInstanceEV(index, totalEV);

    // if we havent worked out today, update the user's streak and week complete
    if (!Provider.of<HistoryModel>(context, listen: false).workedOutToday &&
        timeGoalMet) {
      await auth.updateUserDBInfo(
        routes.User(
          email: user.user!.email,
          streak: Int64(user.user!.streak.toInt() + 1),
          weekComplete: Int64(user.user!.weekComplete.toInt() + 1),
        ),
      );
      if (mounted) {
        Provider.of<UserModel>(context, listen: false)
            .setUserWeekCompleted(Int64(user.user!.weekComplete.toInt() + 1));
      }
      if (mounted) {
        Provider.of<UserModel>(context, listen: false).user!.streak =
            Int64(user.user!.streak.toInt() + 1);
      }
    }
    if (mounted) {
      figureInstance = Provider.of<FigureModel>(context, listen: false).figure!;

      await auth.updateFigureInstance(
        FigureInstance(
          figureId: figureInstance.figureId,
          userEmail: user.user!.email,
          figureName: figureInstance.figureName,
          charge: figureInstance.charge,
          evPoints: figureInstance.evPoints,
        ),
      );
    }

    final Workout workout = Workout(
      startDate: _startTime,
      endDate: _endTime,
      elapsed: _timePassed,
      email: await auth.getUser().then((value) => value!.email.toString()),
      chargeAdd: Int64(addableCharge),
      evoAdd: Int64(addableEV),
      investment: investment,
      countable: workoutPercent >= 1 ? 1 : 0,
    );
    if (mounted) {
      Provider.of<HistoryModel>(context, listen: false).addWorkout(workout);
    }

    final SharedPreferences prefs = await _prefs;
    if (prefs.getBool("hasSurveyed") == null ||
        prefs.getBool("hasSurveyed") == true) {}
  }

  void add30Seconds() {
    setState(() {
      _timer.addTime(30 * 1000);
    });
  }

  void add10Minutes() {
    setState(() {
      _timer.addTime(600 * 1000);
    });
  }

  Future<void> endWorkout() async {
    if (time < _timegoal.toInt()) {
      showFFDialogBinary(
        "ARE YOU SURE?",
        "This will stop your current workout. You can't restore your progress.\n\nContinue?",
        true,
        context,
        FFAppButton(
          height: MediaQuery.of(context).size.height * 0.0751173708920188,
          fontSize: 20,
          text: "OK",
          onPressed: () async => {
            if (Platform.isIOS) {liveActivityManager.stopLiveActivity()},
            setState(() {
              _timePassed = time;
              states['chatting'] = true;
              states['logging'] = false;
              _postWorkoutMessage = generatePostWorkoutComment();
            }),
            Navigator.of(context).pop(),
          },
        ),
        FFAppButton(
          height: MediaQuery.of(context).size.height * 0.0751173708920188,
          fontSize: 20,
          isNoThanks: true,
          text: "GO BACK",
          onPressed: () => {Navigator.of(context).pop()},
        ),
      );
    } else {
      if (Platform.isIOS) {
        liveActivityManager.stopLiveActivity();
      }
      setState(() {
        _timePassed = time;
        states['chatting'] = true;
        states['logging'] = false;
        _postWorkoutMessage = generatePostWorkoutComment();
      });
    }
  }

  Future<String>? generatePostWorkoutComment() async {
    if (Provider.of<UserModel>(context, listen: false).user!.hasPremium()) {
      return Provider.of<ChatModel>(context, listen: false)
          .generatePostWorkoutMessage({
        "workoutTimeMinutes": _timePassed.toDouble() / 60,
        "workoutTimeNeededMinutes": _timegoal.toDouble() / 60,
      })!;
    } else {
      if (_goalMet) {
        return "Awesome job! Keep up workouts like this and we'll evolve in no time at all!";
      } else {
        return "Looks like we are short of our workout goal... if we want to make progress we need to train hard!";
      }
    }
  }

  Future<void> chatMore(BuildContext context) async {
    Provider.of<UserModel>(context, listen: false).isPremium()
        ? GoRouter.of(context).go('/chat')
        : showFFDialogBinary(
            "FF+ Premium Feature",
            "Subscribe now to FF+ to gain acess to chatting with your figure. Your figure can help you with all your fitness goals as well as assist in managing your growth! \n \nAdditionally, you earn extra rewards and cosmetics while you're subscribed!",
            true,
            context,
            FFAppButton(
              height: 0.0751173708920188,
              fontSize: 20,
              text: "Subscribe Now \$1.99",
              onPressed: () async {
                try {
                  final CustomerInfo customerInfo =
                      await Purchases.getCustomerInfo();
                  // access latest customerInfo
                  if (customerInfo.entitlements.active['ff_plus'] != null) {
                    final DateTime expiraryDate = DateTime.parse(
                      customerInfo
                          .entitlements.active['ff_plus']!.expirationDate!,
                    ).toLocal();
                    final DateFormat displayFormat =
                        DateFormat("MM/dd/yyyy hh:mm a");
                    if (mounted && context.mounted) {
                      showFFDialogWithChildren(
                        "Youre Subscribed!",
                        [
                          Column(
                            children: [
                              Text(
                                'Your benefits last until ${displayFormat.format(expiraryDate)}',
                              ),
                            ],
                          ),
                        ],
                        true,
                        FfButton(
                          text: "Awesome!",
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        context,
                      );
                    }
                  } else {
                    final offers = await Purchases.getOfferings();
                    final offer = offers.getOffering('ffigure_offering');
                    final paywallresult = await RevenueCatUI.presentPaywall(
                      offering: offer,
                      displayCloseButton: true,
                    );
                    if (_logging) {
                      logger.i('Paywall Result $paywallresult');
                    }
                    if ((paywallresult == PaywallResult.purchased ||
                            paywallresult == PaywallResult.restored) &&
                        context.mounted) {
                      Provider.of<UserModel>(context, listen: false)
                          .setPremium(Int64.ONE);
                    }
                  }
                } on PlatformException catch (e) {
                  // Error fetching customer info
                  if (_logging) {
                    logger.e(e.details);
                  }
                }
              },
            ),
            FFAppButton(
              fontSize: 20,
              isBack: true,
              height: 0.0751173708920188,
              text: "No Thanks",
              onPressed: () => {Navigator.of(context).pop()},
            ),
          );
  }

  Map<String, bool> states = {
    "pre-logging": true,
    "logging": false,
    "paused": false,
    "chatting": false,
    "post-logging": false,
    "investing": false,
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.03,
            child: SizedBox(
              width: MediaQuery.of(context).size.width.clamp(0, 400),
              child: WorkoutCalendar(
                isInteractable: false,
                workoutMinTime: minWorkoutTime,
              ),
            ),
          ),
          if (states['post-logging']!)
            Positioned(
                bottom: MediaQuery.of(context).size.height * -0.015,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 40,
                        top: 12,
                        bottom: 12,
                        right: 40,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height:
                          MediaQuery.of(context).size.height * 0.615, // 0.295
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color.fromRGBO(51, 133, 162, 1),
                          ),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(28, 109, 189, 0.29),
                            Color.fromRGBO(0, 164, 123, 0.29),
                          ],
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Consumer<UserModel>(
                              builder: (_, user, __) {
                                return Consumer<FigureModel>(
                                  builder: (_, figure, __) {
                                    return Column(
                                      children: states['investing']!
                                          ? [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Feeling Confident?",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineLarge!
                                                          .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface,
                                                          ),
                                                    ),
                                                    Center(
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                          top: 15,
                                                          bottom: 15,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            4,
                                                          ),
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                        ),
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                1,
                                                        height: 2,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Invest in your week to earn extra rewards if you reach your weekly workout goal. \n",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall!
                                                          .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface,
                                                          ),
                                                    ),
                                                    Text(
                                                      "NOTE: If you don't reach your goal by end of the week, you will lose the investment.",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall!
                                                          .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface,
                                                          ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Consumer<HistoryModel>(
                                                      builder:
                                                          (_, history, __) {
                                                        return Column(
                                                          children: [
                                                            WeekToGoShower(
                                                              boxSize: Size(
                                                                MediaQuery
                                                                        .sizeOf(
                                                                      context,
                                                                    ).width *
                                                                    0.09,
                                                                MediaQuery
                                                                        .sizeOf(
                                                                      context,
                                                                    ).width *
                                                                    0.09,
                                                              ),
                                                              weekGoal: user
                                                                  .user!
                                                                  .weekGoal
                                                                  .toInt(),
                                                              workouts: history
                                                                  .currentWeek,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                "Currently Invested: \$${history.investment.toStringAsFixed(2)}",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displaySmall!
                                                                    .copyWith(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .onSurface,
                                                                    )),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                    Consumer<UserModel>(
                                                      builder: (context, value,
                                                          child) {
                                                        return FFAppButton(
                                                          size: MediaQuery.sizeOf(
                                                                      context)
                                                                  .width *
                                                              0.85,
                                                          height: 50,
                                                          disabled: hasInvested,
                                                          isNoThanks:
                                                              hasInvested,
                                                          text:
                                                              "Invest ${(user.user!.currency.toInt() * 0.2).toStringAsFixed(2)}",
                                                          onPressed: () {
                                                            setState(() {
                                                              hasInvested =
                                                                  true;
                                                              _investment = value
                                                                      .user!
                                                                      .currency
                                                                      .toInt() *
                                                                  0.2;
                                                              Provider.of<
                                                                  HistoryModel>(
                                                                context,
                                                                listen: false,
                                                              ).setInvestment(
                                                                Provider.of<
                                                                        HistoryModel>(
                                                                      context,
                                                                      listen:
                                                                          false,
                                                                    ).investment +
                                                                    _investment,
                                                              );
                                                              final User user =
                                                                  Provider.of<
                                                                      UserModel>(
                                                                context,
                                                                listen: false,
                                                              ).user!;
                                                              user.currency =
                                                                  Int64(
                                                                (user.currency
                                                                            .toDouble() -
                                                                        _investment)
                                                                    .toInt(),
                                                              );
                                                              Provider.of<
                                                                  UserModel>(
                                                                context,
                                                                listen: false,
                                                              ).setUser(user);
                                                              Provider.of<
                                                                  CurrencyModel>(
                                                                context,
                                                                listen: false,
                                                              ).setCurrency(
                                                                user.currency
                                                                    .toString(),
                                                              );
                                                              auth.updateUserDBInfo(
                                                                routes.User(
                                                                  email: user
                                                                      .email,
                                                                  currency: user
                                                                      .currency,
                                                                ),
                                                              );
                                                            });
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]
                                          : [
                                              Row(
                                                children: [
                                                  RobotImageHolder(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.278169014084507,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4460559796437659,
                                                    url: figure
                                                        .composeFigureUrl(),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      WorkoutTimeShower(
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .displayMedium!,
                                                        workoutMinTime:
                                                            _timePassed.toInt(),
                                                        secondsTrueMinutesFalse:
                                                            true,
                                                        showStatus: true,
                                                        goalMet: _goalMet,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      StreakShower(
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .displayMedium!,
                                                        streak: user
                                                            .user!.streak
                                                            .toInt(),
                                                        showStatus: true,
                                                        goalMet: true,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Consumer<HistoryModel>(
                                                        builder: (_,
                                                            workoutHistory,
                                                            __) {
                                                          return Row(
                                                            children: [
                                                              WeekToGoShower(
                                                                weekGoal: user
                                                                    .user!
                                                                    .weekGoal
                                                                    .toInt(),
                                                                boxSize:
                                                                    const Size(
                                                                        16, 16),
                                                                workouts:
                                                                    workoutHistory
                                                                        .currentWeek,
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      ChargeBar(
                                                        barHeight: MediaQuery
                                                                    .of(context)
                                                                .size
                                                                .height *
                                                            0.0195305164319249,
                                                        barWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.5338422391857506,
                                                        fillColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                        currentCharge: figure
                                                            .figure!.charge,
                                                        showIcon: true,
                                                        showInfoCircle: true,
                                                      ),
                                                      Text("[+$addableCharge]",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontSize: 21.05,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xFFFF9E45))),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      EvBar(
                                                        currentXp: figure
                                                            .figure!.evPoints,
                                                        maxXp:
                                                            figure1.evCutoffs[
                                                                figure.EVLevel],
                                                        fillColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                        barHeight: MediaQuery
                                                                    .of(context)
                                                                .size
                                                                .height *
                                                            0.0195305164319249,
                                                        barWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.5338422391857506,
                                                        showInfoBox: true,
                                                        showIcon: true,
                                                      ),
                                                      Text(
                                                        "[+$addableEV]",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Roboto",
                                                            fontSize: 21.05,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xFF00A7E1)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                    );
                                  },
                                );
                              },
                            ),
                            FFAppButton(
                              text: "AWESOME!",
                              fontSize: 20,
                              size: MediaQuery.of(context).size.width *
                                  0.85272264631043256997455470737913,
                              height: MediaQuery.of(context).size.height *
                                  0.0946478873239436619718309859155,
                              onPressed: () => {
                                if (states['investing']!)
                                  setState(() {
                                    states['investing'] = false;
                                    endLogging();
                                  })
                                else
                                  setState(() {
                                    states['post-logging'] = false;
                                    states['pre-logging'] = true;
                                    states['investing '] = false;

                                    _logging = false;
                                    _goalMet = false;
                                    _investment = 0;
                                    _timePassed = Int64.ZERO;
                                  }),
                              },
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ))
          else
            Positioned(
              bottom: MediaQuery.of(context).size.height * -0.015,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: states['chatting']!
                    ? [
                        Container(
                            padding: const EdgeInsets.only(
                              left: 40,
                              top: 12,
                              bottom: 12,
                              right: 40,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height *
                                0.615, // 0.295
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color.fromRGBO(51, 133, 162, 1),
                                ),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(28, 109, 189, 0.29),
                                  Color.fromRGBO(0, 164, 123, 0.29),
                                ],
                              ),
                            ),
                            child: Column(children: [
                              FutureBuilder<String>(
                                future: _postWorkoutMessage,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return BinaryGlowChatBubble(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      message: snapshot.data!,
                                      chatMore: true,
                                    );
                                  } else if (snapshot.hasError) {
                                    return BinaryGlowChatBubble(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      message:
                                          "[CRITICAL CHAT MODULE ERR ::Code 402::]",
                                    );
                                  } else {
                                    return const SizedBox(
                                      width: 100,
                                      height: 60,
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Consumer<FigureModel>(
                                    builder: (_, figure, __) {
                                      return RobotImageHolder(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.278169014084507,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4452926208651399,
                                        url: figure.composeFigureUrl(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              FFAppButton(
                                fontSize: 20,
                                size: MediaQuery.of(context).size.width *
                                    0.85272264631043256997455470737913,
                                height: MediaQuery.of(context).size.height *
                                    0.0946478873239436619718309859155,
                                text: "OK",
                                onPressed: () => {
                                  setState(() {
                                    states['chatting'] = false;
                                    if (_goalMet) {
                                      states['post-logging'] = true;
                                      states['investing'] = true;
                                    } else {
                                      states['investing'] = false;
                                      endLogging();
                                      states['post-logging'] = true;
                                    }
                                  }),
                                },
                              ),
                            ])),
                        const SizedBox(
                          height: 10,
                        ),
                      ]
                    : [
                        Consumer<FigureModel>(
                          builder: (_, figure, __) {
                            return Stack(
                              children: [
                                RobotImageHolder(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  width: MediaQuery.of(context).size.width,
                                  url: figure.composeFigureUrl(),
                                ),
                                // DraggableAdminPanel(
                                //   onButton1Pressed: add10Minutes,
                                //   onButton2Pressed: add30Seconds,
                                //   button1Text: "add 10 min",
                                //   button2Text: "add 30 sec",
                                // ),
                              ],
                            );
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 12,
                            right: 14,
                          ),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color.fromRGBO(51, 133, 162, 1),
                              ),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(28, 109, 189, 0.29),
                                Color.fromRGBO(0, 164, 123, 0.29),
                              ],
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.285,
                          // doWeBinkTheBorder: false,
                          // radius: 0,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: states["logging"]!
                                      ? [
                                          GestureDetector(
                                            onTap: () => {endWorkout()},
                                            child: Icon(
                                              Icons.stop,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 60,
                                            ),
                                          ),
                                          Text(
                                            formatSeconds(time.toInt()),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                          ),
                                          GestureDetector(
                                            onTap: () => {
                                              if (states["paused"]!)
                                                resumeTimer()
                                              else
                                                pauseTimer(),
                                            },
                                            child: states["paused"]!
                                                ? Icon(
                                                    Icons.play_arrow,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    size: 60,
                                                  )
                                                : Icon(
                                                    Icons.pause,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    size: 60,
                                                  ),
                                          ),
                                        ]
                                      : [
                                          Consumer<FigureModel>(
                                            builder: (_, figure, __) {
                                              return Consumer<HistoryModel>(
                                                builder: (
                                                  _,
                                                  workoutHistory,
                                                  __,
                                                ) {
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          ChargeBar(
                                                            didWeWorkoutToday:
                                                                workoutHistory
                                                                    .workedOutToday,
                                                            simulateCurrentGains:
                                                                true,
                                                            showIcon: true,
                                                            barHeight: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.0157863849765258215962441314554, // sizes calculated from figma
                                                            barWidth: MediaQuery
                                                                    .of(
                                                                  context,
                                                                ).size.width *
                                                                0.43531806615776081424936386768448,
                                                            fillColor: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .tertiary,
                                                            currentCharge:
                                                                figure.figure!
                                                                    .charge,
                                                            iconSize: 40,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          EvBar(
                                                              showIcon: true,
                                                              didWeWorkoutToday:
                                                                  workoutHistory
                                                                      .workedOutToday,
                                                              simulateCurrentGains:
                                                                  true,
                                                              areWeShadowing:
                                                                  true,
                                                              currentXp: figure
                                                                  .figure!
                                                                  .evPoints,
                                                              maxXp: figure1
                                                                      .evCutoffs[
                                                                  figure
                                                                      .EVLevel],
                                                              fillColor:
                                                                  Theme.of(
                                                                context,
                                                              )
                                                                      .colorScheme
                                                                      .secondary,
                                                              barHeight: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.0157863849765258215962441314554,
                                                              barWidth: MediaQuery
                                                                      .of(
                                                                    context,
                                                                  ).size.width *
                                                                  0.43531806615776081424936386768448,
                                                              iconSize: 40),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          Consumer<UserModel>(
                                            builder: (_, user, __) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  WorkoutTimeShower(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium!,
                                                    workoutMinTime: user
                                                        .user!.workoutMinTime
                                                        .toInt(),
                                                  ),
                                                  SizedBox(
                                                    height: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .height *
                                                        0.016431924882629107981220657277,
                                                  ),
                                                  StreakShower(
                                                    goalMet: true,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium!,
                                                    streak: user.user!.streak
                                                        .toInt(),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                ),
                              ),
                              states['pre-logging']!
                                  ? FFAppButton(
                                      icon: Icons.add,
                                      iconPadding:
                                          MediaQuery.of(context).size.width *
                                              0.15,
                                      text: "START WORKOUT",
                                      fontSize: 20,
                                      size: MediaQuery.of(context).size.width *
                                          0.85272264631043256997455470737913,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.0946478873239436619718309859155,
                                      onPressed: () {
                                        startLogging(false);
                                        startTimer(false, false);
                                      },
                                      isShiny: true,
                                    )
                                  : states['paused']!
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.0461971830985915492957746478873),
                                          child: FFAppButton(
                                            icon: Icons.add,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85272264631043256997455470737913,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.0946478873239436619718309859155,
                                            fontSize: 20,
                                            text: 'COMPLETE WORKOUT',
                                            onPressed: () => {endWorkout()},
                                          ))
                                      : WorkoutProgressBar(
                                          progress: ((_timer.milliseconds /
                                                  1000) /
                                              (Provider.of<UserModel>(context,
                                                          listen: false)
                                                      .user!
                                                      .workoutMinTime
                                                      .toInt() *
                                                  60)),
                                          width: 300,
                                          height: 30,
                                        ),
                            ],
                          ),
                        ),
                      ],
              ),
            )
        ],
      ),
    );
  }
}
