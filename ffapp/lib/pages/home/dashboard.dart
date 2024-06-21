import 'package:ffapp/components/admin_panel.dart';
import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/robot_dialog_box.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/components/skin_view.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/store.dart' as store;
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/google/protobuf/empty.pb.dart';
import 'package:ffapp/services/robotDialog.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/services/routes.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ffapp/components/double_line_divider.dart';
import 'package:ffapp/components/progress_bar.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:go_router/go_router.dart';
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
  final int robotCharge = 20;
  late Map<String, int> evData = {};
  late Figure figure = Figure();
  RobotDialog robotDialog = RobotDialog();

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);

    initialize();
  }

  void onViewSkins() async {
    Routes.MultiSkinInstance multiskininstances = await auth.getSkinInstances(
        Routes.User(
            email: Provider.of<UserModel>(context, listen: false).user!.email));
    Routes.MultiFigureInstance multifigureinstances =
        await auth.getFigureInstances(Routes.User(
            email: Provider.of<UserModel>(context, listen: false).user!.email));
    Routes.MultiSkin multiskins = await auth.getSkins();

    List<Routes.SkinInstance> skinInstances = multiskininstances.skinInstances;
    List<Routes.FigureInstance> figureInstances =
        multifigureinstances.figureInstances;
    List<Routes.Skin> skins = multiskins.skins;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Skin View"),
          content: Container(
            height: 1000, // Set the height to 80% of the screen height
            child: ChangeNotifierProvider(
                create: (context) => store.FigureInstancesProvider(),
                child: SkinViewer(
                    listOfSkins: skins,
                    listOfSkinInstances: skinInstances,
                    figureName: Provider.of<FigureModel>(context, listen: false)
                        .figure!
                        .figureName,
                    listOfFigureInstances: figureInstances)),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void initialize() async {
    Routes.User? databaseUser = await auth?.getUserDBInfo();
    Routes.FigureInstance? databaseFigure = await auth.getFigureInstance(
        Routes.FigureInstance(
            userEmail: databaseUser?.email,
            figureName: databaseUser?.curFigure));
    Routes.Figure? figure =
        await auth.getFigure(Figure(figureName: databaseUser?.curFigure));
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

    Provider.of<FigureModel>(context, listen: false).figureCutoffs = figureCutoffs;

    Map<String, int> curEVData =
        displayEVPointsAndMax(databaseFigure.evPoints ?? 0, figureCutoffs);
    String curEmail = databaseUser?.email ?? "Loading...";
    int curGoal = databaseUser?.weekGoal.toInt() ?? 0;
    int curWeekly = databaseUser?.weekComplete.toInt() ?? 0;
    String curFigure = databaseUser?.curFigure ?? "robot1_skin0_cropped";
    Provider.of<CurrencyModel>(context, listen: false)
        .setCurrency(databaseUser?.currency.toString() ?? "0000");
    Provider.of<UserModel>(context, listen: false).setUser(databaseUser!);
    Provider.of<FigureModel>(context, listen: false).setFigure(databaseFigure);
    Provider.of<FigureModel>(context, listen: false)
        .setFigureLevel(curEVData['level']! - 1);
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
    FigureModel figureModel = Provider.of<FigureModel>(context, listen: false);
    int displayPoints = eVPoints;
    int maxPoints = figureModel.figureCutoffs[figureModel.EVLevel];

    return {
      'displayPoints': displayPoints,
      'maxPoints': maxPoints,
      'readyToEvolve': displayPoints >= maxPoints ? 1 : 0,
      'level': figureModel.EVLevel + 1,
    };
  }

  void triggerFigureDecay() {
    auth?.figureDecay(Provider.of<FigureModel>(context, listen: false).figure!);
  }

  void triggerUserReset() {
    auth?.userReset(Provider.of<UserModel>(context, listen: false).user!);
  }
  Stream<FigureModel> _figureStream() async* {
  // Replace with your actual data source logic
    while (true) {
      await Future<void>.delayed(const Duration(seconds: 3)); 
      if(mounted){
        Routes.FigureInstance? databaseFigure = await auth.getFigureInstance(
          Routes.FigureInstance(
            userEmail: Provider.of<UserModel>(context, listen: false).user?.email,
            figureName: Provider.of<UserModel>(context, listen: false).user?.curFigure));
      
        if(mounted){
          Provider.of<FigureModel>(context, listen: false).setFigure(databaseFigure);
          yield Provider.of<FigureModel>(context, listen: false);
        }
      }
    }
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
                Center(
                  child: Consumer<FigureModel>(
                    builder: (context, figure, child) {
                      String suffix;

                      // Implemented logic for determining the robot's happiness or sadness

                      if (figure.figure?.charge != null) {
                        if (figure.figure!.charge.toInt() >= 0 &&
                            figure.figure!.charge.toInt() <= 20) {
                          suffix = "_sad";
                        } else if (figure.figure!.charge.toInt() >= 51 &&
                            figure.figure!.charge.toInt() <= 100) {
                          suffix = "_happy";
                        } else {
                          suffix = "";
                        }
                      } else {
                        suffix = "";
                      }
                      return RobotImageHolder(
                        url: (figure.figure != null)
                            ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${(evData["level"] != null) ? evData["level"]! - 1 : 0}_cropped${suffix}")
                            : "robot1/robot1_skin0_evo0_cropped_happy",
                        height: 400,
                        width: 600,
                      );
                    },
                  ),
                ),
                Positioned(
                    top: 40,
                    left: 160,
                    child: Consumer<FigureModel>(
                      builder: (context, figure, child){
                      return RobotDialogBox(
                        dialogOptions:
                            // Dialog options now pulls from the server value
                            figure.figure?.charge != null ? robotDialog.getDashboardDialog(figure.figure!.charge.toInt()) : robotDialog.getDashboardDialog(0),
                        width: 200,
                        height: 40,
                        );
                      }
                    )),
                Consumer<UserModel>(
                  builder: (context, user, child) => (user != null &&
                          user.user != null &&
                          user.user!.email == "chb263@msstate.edu")
                      ? DraggableAdminPanel(
                          onButton1Pressed: triggerFigureDecay,
                          onButton2Pressed: triggerUserReset,
                          button1Text: "Daily Decay Figure",
                          button2Text: "Weekly Reset User",
                        )
                      : Container(),
                )
              ],
            ),

            Center(
                child: ElevatedButton.icon(
                    onPressed: onViewSkins,
                    icon: Icon(Icons.swap_calls),
                    label: Text("Skins"))),
            const SizedBox(height: 5),

            Center(
             
              child:  evData['readyToEvolve'] == 1 ? 
              ElevatedButton(onPressed: () {context.goNamed('Evolution');}, child: Text('Ready to Evolve!', style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary)))
              : EvBar(
                  currentXp: evData['displayPoints'] ?? 0,
                  maxXp: evData['maxPoints'] ?? 0,
                  currentLvl: evData['level'] ?? 1,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  barWidth: 200),
            ),

            //Text underneath the robot
            Text("Train consistently to power your Fitness Figure!",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    )),
            const SizedBox(height: 15),

            Consumer<UserModel>(builder: (context, user, child) {
              if (user.user == null) {
                return CircularProgressIndicator();
              }
              return WorkoutNumbersRow(
                weeklyCompleted: user.user!.weekComplete.toInt(),
                weeklyGoal: user.user!.weekGoal.toInt(),
                lifeTimeCompleted: 10,
              );
            }),

            const SizedBox(
              height: 20,
            ),

            //imported from progress bar component

            StreamBuilder<FigureModel>(
              stream: _figureStream(),
              builder: (context, snapshot) {
                if(!mounted){
                  return Text('Widget is no longer active');
                }
                else if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show a loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return Text('No data available');
                }

                final figure = snapshot.data!;
                if(figure.figure?.charge == null){
                  return const CircularProgressIndicator();
                }
                return ProgressBar(
                  progressPercent: figure.figure!.charge.toDouble() / 100 ?? 0.0,
                  barWidth: 320,
                  fillColor: Theme.of(context).colorScheme.primary,
                );
              },
            ),


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
                      color: weeklyCompleted >= weeklyGoal
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
            Text("Weekly Completed",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: weeklyCompleted >= weeklyGoal
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ]),
          // DoubleLineDivider(),
          // Column(children: [
          //   Text(lifeTimeCompleted.toString(),
          //       style: Theme.of(context).textTheme.headlineSmall!.copyWith(
          //             color: Theme.of(context).colorScheme.onSurfaceVariant,
          //           )),
          //   Text("Total Completed",
          //       style: Theme.of(context).textTheme.labelMedium!.copyWith(
          //             color: Theme.of(context).colorScheme.onSurfaceVariant,
          //           )),
          // ]),
        ],
      ),
    );
  }
}
