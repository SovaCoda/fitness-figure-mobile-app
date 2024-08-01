import 'dart:async';
import 'dart:math';

import 'package:ffapp/components/admin_panel.dart';
import 'package:ffapp/components/animated_points.dart';
import 'package:ffapp/components/backed_figure_holder.dart';
import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/components/popup.dart';
import 'package:ffapp/components/progress_bar.dart';
import 'package:ffapp/components/robot_dialog_box.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:ffapp/services/robotDialog.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutAdder extends StatefulWidget {
  const WorkoutAdder({super.key});

  @override
  State<WorkoutAdder> createState() => _WorkoutAdderState();
}

class _WorkoutAdderState extends State<WorkoutAdder> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final logger = Logger();
  bool _logging = false;
  Timer _timer = Timer(Duration.zero, () {});
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

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
  }

  void startTimer() {
    UserModel? userModel = Provider.of<UserModel>(context, listen: false);
    User user = userModel.user != null ? userModel.user! : User();
    Int64 timegoal = user.workoutMinTime;
    scoreIncrement = 1 / (timegoal.toDouble() * 60);
    logger.i(timegoal);
    setState(() {
      if (timegoal != Int64.ZERO) {
        _timegoal = timegoal * 60; //convert to seconds
      }
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time++;
        if (time == _timegoal) {
          _goalMet = true;
          LocalNotificationService().showNotification(
            id: 0,
            title: "Goal Met!",
            body: "You have met your workout goal.",
          );
          logger.i('Goal met, sending user notification');
        }
      });
    });
  }

  String formatSeconds(int seconds) {
    final formatter = NumberFormat('00');
    String hours = formatter.format((seconds / 3600).floor());
    String minutes = formatter.format(((seconds % 3600) / 60).floor());
    String second = formatter.format((seconds % 60));
    return "$hours:$minutes:$second";
  }

  void startLogging() {
    setState(() {
      _logging = true;
      _startTime = DateTime.now().toString();
    });
  }

  //function that does all the awarding in one
  Future<void> awardAll({required bool weeklyGoalMet}) async {
    User user = Provider.of<UserModel>(context, listen: false).user!;
    FigureInstance figureInstance =
        Provider.of<FigureModel>(context, listen: false).figure!;
    Figure figure =
        await auth.getFigure(Figure(figureName: figureInstance.figureName));
    int currency =
        int.parse(Provider.of<CurrencyModel>(context, listen: false).currency);
    int addableCurrency = _timePassed.toInt() ~/ 10;
    currency += addableCurrency;

    int figureEV = figure.baseEvGain;
    double eVConcistencyBonus = (figureEV * 0.1) * user.weekComplete.toInt();
    int addableEV = _timePassed.toInt() ~/ 10;
    int ev = figureEV + eVConcistencyBonus.toInt() + addableEV;

    int figureCharge = 5; // needs to be replaced with the figure provider.
    double chargeConcistencyBonus =
        (figureCharge * 0.1) * user.weekComplete.toInt();
    int addableCharge = _timePassed.toInt() ~/ user.workoutMinTime.toInt();
    int charge = figureCharge + chargeConcistencyBonus.toInt() + addableCharge;

    await auth.updateUserDBInfo(Routes.User(
        email: user.email,
        currency: Int64(currency),
        weekComplete: Int64(user.weekComplete.toInt() + 1)));

    Provider.of<CurrencyModel>(context, listen: false)
        .setCurrency(currency.toString());
    Provider.of<FigureModel>(context, listen: false)
        .setFigureEv(figureInstance.evPoints + ev);
    Provider.of<FigureModel>(context, listen: false)
        .setFigureCharge(!weeklyGoalMet
            ? ((figureInstance.charge + charge) > 100)
                ? 100
                : figureInstance.charge + charge
            : figureInstance.charge);
    Provider.of<UserModel>(context, listen: false)
        .setUserWeekCompleted(Int64(user.weekComplete.toInt() + 1));
    figureInstance = Provider.of<FigureModel>(context, listen: false).figure!;
    user = Provider.of<UserModel>(context, listen: false).user!;
    await auth.updateFigureInstance(FigureInstance(
        figureId: figureInstance.figureId,
        userEmail: user.email,
        figureName: figureInstance.figureName,
        charge: (figureInstance.charge).toInt(),
        evPoints: (figureInstance.evPoints).toInt()));
    // Routes.FigureInstance? databaseFigure = await auth.getFigureInstance(
    //       Routes.FigureInstance(
    //         userEmail: Provider.of<UserModel>(context, listen: false).user?.email,
    //         figureName: Provider.of<UserModel>(context, listen: false).user?.curFigure));
    // Provider.of<FigureModel>(context, listen: false).setFigure(databaseFigure);

    final SharedPreferences prefs = await _prefs;
    if (prefs.getBool("hasSurveyed") == null ||
        prefs.getBool("hasSurveyed") == true) {
      // showDialog(
      //   context: context,
      //   builder: (context) => const PopupWidget(
      //     message:
      //         'Congratulations on completing your workout, would you like to take a quick 3 minute survey on how you\'re liking Fitness Figure so far?',
      //   ),
      // );
    }
  }

  Future<void> endLogging() async {
    _timePassed = time;
    time = Int64.ZERO;
    _endTime = DateTime.now().toString();
    Workout workout = Workout(
      startDate: _startTime,
      endDate: _endTime,
      elapsed: _timePassed,
      email: await auth.getUser().then((value) => value!.email.toString()),
      chargeAdd: Int64(Random.secure().nextInt(100)),
      currencyAdd: Int64(Random.secure().nextInt(1000)),
    );
    await auth.createWorkout(workout);
    var user = Provider.of<UserModel>(context, listen: false).user;
    if (user!.weekComplete >= user.weekGoal) {
      setState(() {
        _logging = false;
        _timer.cancel();
      });
      await awardAll(weeklyGoalMet: true);
      return;
    }
    await awardAll(weeklyGoalMet: false);
    setState(() {
      _logging = false;
      _timer.cancel();
    });
  }

  Widget imSureButton() {
    return FfButton(
        onPressed: () {
          Navigator.of(context).pop();
          endLogging();
        },
        text: "I'm Sure",
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        textColor: Theme.of(context).colorScheme.primaryFixedDim);
  }

  Widget noIllKeepAtIt() {
    return FfButton(
        onPressed: () {
          Navigator.of(context).pop();
          endLogging();
        },
        text: "No, I'll keep at it!",
        backgroundColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.primaryFixedDim);
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


  bool _isProcessing = false;
  Timer? _debounceTimer;

  void showConfirmationBox() async {
    if (_isProcessing) {
      return;
    }
    _isProcessing = true;
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      _isProcessing = false;
    });
    if (time < _timegoal.toInt()) {
      showDialog(
          context: context,
          builder: (context) {
            return FfAlertDialog(
              child: Column(
                children: [
                  Text(
                    "Are you sure?",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.surface),
                  ),
                  Text(
                    "You haven't worked out at least as long as ${formatSeconds(_timegoal.toInt())}, if you stop now this workout will be logged, but you will only gain currency and EV points. Are you sure you want to stop?",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.surface),
                  ),
                  FfButton(
                      onPressed: () {
                        Navigator.pop(context);
                        endLogging();
                      },
                      text: "I'm Sure",
                      backgroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      textColor: Theme.of(context).colorScheme.primaryFixedDim),
                  FfButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: "No, I'll keep at it!",
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      textColor: Theme.of(context).colorScheme.primaryFixedDim),
                ],
              ),
            );
          });
    } else {
      FigureInstance figureInstance =
          Provider.of<FigureModel>(context, listen: false).figure!;
      Figure figure =
          await auth.getFigure(Figure(figureName: figureInstance.figureName));
      int currency = int.parse(
          Provider.of<CurrencyModel>(context, listen: false).currency);
      int addableCurrency = time.toInt() ~/ 10;
      currency += addableCurrency;

      var user = Provider.of<UserModel>(context, listen: false).user;

      int figureEV = figure.baseEvGain;
      double eVConcistencyBonus = (figureEV * 0.1) * user!.weekComplete.toInt();
      int ev = figureEV + eVConcistencyBonus.toInt();

      int charge = 0;
      if (user.weekComplete <= user.weekGoal) {
        int figureCharge = 5; // needs to be replaced with the figure provider.
        double chargeConcistencyBonus =
            (figureCharge * 0.01) * user.weekComplete.toInt();
        charge = figureCharge + chargeConcistencyBonus.toInt();
      }
      showDialog(
          context: context,
          builder: (context) {
            return FfAlertDialog(
              child: Center(
                  child: Column(children: [
                Column(
                  children: [
                    Column(
                      children: [
                        ProgressBar(
                          icon: Icon(
                            Icons.battery_charging_full,
                            color: Theme.of(context).colorScheme.primary,
                            size: 40,
                          ),
                          progressPercent: 1,
                          fillColor: Theme.of(context).colorScheme.primary,
                          barWidth: 240,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Charge: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                            Text(charge.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)), // Replace '10' with the actual charge value
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        ProgressBar(
                          icon: Icon(
                            Icons.currency_franc_sharp,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 40,
                          ),
                          progressPercent: 1,
                          fillColor: Theme.of(context).colorScheme.secondary,
                          barWidth: 240,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Currency: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                            Text(addableCurrency.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)), // Replace '50' with the actual currency value
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        ProgressBar(
                          icon: Icon(
                            Icons.ev_station,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 40,
                          ),
                          progressPercent: 1,
                          fillColor: Theme.of(context).colorScheme.tertiary,
                          barWidth: 240,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('EV: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)),
                            Text(ev.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)), // Replace '75' with the actual EV value
                          ],
                        ),
                      ],
                    ),
                    FfButton(
                        text: "Awesome!",
                        textColor: Theme.of(context).colorScheme.onError,
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        onPressed: () {
                          Navigator.pop(context);
                          endLogging();
                        }),
                  ],
                ),
              ])),
            );
          });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double usableHeight = MediaQuery.of(context).size.height -
        60 -
        123.5; // height of app bar and bottom nav bar
    if (!_logging) {
      return Center(
        child: Container(
          height: usableHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FfButton(
                text: "+ Start Workout",
                height: 100,
                textColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  startLogging();
                  startTimer();
                },
              )
            ],
          ),
        ),
      );
    } else {
      return Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(children: [
                  Consumer<FigureModel>(
                    builder: (context, figureModel, _) {
                      return BackedFigureHolder(
                          height: 350,
                          width: 250,
                          figureUrl: figureModel.composeFigureUrl());
                    },
                  ),
                ]),
                Center(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          ProgressBar(
                            icon: Icon(
                              Icons.battery_charging_full,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 40,
                            ),
                            progressPercent:
                                time.toDouble() / (_timegoal.toDouble()),
                            fillColor: Theme.of(context).colorScheme.secondary,
                            barWidth: 300,
                            gradientColor:
                                Theme.of(context).colorScheme.surfaceDim,
                          ),
                          ProgressBar(
                            icon: Icon(
                              Icons.upgrade,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 40,
                            ),
                            progressPercent:
                                time.toDouble() / (_timegoal.toDouble()),
                            fillColor: Theme.of(context).colorScheme.tertiary,
                            barWidth: 300,
                            gradientColor:
                                Theme.of(context).colorScheme.tertiaryFixedDim,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                      Positioned(
                        left: 65,
                        top: 0,
                        child: FloatingText(
                          text:
                              "^ ${(scoreIncrement * 10).toStringAsPrecision(sigfigs)}",
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          formatSeconds(time.toInt()),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FfButton(
                            text: "End Workout",
                            textColor:
                                Theme.of(context).colorScheme.primaryFixedDim,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            onPressed: showConfirmationBox),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ))
              ],
            ),
          ),
          Consumer<UserModel>(builder: (context, user, _) {
            return user.user?.email == "chb263@msstate.edu" ||
                    user.user?.email == "blizard265@gmail.com"
                ? DraggableAdminPanel(
                    onButton1Pressed: add30Seconds,
                    onButton2Pressed: add10Minutes,
                    button1Text: "Add 30 Seconds",
                    button2Text: "Add 10 Minutes")
                : Container();
          })
        ],
      );
    }
  }
}
