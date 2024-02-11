import 'dart:async';
import 'dart:math';

import 'package:ffapp/components/robot_dialog_box.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:ffapp/services/routes.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

class WorkoutAdder extends StatefulWidget {
  const WorkoutAdder({super.key});

  @override
  State<WorkoutAdder> createState() => _WorkoutAdderState();
}

class _WorkoutAdderState extends State<WorkoutAdder> {
  FlutterUser user = FlutterUser();
  final logger = Logger();
  bool _logging = false;
  Timer _timer = Timer(Duration.zero, () {});
  Int64 time = Int64(0);
  Int64 _timePassed = Int64(0);
  late String _startTime, _endTime;
  late AuthService auth;
  late String figureURL = "robot1_skin0_cropped";

  @override
  void initState() {
    super.initState();
    initAuthService();
  }

  //get the users current figure
  void initialize() async {
    await user.initAuthService();
    await user.checkUser();
    String curFigure = await user.getCurrentFigure();
    setState(() {
      if (curFigure != "none") {
        figureURL = curFigure;
      }
    });
  }

  Future<void> initAuthService() async {
    auth = await AuthService.instance;
    logger.i("AuthService initialized");
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
  //TO DO: SET A TIME PASSED AND UPDATE IT ON THE UI

  void startLogging() {
    setState(() {
      _logging = true;
      _startTime = DateTime.now().toString();
    });
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
    auth.createWorkout(workout);
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

  void showConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Are you sure?"),
            content: const Text(
                "You haven't worked out at least as long as X, if you stop now you won't be able to log this workout. Are you sure you want to stop?"),
            actions: [
              imSureButton(),
              noIllKeepAtIt(),
            ],
          );
        });
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
            Stack(
              children: [
                RobotImageHolder(url: figureURL, height: 250, width: 250),
                Positioned(
                  child: RobotDialogBox(
                    dialogOptions: ["You got it. Keep working out!"], 
                    width: 120,
                    height: 45
                  )
                ),
                ]
            ),
            const SizedBox(height: 40),
            Text( "Time Elapsed:",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),
            ),
            const SizedBox(height: 10),
            Text(formatSeconds(time.toInt()),
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: showConfirmationBox,
                child: const Text("End Workout"))
          ],
        ),
      );
    }
  }
}
