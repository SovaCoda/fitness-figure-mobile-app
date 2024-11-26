

import 'package:ffapp/components/admin_panel.dart';
import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/charge_bar.dart';
import 'package:ffapp/components/dashboard/workout_numbers.dart';
import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/components/utils/chat_model.dart';
import 'package:ffapp/components/utils/history_model.dart';
import 'package:ffapp/components/week_complete_showcase.dart';
import 'package:ffapp/components/week_view.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:ffapp/services/robotDialog.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/services/routes.pbgrpc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:fixnum/src/int64.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:async';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

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
    try {
      Routes.User? databaseUser = await auth.getUserDBInfo();
      
      
      if (databaseUser != null) {
        CustomerInfo customerInfo = await Purchases.getCustomerInfo();
        if (customerInfo.entitlements.active['ff_plus'] != null) {
          databaseUser.premium = Int64.ONE;
        } else {
          databaseUser.premium = Int64(-1);
        }
        databaseUser.lastLogin = DateTime.now().toUtc().toString();
        await auth.updateUserDBInfo(databaseUser);
        Routes.FigureInstance? databaseFigure = await auth.getFigureInstance(
            Routes.FigureInstance(
                userEmail: databaseUser.email,
                figureName: databaseUser.curFigure));
        if (!mounted) return;
        String curEmail = databaseUser?.email ?? "Loading...";
        int curGoal = databaseUser?.weekGoal.toInt() ?? 0;
        int curWeekly = databaseUser?.weekComplete.toInt() ?? 0;
        String curFigure = databaseUser?.curFigure ?? "robot1_skin0_cropped";
        if (!mounted) return;
        Provider.of<UserModel>(context, listen: false).setUser(databaseUser);
        Provider.of<FigureModel>(context, listen: false)
            .setFigure(databaseFigure);
        Provider.of<FigureModel>(context, listen: false)
            .setFigureLevel(databaseFigure!.evLevel ?? 0);
        setState(() {
          SystemChannels.textInput.invokeMethod('TextInput.hide');

            FocusManager.instance.primaryFocus?.unfocus();
        FocusScope.of(context).unfocus();
          charge = curWeekly / curGoal;
          email = curEmail;
          weeklyGoal = curGoal;
          weeklyCompleted = curWeekly;

          if (curFigure != "none" &&
              Provider.of<FigureModel>(context, listen: false).figure?.charge !=
                  null) {
            //logic for display sad character... theres nothing stopping this from
            //display a broken url rn though
            if (Provider.of<FigureModel>(context, listen: false)
                    .figure!
                    .charge <
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

        // offline notification stuff
        LocalNotificationService().initNotifications;
        Map<String, dynamic> gameState = {
          "charge": databaseFigure.charge,
          "evo": databaseFigure.evPoints,
          "currency": databaseUser.currency,
          "evoNeededForLevel": figure1.EvCutoffs[databaseFigure.evLevel],
          "workoutsCompleteThisWeek": weeklyCompleted,
          "workoutsNeededThisWeek": weeklyGoal,
        };

        if (databaseUser.hasPremium() &&
            await LocalNotificationService().isReadyForNotification()) {
          await Future.delayed(const Duration(milliseconds: 500));
          String? premiumOfflineNotification =
              await Provider.of<ChatModel>(context, listen: false)
                  .generatePremiumOfflineStatusMessage(gameState);
          if (premiumOfflineNotification == null) {
            logger
                .e('recieved null response from openai for push notification');
          } else {
            LocalNotificationService().scheduleOfflineNotification(
                title: "Your Figure", body: premiumOfflineNotification);
          }
        } else if (await LocalNotificationService().isReadyForNotification()) {
          if (databaseFigure.charge > 50) {
            LocalNotificationService().scheduleOfflineNotification(
                title: "Your Figure",
                body:
                    "My charge is at ${databaseFigure.charge}, great job! Lets keep it that way by staying consistent");
          } else {
            LocalNotificationService().scheduleOfflineNotification(
                title: "Your Figure",
                body:
                    "My charge is at ${databaseFigure.charge}, you need to workout more if you want me to stay online");
          }
        }
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

                                            double investment =
                          Provider.of<HistoryModel>(context, listen: false)
                              .lastWeekInvestment;
                      int investmentAdd = (investment / 100).toInt();
                      int numComplete =
                          Provider.of<HistoryModel>(context, listen: false)
                              .lastWeek
                              .where((element) => element == 2)
                              .length;

                      int chargeGain = isComplete ? numComplete * 3 : numComplete;
                      int evGain = isComplete ? numComplete * 50 + investmentAdd : numComplete * 25;

                      User user =
                          Provider.of<UserModel>(context, listen: false).user!;
                      FigureInstance figure =
                          Provider.of<FigureModel>(context, listen: false)
                              .figure!;
                      figure.charge += chargeGain;
                      if(figure.charge > 100){ figure.charge = 100;}
                      figure.evPoints += evGain;
                      if (isComplete) {
                        Navigator.of(context).pop();
                        await auth.resetUserWeekComplete(user);
                        user.readyForWeekReset = 'no';
                        user.weekComplete = Int64.ZERO;
                        
                        await auth.resetUserWeekComplete(user);
                        await auth.updateUserDBInfo(user);
                        await auth.updateFigureInstance(figure);
                        Provider.of<UserModel>(context, listen: false)
                            .setUser(user);
                        Provider.of<FigureModel>(context, listen: false)
                            .setFigure(figure);
                        
                        return;
                      }
                      Navigator.of(context).pop();
                      user.readyForWeekReset = 'no';
                      user.weekComplete = Int64.ZERO;
                      user.streak = Int64.ZERO;
                      await auth.updateUserDBInfo(user);
                        await auth.updateFigureInstance(figure);
                        Provider.of<UserModel>(context, listen: false)
                            .setUser(user);
                        Provider.of<FigureModel>(context, listen: false)
                            .setFigure(figure);
                      await auth.resetUserWeekComplete(user);
                      await auth.resetUserStreak(user);
                    }),
                context);
          }
        });
        logger.i(figureURL);
        
      }
    } catch (e, stacktrace) {
      logger.e("Error initializing dashboard: ${e.toString()}");
      logger.e("Stacktrace: ${stacktrace.toString()}");
    }
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
    // Use MediaQuery to get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // Calculate responsive sizes
    final double chargeBarHeight = 20;
    final double chargeBarWidth = screenWidth * 0.6;
    final double robotImageHeight = screenHeight * 0.333;
    final double evBarHeight = 20;
    final double evBarWidth = screenWidth * 0.6;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //WeekView(),
                Consumer<FigureModel>(
                  builder: (context, figure, child) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ChargeBar(
                        showIcon: true,
                        currentCharge: figure.figure?.charge ?? 0,
                        fillColor: Theme.of(context).colorScheme.primary,
                        barHeight: chargeBarHeight,
                        barWidth: chargeBarWidth,
                        isVertical: false,
                        showDashedLines: true,
                        showInfoCircle: true,
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Consumer<FigureModel>(
                        builder: (context, figure, child) {
                          return Center(
                              child: FittedBox(
                            fit: BoxFit.contain,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RobotImageHolder(
                                  url: (figure.figure != null)
                                      ? "${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${figure.figure!.evLevel}_cropped_${figure.figure!.charge < 50 ? "sad" : "happy"}"
                                      : "robot1/robot1_skin0_evo0_cropped_happy",
                                  height: robotImageHeight,
                                  width: robotImageHeight,
                                ),
                              ],
                            ),
                          ));
                        },
                      ),
                      
                      Consumer<UserModel>(
                        builder: (context, user, child) => (user.user !=
                                        null &&
                                    user.user?.email == "chb263@msstate.ed" ||
                                user.user?.email == "blizard265@gmail.com")
                            ? DraggableAdminPanel(
                                onButton1Pressed: triggerFigureDecay,
                                onButton2Pressed: triggerUserReset,
                                button1Text: "Daily Decay Figure",
                                button2Text: "Weekly Reset User",
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
                Consumer<FigureModel>(
                  builder: (context, figure, child) {
                    if (figure.figure == null) {
                      return const CircularProgressIndicator();
                    }
                    return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: EvBar(
                        showIcon: true,
                        currentXp: figure.figure?.evPoints ?? 0,
                        maxXp: figure1.EvCutoffs[figure.EVLevel],
                        fillColor: Theme.of(context).colorScheme.secondary,
                        barHeight: evBarHeight,
                        barWidth: evBarWidth,
                        isVertical: false,
                        showInfoBox: true,
                        isMaxLevel: figure.EVLevel == 7,
                      ),
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.only(left: 40, top: 12, bottom: 12, right: 40),
                  width: screenWidth,
                  height: screenHeight * 0.2,
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color.fromRGBO(51, 133, 162, 1))),
                    gradient: LinearGradient(colors: [Color.fromRGBO(28, 109, 189, 0.29), Color.fromRGBO(0, 164, 123, 0.29)])
                  ),
                  child: Consumer<UserModel>(
                    builder: (context, user, child) {
                      if (user.user == null) {
                        return const CircularProgressIndicator();
                      }
                      return WorkoutNumbersRow(
                        streak: user.user!.streak.toInt(),
                        weeklyCompleted: user.user!.weekComplete.toInt(),
                        weeklyGoal: user.user!.weekGoal.toInt(),
                        lifeTimeCompleted: 10,
                        availableWidth: screenWidth * 0.91,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
