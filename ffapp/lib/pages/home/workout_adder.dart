import 'dart:async';
import 'dart:math';

import 'package:ffapp/components/admin_panel.dart';
import 'package:ffapp/components/animated_points.dart';
import 'package:ffapp/components/popup.dart';
import 'package:ffapp/components/progress_bar.dart';
import 'package:ffapp/components/robot_dialog_box.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
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
    double chargeConcistencyBonus = (figureCharge * 0.1) * user.weekComplete.toInt();
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
        .setFigureCharge(!weeklyGoalMet ? ((figureInstance.charge + charge) > 100) ? 100 : figureInstance.charge + charge : figureInstance.charge);
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
      showDialog(
        context: context,
        builder: (context) => const PopupWidget(
          message:
              'Congratulations on completing your workout, would you like to take a quick 3 minute survey on how you\'re liking Fitness Figure so far?',
        ),
      );
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
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          endLogging();
        },
        child: const Text("I'm Sure"));
  }

  Widget noIllKeepAtIt() {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text("No I'll Keep At It!"));
  }

  add5Minutes() {
    setState(() {
      time += Int64(300);
    });
  }

  add10Minutes() {
    setState(() {
      time += Int64(600);
    });
  }


  void showConfirmationBox() async {
    if (time < _timegoal.toInt()) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Are you sure?"),
              content: Text(
                  "You haven't worked out at least as long as ${formatSeconds(_timegoal.toInt())}, if you stop now this workout will be logged, but you will only gain currency and EV points. Are you sure you want to stop?"),
              actions: [
                imSureButton(),
                noIllKeepAtIt(),
              ],
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
            return AlertDialog(
              title: Text("Goal Reached!", style: Theme.of(context).textTheme.displaySmall),
              content: Center(
                  child: Column(children: [
                Column(
                  children: [
                    Column(
                      children: [
                        ProgressBar(
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
                    Consumer<FigureModel>(
                      builder: (context, figureModel, _) {
                        return RobotImageHolder(
                          url:
                              ("${figureModel.figure!.figureName}/${figureModel.figure!.figureName}_skin${figureModel.figure!.curSkin}_evo${figureModel.EVLevel}_cropped_happy"),
                          height: 200,
                          width: 200,
                        );
                      },
                    ),
                  ],
                ),
              ])),
              actions: [
                imSureButton(),
                noIllKeepAtIt(),
              ],
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
    if (!_logging) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  startLogging();
                  startTimer();
                },
                child: const Text("Log a Workout"))
          ],
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
                      return RobotImageHolder(
                        url:
                            ("${figureModel.figure!.figureName}/${figureModel.figure!.figureName}_skin${figureModel.figure!.curSkin}_evo${figureModel.EVLevel}_cropped_happy"),
                        height: 250,
                        width: 250,
                      );
                    },
                  ),
                  Positioned(
                      child: RobotDialogBox(
                          dialogOptions: robotDialog.getLoggerDialog(
                              _timePassed.toInt(), 1800),
                          width: 180,
                          height: 45)),
                ]),

                const SizedBox(height: 5),
                Text(
                  formatSeconds(time.toInt()),
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: showConfirmationBox,
                    child: const Text("End Workout")),
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ProgressBar(
                              progressPercent:
                                  time.toDouble() / (_timegoal.toDouble()),
                              fillColor: Theme.of(context).colorScheme.primary,
                              barWidth: 240,
                            ),
                            const SizedBox(width: 20),
                            Icon(
                              Icons.battery_charging_full,
                              color: Theme.of(context).colorScheme.primary,
                              size: 34,
                            ),
                          ],
                        ),
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
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ProgressBar(
                              progressPercent:
                                  time.toDouble() / (_timegoal.toDouble()) * 2,
                              fillColor: Theme.of(context).colorScheme.secondary,
                              barWidth: 240,
                            ),
                            const SizedBox(width: 20),
                            Icon(
                              Icons.currency_exchange,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 34,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 65,
                        top: 0,
                        child: FloatingText(
                          text: "^ ${(scoreIncrement * 20)
                                  .toStringAsPrecision(sigfigs)}",
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ProgressBar(
                              progressPercent:
                                  time.toDouble() / (_timegoal.toDouble()) * 4,
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              barWidth: 240,
                            ),
                            const SizedBox(width: 20),
                            Icon(
                              Icons.upgrade,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 34,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 65,
                        top: 0,
                        child: FloatingText(
                          text: "^ ${(scoreIncrement * 40)
                                  .toStringAsPrecision(sigfigs)}",
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Consumer<UserModel>(builder: (context, user, _) {
            return user.user?.email == "chb263@msstate.edu" || user.user?.email == "blizard265@gmail.com"
                ? DraggableAdminPanel(
                    onButton1Pressed: add5Minutes,
                    onButton2Pressed: add10Minutes,
                    button1Text: "Add 5 Minutes",
                    button2Text: "Add 10 Minutes")
                : Container();
          })
        ],
      );
    }
  }
}
