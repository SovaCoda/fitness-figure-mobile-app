import 'dart:ffi';

import 'package:ffapp/components/robot_dialog_box.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/robotDialog.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as FB;
import 'package:go_router/go_router.dart';
import 'package:ffapp/components/double_line_divider.dart';
import 'package:ffapp/components/progress_bar.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late AuthService auth;
  FlutterUser user = FlutterUser();
  late String email = "Loading...";
  late int weeklyGoal = 0;
  late int weeklyCompleted = 0;
  late String figureURL = "robot1_skin0_cropped";
  late double charge = 0;
  final int robotCharge = 95;
  RobotDialog robotDialog = RobotDialog();

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    initialize();
  }

  void initialize() async {
    Routes.User? databaseUser = await auth?.getUserDBInfo();
    String curEmail = databaseUser?.email ?? "Loading...";
    int curGoal = databaseUser?.weekGoal.toInt() ?? 0;
    int curWeekly = databaseUser?.weekComplete.toInt() ?? 0;
    String curFigure = databaseUser?.curFigure ?? "robot1_skin0_cropped";
    setState(() {
      charge = curWeekly / curGoal;
      email = curEmail;
      weeklyGoal = curGoal;
      weeklyCompleted = curWeekly;
      if (curFigure != "none") {
        //logic for display sad character... theres nothing stopping this from
        //display a broken url rn though
        if (robotCharge < 30) {
          figureURL = curFigure + "_sad";
        } else {
          figureURL = curFigure;
        }
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
            Stack(
              children: [
                RobotImageHolder(
                  url: figureURL,
                  height: 400,
                  width: 400,
                ),
                Positioned(
                    top: 40,
                    left: 160,
                    child: RobotDialogBox(
                      dialogOptions:
                          robotDialog.getDashboardDialog(robotCharge),
                      width: 200,
                      height: 40,
                    )),
              ],
            ),

            //Text underneath the robot
            Text("Train consistently to power your Fitness Figure!",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    )),

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
            ProgressBar(progressPercent: (charge)),

            const SizedBox(
              height: 20,
            ),

            //progress explanation text
            Text(
              "*Your figures battery is calculated by looking at your current week progress as well as past weeks",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
            Text(weeklyGoal.toString(),
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
            Text("Weekly Goal",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ]),
          DoubleLineDivider(),
          Column(children: [
            Text(weeklyCompleted.toString(),
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
            Text("Weekly Completed",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ]),
          DoubleLineDivider(),
          Column(children: [
            Text(lifeTimeCompleted.toString(),
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
            Text("Total Completed",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ]),
        ],
      ),
    );
  }
}
