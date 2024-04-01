import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/robot_dialog_box.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/robotDialog.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/services/routes.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  late String figureURL = "robot1";
  late double charge = 0;
  final int robotCharge = 95;
  late Map<String, int> evData = {};
  late Figure figure = Figure();
  RobotDialog robotDialog = RobotDialog();

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);

    initialize();
  }

  void initialize() async {
    Routes.User? databaseUser = await auth?.getUserDBInfo();
    Routes.FigureInstance? databaseFigure = await auth.getFigureInstance(Routes.FigureInstance(userEmail: databaseUser?.email, figureName: databaseUser?.curFigure));
    Routes.Figure? figure = await auth.getFigure(Figure(figureName: databaseUser?.curFigure));
    List<int> figureCutoffs = [];
    figureCutoffs.add(figure?.stage1EvCutoff ?? 0);
    figureCutoffs.add(figure?.stage2EvCutoff ?? 0);
    figureCutoffs.add(figure?.stage3EvCutoff ?? 0);
    figureCutoffs.add(figure?.stage4EvCutoff ?? 0);
    figureCutoffs.add(figure?.stage5EvCutoff ?? 0);
    figureCutoffs.add(figure?.stage6EvCutoff ?? 0);
    figureCutoffs.add(figure?.stage7EvCutoff ?? 0);
    figureCutoffs.add(figure?.stage8EvCutoff ?? 0);
    figureCutoffs.add(figure?.stage9EvCutoff ?? 0);
    figureCutoffs.add(figure?.stage10EvCutoff ?? 0);
    Map<String, int> curEVData = displayEVPointsAndMax(databaseFigure.evPoints ?? 0, figureCutoffs);
    String curEmail = databaseUser?.email ?? "Loading...";
    int curGoal = databaseUser?.weekGoal.toInt() ?? 0;
    int curWeekly = databaseUser?.weekComplete.toInt() ?? 0;
    String curFigure = databaseUser?.curFigure ?? "robot1_skin0_cropped";
    Provider.of<CurrencyModel>(context, listen: false).setCurrency(
        databaseUser?.currency.toString() ?? "0000");
    Provider.of<UserModel>(context, listen: false).setUser(databaseUser!);
    Provider.of<FigureModel>(context, listen: false).setFigure(databaseFigure);
    setState(() {
      evData = curEVData;
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

  Map<String, int> displayEVPointsAndMax(int eVPoints, List<int> eVCutoffs) {
    int displayPoints = eVPoints;
    int maxPoints = eVCutoffs[0];
    int level = 1;

    for (int i = 0; i < eVCutoffs.length; i++) {
      if (displayPoints > eVCutoffs[i]) {
        displayPoints -= eVCutoffs[i];
        maxPoints = eVCutoffs[i];
        level++;
      } else {
        break;
      }
    }

    return {
      'displayPoints': displayPoints,
      'maxPoints': maxPoints,
      'level': level
    };
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
                Consumer<FigureModel>(
                  builder: (context, figure, child) {
                    return RobotImageHolder(
                      url: (figure.figure != null) ? (figure.figure!.figureName + "_skin" + figure.figure!.curSkin + "_cropped") : "robot1_skin0_cropped",
                      height: 400,
                      width: 400,
                    );
                  },
                ),
                Positioned(
                  top: 40,
                  left: 160,
                  child: RobotDialogBox(
                    dialogOptions:
                        robotDialog.getDashboardDialog(robotCharge),
                    width: 200,
                    height: 40,
                  )
                ),
                Positioned(
                  bottom: 30,
                  left: 100,
                  child: EvBar(
                    currentXp: evData['displayPoints'] ?? 0,
                    maxXp: evData['maxPoints'] ?? 0,
                    currentLvl: evData['level'] ?? 1,
                    fillColor: Theme.of(context).colorScheme.tertiary,
                    barWidth: 200
                  ),
                )
              ],
            ),

            SizedBox(height: 5,),

            //Text underneath the robot
            Text("Train consistently to power your Fitness Figure!",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    )),
            const SizedBox(height: 15),

            Consumer<UserModel>(
              builder: (context, user, child) {
                if (user.user == null) {
                  return CircularProgressIndicator();
                }
                return Text(
                  "Welcome, " + user.user!.name ?? "Loading...",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                );
              },
            ),
            
            Consumer<UserModel>(builder: (context, user, child) {
              if (user.user == null) {
                return CircularProgressIndicator(); 
              }
              return WorkoutNumbersRow(
                  weeklyCompleted: user.user!.weekComplete.toInt(),
                  weeklyGoal: user.user!.weekGoal.toInt(),
                  lifeTimeCompleted: 10,
                );
              }
            ),


            const SizedBox(
              height: 20,
            ),

            //imported from progress bar component

            Consumer<FigureModel>(builder: (context, figure, child) {
              if (figure.figure == null) {
                return CircularProgressIndicator();
              }
              return ProgressBar(
                  progressPercent: figure.figure!.charge.toDouble()/100 ?? 0.0,
                  barWidth: 320,
                  fillColor: Theme.of(context).colorScheme.primary);
            }),

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
