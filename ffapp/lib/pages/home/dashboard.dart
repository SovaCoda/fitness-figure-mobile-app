import 'dart:ffi';

import 'package:ffapp/components/admin_panel.dart';
import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/charge_bar.dart';
import 'package:ffapp/components/dashboard/workout_numbers.dart';
import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/components/message_sender.dart';
import 'package:ffapp/components/resuables/streak_shower.dart';
import 'package:ffapp/components/resuables/week_to_go_shower.dart';
import 'package:ffapp/components/robot_dialog_box.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/components/robot_response.dart';
import 'package:ffapp/components/skin_view.dart';
import 'package:ffapp/components/user_message.dart';
import 'package:ffapp/components/utils/history_model.dart';
import 'package:ffapp/components/week_complete_showcase.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/chat.dart';
import 'package:ffapp/pages/home/store.dart' as store;
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:ffapp/services/robotDialog.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/services/routes.pbgrpc.dart';
import 'package:fixnum/src/int64.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/components/double_line_divider.dart';
import 'package:ffapp/components/progress_bar.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/assets/data/figure_ev_data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AuthService auth;
  FlutterUser user = FlutterUser();
  late String email = "Loading...";
  late int weeklyGoal = 0;
  late int weeklyCompleted = 0;
  late String figureURL = "robot1";
  late double charge = 0;
  final int robotCharge = 100;
  late Map<String, int> evData = {};
  late Figure figure = Figure();
  RobotDialog robotDialog = RobotDialog();
  bool chatEnabled = false;
  bool showInteractions = false;
  String loginMessage = "Hey i would like to speak with you";
  late AppBarAndBottomNavigationBarModel appBarAndBottomNavigationBar;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);

    initialize();
    appBarAndBottomNavigationBar =
        Provider.of<AppBarAndBottomNavigationBarModel>(context, listen: false);
  }

  void initialize() async {
    Routes.User? databaseUser = await auth.getUserDBInfo();
    databaseUser!.lastLogin = DateTime.now().toUtc().toString();
    await auth.updateUserDBInfo(databaseUser);
    Routes.FigureInstance? databaseFigure = await auth.getFigureInstance(
        Routes.FigureInstance(
            userEmail: databaseUser?.email,
            figureName: databaseUser?.curFigure));

    String curEmail = databaseUser?.email ?? "Loading...";
    int curGoal = databaseUser?.weekGoal.toInt() ?? 0;
    int curWeekly = databaseUser?.weekComplete.toInt() ?? 0;
    String curFigure = databaseUser?.curFigure ?? "robot1_skin0_cropped";
    if (!mounted) return;
    Provider.of<UserModel>(context, listen: false).setUser(databaseUser);
    Provider.of<FigureModel>(context, listen: false).setFigure(databaseFigure);
    Provider.of<FigureModel>(context, listen: false)
        .setFigureLevel(databaseFigure!.evLevel ?? 0);
    setState(() {
      charge = curWeekly / curGoal;
      email = curEmail;
      weeklyGoal = curGoal;
      weeklyCompleted = curWeekly;

      if (curFigure != "none" &&
          Provider.of<FigureModel>(context, listen: false).figure?.charge !=
              null) {
        //logic for display sad character... theres nothing stopping this from
        //display a broken url rn though
        if (Provider.of<FigureModel>(context, listen: false).figure!.charge <
            20) {
          figureURL = "${curFigure}_sad";
        } else if (Provider.of<FigureModel>(context, listen: false)
                .figure!
                .charge <
            50) {
          figureURL = curFigure;
        } else {
          figureURL = "${curFigure}_happy";
        }
      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (databaseUser!.readyForWeekReset == 'yes') {
        bool isUsersFirstWeek = databaseUser.isInGracePeriod == 'yes';
        showFFDialogWithChildren(
            "Week Complete!",
            [
              WeekCompleteShowcase(
                isUserFirstWeek: isUsersFirstWeek,
              )
            ],
            false,
            FfButton(
                text: "Get Fit",
                textColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () async {
                  int numComplete =
                      Provider.of<HistoryModel>(context, listen: false)
                          .lastWeek
                          .where((element) => element == 2)
                          .length;
                  int chargeGain = numComplete * 3;
                  int evGain = numComplete * 50;
                  bool isComplete = isUsersFirstWeek
                      ? true
                      : Provider.of<HistoryModel>(context, listen: false)
                              .lastWeek
                              .where((element) => element == 2)
                              .length >=
                          Provider.of<UserModel>(context, listen: false)
                              .user!
                              .weekGoal
                              .toInt();
                  User user =
                      Provider.of<UserModel>(context, listen: false).user!;
                  FigureInstance figure =
                      Provider.of<FigureModel>(context, listen: false).figure!;
                  if (isComplete) {
                    await auth.resetUserWeekComplete(user);
                    user.weekComplete = Int64(0);
                    user.readyForWeekReset = 'no';
                    user.isInGracePeriod = 'no';

                    figure.evPoints += evGain;
                    figure.charge += chargeGain;

                    await auth.updateUserDBInfo(user);
                    await auth.updateFigureInstance(figure);
                    Provider.of<UserModel>(context, listen: false)
                        .setUser(user);
                    Provider.of<FigureModel>(context, listen: false)
                        .setFigure(figure);

                    Navigator.of(context).pop();
                    return;
                  }
                  user.streak = Int64(0);
                  user.weekComplete = Int64(0);
                  user.readyForWeekReset = 'no';
                  await auth.resetUserStreak(user);
                  await auth.resetUserWeekComplete(user);
                  await auth.updateUserDBInfo(user);
                  await auth.updateFigureInstance(figure);
                  Provider.of<UserModel>(context, listen: false).setUser(user);
                  Provider.of<FigureModel>(context, listen: false)
                      .setFigure(figure);

                  Navigator.of(context).pop();
                }),
            context);
      }
    });
    logger.i(figureURL);
  }

  void triggerFigureDecay() {
    auth.figureDecay(Provider.of<FigureModel>(context, listen: false).figure!);
  }

  void triggerUserReset() {
    auth.userReset(Provider.of<UserModel>(context, listen: false).user!);
  }

  double? usableScreenHeight;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appBarHeight =
          appBarAndBottomNavigationBar.appBarKey.currentContext?.size?.height;
      final bottomNavBarHeight = appBarAndBottomNavigationBar
          .bottomNavBarKey.currentContext?.size?.height;
      final screenheight = MediaQuery.sizeOf(context).height;
      setState(() {
        Provider.of<AppBarAndBottomNavigationBarModel>(context, listen: false)
            .setUsableScreenHeight(
                screenheight - (appBarHeight ?? 0) - (bottomNavBarHeight ?? 0));
        usableScreenHeight =
            screenheight - (appBarHeight ?? 0) - (bottomNavBarHeight ?? 0);
      });
    });

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          height: usableScreenHeight ?? 800,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            gradient: RadialGradient(
              center: Alignment.center,
              focalRadius: 0.1,
              colors: [
                Theme.of(context).colorScheme.onPrimary.withOpacity(0),
                Theme.of(context).colorScheme.surface.withOpacity(0.45),
              ],
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.surface,
              width: 3,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer<FigureModel>(
                builder: (context, figure, child) {
                  return ChargeBar(
                    currentCharge: figure.figure?.charge ?? 0,
                    fillColor: Theme.of(context).colorScheme.primary,
                    barHeight: 30,
                    barWidth: MediaQuery.of(context).size.width * 0.78,
                    isVertical: false,
                    showDashedLines: true,
                    showInfoCircle: true,
                  );
                },
              ),
              Expanded(
                child: Stack(
                  children: [
                    Consumer<FigureModel>(
                      builder: (context, figure, child) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RobotImageHolder(
                                url: (figure.figure != null)
                                    ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${figure.figure!.evLevel}_cropped_happy")
                                    : "robot1/robot1_skin0_evo0_cropped_happy",
                                height:
                                    MediaQuery.of(context).size.height * 0.333,
                                width: 500,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          showFFDialog(
                              "Work In Progress",
                              "Sorry, we're still installing the conversational chips into the figures, check back later to see some progress!",
                              true,
                              context);
                        },
                        child: Icon(
                          Icons.chat,
                          size: 60,
                        ),
                      ),
                    ),
                    Consumer<UserModel>(
                      builder: (context, user, child) => (user.user != null &&
                                  user.user?.email == "chb263@msstate.ed" ||
                              user.user?.email == "blizard265@gmail.com")
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
              ),
              Consumer<FigureModel>(
                builder: (context, figure, child) {
                  if (figure.figure == null) {
                    return const CircularProgressIndicator();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: EvBar(
                      currentXp: figure.figure?.evPoints ?? 0,
                      maxXp: figure1.EvCutoffs[figure.EVLevel],
                      fillColor: Theme.of(context).colorScheme.secondary,
                      barHeight: 30,
                      barWidth: MediaQuery.of(context).size.width * 0.9,
                      isVertical: false,
                      showInfoBox: true,
                    ),
                  );
                },
              ),
              Consumer<UserModel>(builder: (context, user, child) {
                if (user.user == null) {
                  return const CircularProgressIndicator();
                }
                return WorkoutNumbersRow(
                  streak: user.user!.streak.toInt(),
                  weeklyCompleted: user.user!.weekComplete.toInt(),
                  weeklyGoal: user.user!.weekGoal.toInt(),
                  lifeTimeCompleted: 10,
                  availableWidth: MediaQuery.of(context).size.width - 40,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
