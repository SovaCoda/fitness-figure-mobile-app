import 'dart:async';
import 'dart:ui';
import 'package:ffapp/components/resuables/week_goal_shower.dart';
import 'package:ffapp/components/utils/chat_model.dart';
import 'package:ffapp/components/utils/time_utils.dart';
import 'package:ffapp/services/dynamic_island_manager.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:ffapp/components/admin_panel.dart';
import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/legacy_charge_bar.dart';
import 'package:ffapp/components/legacy_ev_bar.dart';
import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/components/resuables/chat_bubble.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:ffapp/components/resuables/streak_shower.dart';
import 'package:ffapp/components/resuables/week_to_go_shower.dart';
import 'package:ffapp/components/resuables/workout_time_shower.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/components/utils/history_model.dart';
import 'package:ffapp/components/workout_calendar.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:ffapp/services/robotDialog.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

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
      prefs: null, timerName: "workout", onTick: () => {}, tickSpeedMS: 1000);
  Int64 time = Int64(0);
  Int64 _timePassed = Int64(0);
  late Int64 _timegoal = Int64(0);
  late String _startTime, _endTime;
  late AuthService auth;
  late String figureURL = "robot1_skin0_cropped";
  RobotDialog robotDialog = RobotDialog();
  final int RANDRANGE = 100;
  final double OFFSET = 250 / 4;
  late double scoreIncrement;
  final int sigfigs = 2;
  bool _goalMet = false;
  int minWorkoutTime = 30;
  double _investment = 0;
  SharedPreferences? prefs;
  bool hasInvested = false;
  late Future<String>? _postWorkoutMessage;


  late final AppLifecycleListener _listener;
  late AppLifecycleState? _lifeState;
  final List<String> _lifeStates = <String>[];
  DynamicIslandManager liveActivityManager = DynamicIslandManager(channelKey: "LI"); // class that can use method channels to communicate with Ios App

  @override
  void initState() {
    super.initState();
    _lifeState = SchedulerBinding.instance!.lifecycleState;
    _listener = AppLifecycleListener(

      onRestart: () {
         logger.i("restarted");
      },
      onResume: () async {
        logger.i("resumed");
        
        _timer.loadTime();
      },
      onExitRequested: () async{
        logger.i('shutting down ');
        liveActivityManager.stopLiveActivity();
        return AppExitResponse.exit;
      },
      onDetach: () {
        logger.i("detached");
        liveActivityManager.stopLiveActivity();
        if (states['logging']! && !states['paused']!) {
          prefs!.setBool("hasOngoingWorkout", true);
          prefs!.setBool("hasOngoingWorkoutPaused", false);
        }

        if (states['paused']!) prefs!.setBool("hasOngoingWorkoutPaused", true);
      },
    );
    initialize();

    auth = Provider.of<AuthService>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        minWorkoutTime = Provider.of<UserModel>(context, listen: false)
            .user!
            .workoutMinTime
            .toInt();
      });
    });
  }

  void stopLiveActivities(DynamicIslandManager liveActivityManager) {
  for (int i = 0; i < 5; i++) {
    try {
      liveActivityManager.stopLiveActivity();
      print('Successfully stopped live activity on attempt ${i + 1}');
      break; 
    } catch (err) {
      print('Attempt ${i + 1} failed: $err');

    }
  }
  print('Finished trying to stop live activities.');
}

  void initialize({bool restartLiveActivity = true}) async {
    stopLiveActivities(liveActivityManager);
    prefs = await SharedPreferences.getInstance();
    User user = await getUserModel().then((value) => value.user!);
    Int64 timegoal = user.workoutMinTime;
    scoreIncrement = 1 / (timegoal.toDouble() * 60);
    logger.i(timegoal);

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
      userModel = Provider.of<UserModel>(context, listen: false);
    } while (userModel.user == User());
    return userModel;
  }

  void startTimer(bool isInit, bool restartLiveActivity) async {
    _timer = PersistantTimer(
        prefs: prefs,
        timerName: "workout_timer",
        onTick: () {
          if (mounted) {
            liveActivityManager.updateLiveActivity(jsonData: DynamicIslandStopwatchDataModel(elapsedSeconds: time.toInt() + 1, timeGoal: _timegoal.toInt(), paused: false).toMap());
            setState(() {
              if (mounted) {
                time = Int64(_timer.getTimeInSeconds());
                if (time >= _timegoal) {
                  _goalMet = true;
                  if (time == _timegoal) {
                    LocalNotificationService().showNotification(
                      id: 0,
                      title: "Goal Met!",
                      body: "You have met your workout goal.",
                    );
                    logger.i('Goal met, sending user notification');
                  }
                }
              }
            });
          }
        },
        tickSpeedMS: 1000,
        milliseconds: 0);
    if (_timer.hasStoredTime()) {
      states["logging"] = true;
      states["paused"] = _timer.hasStoredPauseTime();
      states["pre-logging"] = false;
      await _timer.start();
      
      setState(() {
        time = Int64(_timer.getTimeInSeconds());
      });
      
      liveActivityManager.startLiveActivity(jsonData: DynamicIslandStopwatchDataModel(elapsedSeconds: time.toInt(), timeGoal: _timegoal.toInt(), paused: _timer.hasStoredPauseTime()).toMap());
    } else {
      if (!isInit) {
        liveActivityManager.startLiveActivity(jsonData: DynamicIslandStopwatchDataModel(elapsedSeconds: 0, timeGoal: _timegoal.toInt(), paused: false).toMap());
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

  void resumeTimer() async {
    liveActivityManager.updateLiveActivity(jsonData: DynamicIslandStopwatchDataModel(elapsedSeconds: time.toInt() + 1, timeGoal: _timegoal.toInt(), paused: false).toMap());
    _timer.resume();
    setState(() {
      states['paused'] = false;
    });
  }

  void pauseTimer() async {
    liveActivityManager.updateLiveActivity(jsonData: DynamicIslandStopwatchDataModel(elapsedSeconds: time.toInt() + 1, timeGoal: _timegoal.toInt(), paused: true).toMap());
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
    liveActivityManager.stopLiveActivity();
    if(_timer.classTimer != null){
      _timer.dispose();
    }
    super.dispose();
  }

  Future<void> endLogging() async {
    liveActivityManager.stopLiveActivity();
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
    await awardAll(weeklyGoalMet: false, timeGoalMet: _goalMet, investment: _investment);

  }

  int addableEV = 50;
  int addableCharge = 0;
  //function that does all the awarding in one
  Future<void> awardAll(
      {required bool weeklyGoalMet,
      required bool timeGoalMet,
      double investment = 0}) async {
    UserModel user = Provider.of<UserModel>(context, listen: false);
    FigureInstance figureInstance =
        Provider.of<FigureModel>(context, listen: false).figure!;
    HistoryModel history = Provider.of<HistoryModel>(context, listen: false);

    double workoutPercent =
        (_timePassed.toDouble() / _timegoal.toDouble()).clamp(0, 1);

    double maxEVGain = figure1.EvCutoffs[figureInstance.evLevel].toDouble() / 5;
    double baseEVGain = user.isPremium() ? 75.00 : 50.00;
    double eVConcistencyBonus = (10) * user.user!.streak.toDouble();
    addableEV = history.workedOutToday
        ? (baseEVGain * workoutPercent).ceil()
        : ((maxEVGain + eVConcistencyBonus) * workoutPercent).ceil();
    int totalEV = (figureInstance.evPoints + addableEV).toInt();

    int baseChargeGain = user.isPremium() ? 6 : 5;
    int chargeConcistencyBonus = ((0.25) * user.user!.streak.toInt()).ceil();
    addableCharge = history.workedOutToday
        ? 0
        : (baseChargeGain + chargeConcistencyBonus) * workoutPercent.floor();
    int totalCharge = figureInstance.charge + addableCharge;

    setState(() {
      addableCharge = addableCharge;
      addableEV = addableEV;
    });

    Provider.of<FigureModel>(context, listen: false).setFigureEv(totalEV);
    Provider.of<FigureModel>(context, listen: false)
        .setFigureCharge(!weeklyGoalMet
            ? ((totalCharge) > 100)
                ? 100
                : totalCharge
            : figureInstance.charge);

    // if we havent worked out today, update the user's streak and week complete
    if (!Provider.of<HistoryModel>(context, listen: false).workedOutToday &&
        timeGoalMet) {
      await auth.updateUserDBInfo(Routes.User(
          email: user.user!.email,
          streak: Int64(user.user!.streak.toInt() + 1),
          weekComplete: Int64(user.user!.weekComplete.toInt() + 1)));

      Provider.of<UserModel>(context, listen: false)
          .setUserWeekCompleted(Int64(user.user!.weekComplete.toInt() + 1));
      Provider.of<UserModel>(context, listen: false).user!.streak =
          Int64(user.user!.streak.toInt() + 1);
    }

    figureInstance = Provider.of<FigureModel>(context, listen: false).figure!;

    await auth.updateFigureInstance(FigureInstance(
        figureId: figureInstance.figureId,
        userEmail: user.user!.email,
        figureName: figureInstance.figureName,
        charge: (figureInstance.charge).toInt(),
        evPoints: (figureInstance.evPoints).toInt()));

    Workout workout = Workout(
      startDate: _startTime,
      endDate: _endTime,
      elapsed: _timePassed,
      email: await auth.getUser().then((value) => value!.email.toString()),
      chargeAdd: Int64(addableCharge),
      evoAdd: Int64(addableEV),
      investment: investment,
      countable: workoutPercent >= 1 ? 1 : 0,
    );
    Provider.of<HistoryModel>(context, listen: false).addWorkout(workout);

    final SharedPreferences prefs = await _prefs;
    if (prefs.getBool("hasSurveyed") == null ||
        prefs.getBool("hasSurveyed") == true) {}
        
  }

  add30Seconds() {
    setState(() {
      time += Int64(30);
    });
  }

  add10Minutes() {
    setState(() {
      time += Int64(600);
    });
  }

  void endWorkout() async {
    if (time < _timegoal.toInt()) {
      showFFDialogBinary(
        "Hold on!",
        "You havent worked out at least as long as ${formatSeconds(_timegoal.toInt())}! If you stop now, this workout won't contribute to your weekly goal and you'll gain no charge, you will still recieve evo for the time you worked out.",
        true,
        context,
        FfButton(
            height: 50,
            text: "I'll keep at it!",
            textStyle: Theme.of(context).textTheme.displayMedium!,
            textColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () => {Navigator.of(context).pop()}),
        FfButton(
            height: 50,
            text: "End workout",
            textStyle: Theme.of(context).textTheme.displayMedium!,
            textColor: Theme.of(context).colorScheme.onSurface,
            backgroundColor:
                Theme.of(context).colorScheme.surface.withAlpha(126),
            onPressed: () async => {
               liveActivityManager.stopLiveActivity(),
                  setState(() {
                    _timePassed = time;
                    states['chatting'] = true;
                    states['logging'] = false;
                    _postWorkoutMessage = generatePostWorkoutComment();
                  }),
                  Navigator.of(context).pop()
                }),
      );
    } else {
      liveActivityManager.stopLiveActivity();
      setState(() {
        _timePassed = time;
        states['chatting'] = true;
        states['logging'] = false;
        _postWorkoutMessage = generatePostWorkoutComment();
      });
    }
  }

  Future<String>? generatePostWorkoutComment () async { 
    if(Provider.of<UserModel>(context, listen: false).user!.hasPremium()) {
      return Provider.of<ChatModel>(context, listen: false).generatePostWorkoutMessage({"workoutTimeMinutes" : _timePassed.toDouble()/60, "workoutTimeNeededMinutes" : _timegoal.toDouble()/60})!;
    } else {
      if(_goalMet) {return ("Awesome job! Keep up workouts like this and we'll evolve in no time at all!");}
      else {return ("Looks like we were short of our workout goal... if we want to make progress we need to train hard!");}
    }
  }

  void chatMore(context) async {
    Provider.of<UserModel>(context, listen: false).isPremium()
        ? GoRouter.of(context).go('/chat')
        : showFFDialogBinary(
            "FF+ Premium Feature",
            "Subscribe now to FF+ to gain acess to chatting with your figure. Your figure can help you with all your fitness goals as well as assist in managing your growth! \n \nAdditionally, you earn extra rewards and cosmetics while you're subscribed!",
            true,
            context,
            FfButton(
              height: 50,
              text: "Subscribe Now \$1.99",
              textStyle: Theme.of(context).textTheme.displayMedium!,
              textColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () async {
                try {
                  CustomerInfo customerInfo = await Purchases.getCustomerInfo();
                  // access latest customerInfo
                  if (customerInfo.entitlements.active['ff_plus'] != null)
                  {
                    DateTime expiraryDate = DateTime.parse(customerInfo.entitlements.active['ff_plus']!.expirationDate!).toLocal();
                    DateFormat displayFormat = DateFormat("MM/dd/yyyy hh:mm a");
                    showFFDialogWithChildren("Youre Subscribed!", [
                      Column(children: [
                        Text('Your benefits last until ${displayFormat.format(expiraryDate)}')
                      ],)
                    ], true, FfButton(text: "Awesome!", textColor: Theme.of(context).colorScheme.onPrimary, backgroundColor: Theme.of(context).colorScheme.primary, onPressed: () => Navigator.of(context).pop()), context);
                  }
                  else {
                    final offers = await Purchases.getOfferings();
                    final offer = offers.getOffering('ffigure_offering');
                    final paywallresult = await RevenueCatUI.presentPaywall(offering: offer, displayCloseButton: true);
                    logger.i('Paywall Result $paywallresult');
                    if(paywallresult == PaywallResult.purchased || paywallresult == PaywallResult.restored){
                      Provider.of<UserModel>(context, listen: false).setPremium(Int64.ONE);
                    }
                  }
                } on PlatformException catch (e) {
                    // Error fetching customer info
                  }}
            ),
            FfButton(
                height: 50,
                text: "No Thanks",
                textStyle: Theme.of(context).textTheme.displayMedium!,
                textColor: Theme.of(context).colorScheme.onSurface,
                backgroundColor:
                    Theme.of(context).colorScheme.surface.withAlpha(126),
                onPressed: () => {Navigator.of(context).pop()}));
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
          states['post-logging']!
              ? Container()
              : Positioned(
                  top: 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width.clamp(0, 400),
                    child: WorkoutCalendar(
                      calendarFormat: CalendarFormat.week,
                      isInteractable: false,
                      workoutMinTime: minWorkoutTime,
                      showWorkoutData: false,
                    ),
                  )),
          states['post-logging']!
              ? Column(
                  children: [
                    Expanded(
                      child: GradientedContainer(
                          radius: 2,
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.all(20),
                          child: Consumer<UserModel>(builder: (_, user, __) {
                            return Consumer<FigureModel>(
                                builder: (_, figure, __) {
                              return Column(
                                children: states['investing']!
                                    ? [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Feeling Confident?",
                                                textAlign: TextAlign.start,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface),
                                              ),
                                              Center(
                                                  child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 15, bottom: 15),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    shape: BoxShape.rectangle,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        1,
                                                height: 2,
                                              )),
                                              Text(
                                                "Invest in your week to earn extra rewards if you reach your weekly workout goal. \n",
                                                textAlign: TextAlign.start,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface),
                                              ),
                                              Text(
                                                "NOTE: If you don't reach your goal by end of the week, you will lose the investment.",
                                                textAlign: TextAlign.start,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              WeekGoalShower(
                                                  weeklyCompleted: user
                                                      .user!.weekComplete
                                                      .toInt(),
                                                  weeklyGoal: user
                                                      .user!.weekGoal
                                                      .toInt()),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Consumer<HistoryModel>(
                                                builder: (_, history, __) {
                                                  return Column(
                                                    children: [
                                                      WeekToGoShower(
                                                          boxSize: Size(
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.11,
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.11),
                                                          weekGoal: user
                                                              .user!.weekGoal
                                                              .toInt(),
                                                          workouts: history
                                                              .currentWeek),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Currently Invested: \$${history.investment.toStringAsFixed(2)}",
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              Consumer<UserModel>(
                                                builder:
                                                    (context, value, child) {
                                                  return FfButton(
                                                    disabled: hasInvested,
                                                      text:
                                                          "Invest ${(user.user!.currency.toInt() * 0.2).toStringAsFixed(2)}",
                                                      textColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .surface,
                                                      onPressed: () {
                                                        setState(() {
                                                          hasInvested = true;
                                                          _investment = value
                                                                  .user!
                                                                  .currency
                                                                  .toInt() *
                                                              0.2;
                                                          Provider.of<HistoryModel>(
                                                                  context,
                                                                  listen: false)
                                                              .setInvestment(Provider.of<
                                                                              HistoryModel>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .investment +
                                                                  _investment);
                                                          User user = Provider
                                                                  .of<UserModel>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .user!;
                                                          user.currency = Int64((user
                                                                      .currency
                                                                      .toDouble() -
                                                                  _investment)
                                                              .toInt());
                                                          Provider.of<UserModel>(
                                                                  context,
                                                                  listen: false)
                                                              .setUser(user);
                                                          Provider.of<CurrencyModel>(context, listen: false).setCurrency(user.currency.toString());
                                                          auth.updateUserDBInfo(
                                                              Routes.User(
                                                                  email: user
                                                                      .email,
                                                                  currency: user
                                                                      .currency));
                                                        });
                                                      });
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ]
                                    : [
                                        Row(
                                          children: [
                                            RobotImageHolder(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              url: figure.composeFigureUrl(),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                WorkoutTimeShower(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium!,
                                                    workoutMinTime:
                                                        _timePassed.toInt(),
                                                    secondsTrueMinutesFalse:
                                                        true,
                                                    showStatus: true,
                                                    goalMet: _goalMet),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                StreakShower(
                                                  showChevron: false,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium!,
                                                  streak:
                                                      user.user!.streak.toInt(),
                                                  showStatus: true,
                                                  goalMet: true,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Consumer<HistoryModel>(builder:
                                                    (_, workoutHistory, __) {
                                                  return Row(children: [
                                                    WeekToGoShower(
                                                        weekGoal: user
                                                            .user!.weekGoal
                                                            .toInt(),
                                                        boxSize:
                                                            const Size(16, 16),
                                                        workouts: workoutHistory
                                                            .currentWeek)
                                                  ]);
                                                }),
                                              ],
                                            )
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
                                                  barHeight: 10,
                                                  barWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2,
                                                  fillColor: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  currentCharge:
                                                      figure.figure!.charge,
                                                ),
                                                Text(
                                                  "[+$addableCharge%]",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium!
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                EvBar(
                                                  currentXp:
                                                      figure.figure!.evPoints,
                                                  maxXp: figure1.EvCutoffs[
                                                      figure.EVLevel],
                                                  fillColor: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  barHeight: 10,
                                                  barWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2,
                                                ),
                                                Text(
                                                  "(+$addableEV)",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium!
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                              );
                            });
                          })),
                    ),
                    FfButton(
                        height: 90,
                        text: "Awesome!",
                        textStyle: Theme.of(context).textTheme.headlineLarge!,
                        textColor: Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
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

                                })
                            }),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
              : 
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: states['chatting']!
                      ? [
                          FutureBuilder<String> (
                            future: _postWorkoutMessage,
                            builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ChatBubble(message: snapshot.data!);
                            } else if (snapshot.hasError) {
                              return const ChatBubble(message: "[CRITICAL CHAT MODULE ERR ::Code 402::]");
                            } else {
                              return const SizedBox(width: 100, height: 60, child: CircularProgressIndicator(),);
                            }
                          },),
                          Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Consumer<FigureModel>(
                                builder: (_, figure, __) {
                                  return RobotImageHolder(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    url: figure.composeFigureUrl(),
                                  );
                                },
                              ),
                              FfButton(
                                  height: 45,
                                  width: MediaQuery.sizeOf(context).width / 2,
                                  text: "Chat More >",
                                  textStyle:
                                      Theme.of(context).textTheme.displaySmall!,
                                  textColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  onPressed: () => {chatMore(context)})
                            ],
                          )),
                          FfButton(
                              height: 90,
                              text: "Awesome!",
                              textStyle:
                                  Theme.of(context).textTheme.headlineLarge!,
                              textColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
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
                                      
                                    })
                                  }),
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
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GradientedContainer(
                              height: 100,
                              doWeBinkTheBorder: false,
                              radius: 0,
                              child: Padding(
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
                                                        .onSurface),
                                          ),
                                          GestureDetector(
                                            onTap: () => {
                                              states["paused"]!
                                                  ? resumeTimer()
                                                  : pauseTimer()
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
                                                  builder:
                                                      (_, workoutHistory, __) {
                                                return Column(
                                                  children: [
                                                    ChargeBar(
                                                      didWeWorkoutToday:
                                                          workoutHistory
                                                              .workedOutToday,
                                                      areWeShadowing: true,
                                                      simulateCurrentGains:
                                                          true,
                                                      barHeight: 10,
                                                      barWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      fillColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                      currentCharge:
                                                          figure.figure!.charge,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    EvBar(
                                                      didWeWorkoutToday:
                                                          workoutHistory
                                                              .workedOutToday,
                                                      simulateCurrentGains:
                                                          true,
                                                      areWeShadowing: true,
                                                      currentXp: figure
                                                          .figure!.evPoints,
                                                      maxXp: figure1.EvCutoffs[
                                                          figure.EVLevel],
                                                      fillColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                      barHeight: 10,
                                                      barWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                );
                                              });
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
                                                  const SizedBox(
                                                    height: 5,
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
                                          )
                                        ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: states['logging']!
                                ? FfButtonProgressable(
                                    progress:
                                        (time.toDouble() / _timegoal.toDouble())
                                            .clamp(0, 1),
                                    disabled: false,
                                    height: 90,
                                    icon: Icons.add,
                                    iconSize: 50,
                                    text: 'Complete Workout',
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!,
                                    textColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    onPressed: () => 
                                    { endWorkout()
                                    })
                                : FfButton(
                                    icon: Icons.add,
                                    iconSize: 50,
                                    text: "Start Workout",
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!,
                                    height: 90,
                                    textColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    onPressed: () {
                                      startLogging(false);
                                      startTimer(false, false);
                                    },
                                  ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                ),
        ],
      ),
    );
  }
}
