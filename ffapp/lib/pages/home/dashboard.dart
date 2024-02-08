import 'dart:ffi';

import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/components/double_line_divider.dart';
import 'package:ffapp/components/progress_bar.dart';
import 'package:ffapp/services/flutterUser.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FlutterUser user = FlutterUser();
  late String email = "Loading...";
  late int weeklyGoal = 0;
  late int weeklyCompleted = 0;
  late String figureURL = "robot1_skin0_cropped";

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await user.initAuthService();
    await user.checkUser();
    String curEmail = await user.getEmail();
    int curGoal = await user.getWorkoutGoal();
    int curWeekly = await user.getWeeklyCompleted();
    String curFigure = await user.getCurrentFigure();
    setState(() {
      email = curEmail;
      weeklyGoal = curGoal;
      weeklyCompleted = curWeekly;
      if (curFigure != "none") {
        figureURL = curFigure;
      }
    });
    logger.i(figureURL);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //created below
            RobotImageHolder(url: figureURL),

            //Text underneath the robot
            Text(
              "Train consistently to power your Fitness Figure!",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 15),

            //created below
            WorkoutNumbersRow(
              weeklyCompleted: weeklyCompleted,
              weeklyGoal: weeklyGoal,
              lifeTimeCompleted: 10,
            ),

            const SizedBox(
              height: 20,
            ),

            //imported from progress bar component
            //TO DO: DECIDE HOW TO CALCULATE THIS
            ProgressBar(),

            const SizedBox(
              height: 20,
            ),

            //progress explanation text
            const Text(
              "*Your figures battery is calculated by looking at your current week progress as well as past weeks",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50)
          ],
        )),
      ),
    );
  }
}

class RobotImageHolder extends StatelessWidget {
  final String url;

  const RobotImageHolder({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.0,
      height: 400.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: Alignment(0, 0),
          colors: [
            Colors.white.withOpacity(1),
            Colors.white.withOpacity(0),
          ],
          radius: .48,
        ),
      ),
      child: Center(
        child: Image.asset(
          "lib/assets/icons/$url.gif",
          height: 260.0,
          width: 260.0,
        ),
      ),
    );
  }
}

class WorkoutNumbersRow extends StatelessWidget {
  final int weeklyGoal;
  final int weeklyCompleted;
  final int lifeTimeCompleted;

  const WorkoutNumbersRow(
      {super.key,
      required this.weeklyCompleted,
      required this.weeklyGoal,
      required this.lifeTimeCompleted});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(children: [
            Text(
              weeklyGoal.toString(),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
              ),
            ),
            Text(
              "Weekly Goal",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ]),
          DoubleLineDivider(),
          Column(children: [
            Text(
              weeklyCompleted.toString(),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
              ),
            ),
            Text(
              "Weekly Completed",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ]),
          DoubleLineDivider(),
          Column(children: [
            Text(
              lifeTimeCompleted.toString(),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
              ),
            ),
            Text(
              "Total Completed",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
