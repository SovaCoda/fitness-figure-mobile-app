import 'dart:async';
import 'dart:math';

import 'package:ffapp/components/animated_points.dart';
import 'package:ffapp/components/progress_bar.dart';
import 'package:ffapp/components/robot_dialog_box.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:ffapp/services/robotDialog.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:provider/provider.dart';

class WorkoutAdder extends StatefulWidget {
  const WorkoutAdder({super.key});

  @override
  State<WorkoutAdder> createState() => _WorkoutAdderState();
}

class _WorkoutAdderState extends State<WorkoutAdder> {
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
  late User user;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    initialize();
  }

  void initialize() async {
    await auth.getUserDBInfo().then((value) {user = value!;});
    Int64 timegoal = user.workoutMinTime;
    scoreIncrement = 1 / (timegoal.toDouble() * 60);
    logger.i(timegoal);
    setState(() {
      if (timegoal != Int64.ZERO) {
        _timegoal = timegoal * 60; //convert to seconds
      }
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
  Future<void> awardAll() async {
    FigureInstance figureInstance = Provider.of<FigureModel>(context, listen: false).figure!;
    Figure figure = await auth.getFigure(Figure(figureName: figureInstance.figureName));
    int currency = int.parse(Provider.of<CurrencyModel>(context, listen: false).currency);
    int addable_currency = _timePassed.toInt() ~/ 10;
    currency += addable_currency;

    int figureEV = figure.baseEvGain; 
    double eVConcistencyBonus = (figureEV * 0.1) * user.weekComplete.toInt();
    int ev = figureEV + eVConcistencyBonus.toInt();

    int figureCharge = 10; // needs to be replaced with the figure provider.
    double chargeConcistencyBonus = (figureCharge * 0.1) * user.weekComplete.toInt();
    int charge = figureCharge + chargeConcistencyBonus.toInt();

    Provider.of<CurrencyModel>(context, listen: false).setCurrency(currency.toString());
    Provider.of<FigureModel>(context, listen: false).setFigureEv(figureInstance.evPoints + ev);
    Provider.of<FigureModel>(context, listen: false).setFigureCharge(figureInstance.charge + charge);

    await auth.updateUserDBInfo(Routes.User(
      email: user.email,
      currency: Int64(currency),
      weekComplete: Int64(user.weekComplete.toInt() + 1)
    ));
    
    await auth.updateFigureInstance(FigureInstance(
      figureId: figureInstance.figureId,
      charge: (figureInstance.charge + charge).toInt(),
      evPoints: (figureInstance.evPoints + ev).toInt()
    ));
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
    await awardAll();
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

  void displaySwapWidget() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Change Figure"),
            content: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      auth.updateUserDBInfo(
                          Routes.User(curFigure: "robot1_skin0_cropped"));
                      setState(() {
                        figureURL = "robot1_skin0_cropped";
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      showConfirmationBox();
                    },
                    child: const Text("Robot 1")),
                ElevatedButton(
                    onPressed: () {
                      auth.updateUserDBInfo(
                          Routes.User(curFigure: "robot1_skin1_cropped"));
                      setState(() {
                        figureURL = "robot1_skin1_cropped";
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      showConfirmationBox();
                    },
                    child: const Text("Robot 2")),
                ElevatedButton(
                    onPressed: () {
                      auth.updateUserDBInfo(
                          Routes.User(curFigure: "robot2_skin0_cropped"));
                      setState(() {
                        figureURL = "robot2_skin0_cropped";
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      showConfirmationBox();
                    },
                    child: const Text("Robot 3")),
                ElevatedButton(
                    onPressed: () {
                      auth.updateUserDBInfo(
                          Routes.User(curFigure: "robot2_skin1_cropped"));
                      setState(() {
                        figureURL = "robot2_skin1_cropped";
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      showConfirmationBox();
                    },
                    child: const Text("Robot 4")),
              ],
            ),
          );
        });
  }

  void showConfirmationBox() {
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
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Are you sure?"),
              content: Center(
                  child: Column(children: [
                Text("You've met your goal!"),
                SizedBox(height: 8),
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
                                    .headlineSmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                            Text('10',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)), // Replace '10' with the actual charge value
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
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
                                    .headlineSmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                            Text('50',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)), // Replace '50' with the actual currency value
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
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
                                    .headlineSmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)),
                            Text('75',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)), // Replace '75' with the actual EV value
                          ],
                        ),
                      ],
                    ),
                    RobotImageHolder(url: figureURL, height: 200, width: 200),
                    ElevatedButton(
                      onPressed: displaySwapWidget,
                      child: const Text("Change Figure"),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(children: [
              Consumer<FigureModel>(
                builder: (context, figureModel, _) {
                  return RobotImageHolder(
                    url: figureModel.figure!.figureName,
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
            const SizedBox(height: 20),
            Text(
              "Time Elapsed:",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 5),
            Text(
              formatSeconds(time.toInt()),
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: showConfirmationBox,
                child: const Text("End Workout")),
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  Row(
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
                  Positioned(
                    left: 65,
                    top: 0,
                    child: FloatingText(
                      text: "^ ${(scoreIncrement * 10).toStringAsPrecision(sigfigs)}",
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
                  Row(
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
                  Positioned(
                    left: 65,
                    top: 0,
                    child: FloatingText(
                      text: "^ " +
                          (scoreIncrement * 20).toStringAsPrecision(sigfigs),
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
                  Row(
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
                  Positioned(
                    left: 65,
                    top: 0,
                    child: FloatingText(
                      text: "^ " +
                          (scoreIncrement * 40).toStringAsPrecision(sigfigs),
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
