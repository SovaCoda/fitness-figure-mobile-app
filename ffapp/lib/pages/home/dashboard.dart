import 'package:ffapp/components/admin_panel.dart';
import 'package:ffapp/components/animated_figure.dart';
import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/charge_bar.dart';
import 'package:ffapp/components/dashboard/workout_numbers.dart';
import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/components/utils/chat_model.dart';
import 'package:ffapp/components/utils/history_model.dart';
import 'package:ffapp/components/week_complete_showcase.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:ffapp/services/robot_dialog.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/services/routes.pbgrpc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:async';

import 'package:spine_flutter/spine_widget.dart';

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
      // Start fetching multiple async data concurrently.
      Future<Routes.User?> databaseUserFuture = auth.getUserDBInfo();
      Future<CustomerInfo?> customerInfoFuture = _getCustomerInfoSafely();
      Provider.of<HistoryModel>(context, listen: false).retrieveWorkouts();
      Future<Routes.FigureInstance?> databaseFigureFuture =
          databaseUserFuture.then((databaseUser) {
        if (databaseUser != null) {
          return auth.getFigureInstance(Routes.FigureInstance(
              userEmail: databaseUser.email,
              figureName: databaseUser.curFigure));
        }
        return null;
      });

      // Wait for the results concurrently
      Routes.User? databaseUser = await databaseUserFuture;
      CustomerInfo? customerInfo = await customerInfoFuture;
      Routes.FigureInstance? databaseFigure = await databaseFigureFuture;

      // If databaseUser is null, exit early.
      if (databaseUser == null) {
        logger.e("Failed to fetch user data.");
        return;
      }

      // Update user data based on customer info.
      if (customerInfo != null) {
        databaseUser.premium =
            (customerInfo.entitlements.active['ff_plus'] != null)
                ? Int64.ONE
                : Int64(-1);
      } else {
        // Handle the case where customerInfo is null (due to RevenueCat error)
        // databaseUser.premium = Int64(-1); TODO: determine what to do with this code
      }

      databaseUser.lastLogin = DateTime.now().toUtc().toString();
      await auth.updateUserDBInfo(databaseUser);

      // Proceed with other operations only if `mounted` is true.
      if (!mounted) return;

      // If `databaseFigure` is not null, set the figure and update capabilities
      if (databaseFigure != null) {
        // Set the figure in the model, this will notify listeners and trigger the UI update
        Provider.of<FigureModel>(context, listen: false)
            .setFigure(databaseFigure);
      } else {
        // In case no database figure is available, still proceed with the default one
        logger.e("No figure data available from database, using default.");
      }

      final String curEmail = databaseUser.email;
      final int curGoal = databaseUser.weekGoal.toInt();
      final int curWeekly = databaseUser.weekComplete.toInt();
      final String curFigure = databaseUser.curFigure;
      Provider.of<UserModel>(context, listen: false).setUser(databaseUser);
      // Update UI state
      setState(() {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        FocusManager.instance.primaryFocus?.unfocus();
        FocusScope.of(context).unfocus();

        charge = curWeekly / curGoal;
        email = curEmail;
        weeklyGoal = curGoal;
        weeklyCompleted = curWeekly;
      });

      // Initialize offline notification service asynchronously.
      LocalNotificationService().initNotifications;

      Map<String, dynamic> gameState = {
        "charge": databaseFigure?.charge ?? 0,
        "evo": databaseFigure?.evPoints ?? 0,
        "currency": databaseUser.currency,
        "evoNeededForLevel": figure1.evCutoffs[databaseFigure?.evLevel ?? 0],
        "workoutsCompleteThisWeek": weeklyCompleted,
        "workoutsNeededThisWeek": weeklyGoal,
      };

      // Schedule notifications based on user's premium status
      if (databaseUser.hasPremium() &&
          await LocalNotificationService().isReadyForNotification()) {
        await Future.delayed(const Duration(milliseconds: 500));
        String? premiumOfflineNotification =
            await Provider.of<ChatModel>(context, listen: false)
                .generatePremiumOfflineStatusMessage(gameState);

        if (premiumOfflineNotification != null) {
          LocalNotificationService().scheduleOfflineNotification(
              title: "Your Figure", body: premiumOfflineNotification);
        } else {
          logger.e('Received null response from OpenAI for push notification');
        }
      } else if (await LocalNotificationService().isReadyForNotification()) {
        String body = databaseFigure!.charge > 50
            ? "My charge is at ${databaseFigure.charge}, great job! Let's keep it that way."
            : "My charge is at ${databaseFigure.charge}, you need to workout more if you want me to stay online";
        LocalNotificationService()
            .scheduleOfflineNotification(title: "Your Figure", body: body);
      }

      // Schedule dialog after frame callback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (databaseUser.readyForWeekReset == 'yes') {
          bool isUsersFirstWeek = databaseUser.isInGracePeriod == 'yes';
          showFFDialogWithChildren(
            "Week Complete!",
            [
              WeekCompleteShowcase(isUserFirstWeek: isUsersFirstWeek),
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
                int evGain = isComplete
                    ? numComplete * 50 + investmentAdd
                    : numComplete * 25;

                User user =
                    Provider.of<UserModel>(context, listen: false).user!;
                FigureInstance figure =
                    Provider.of<FigureModel>(context, listen: false).figure!;
                figure.charge += chargeGain;
                figure.charge = figure.charge > 100 ? 100 : figure.charge;
                figure.evPoints += evGain;

                Navigator.of(context).pop();
                user.readyForWeekReset = 'no';
                user.weekComplete = Int64.ZERO;

                await auth.updateUserDBInfo(user);
                await auth.updateFigureInstance(figure);
                await auth.resetUserWeekComplete(user);
                await auth.resetUserStreak(user);

                Provider.of<UserModel>(context, listen: false).setUser(user);
                Provider.of<FigureModel>(context, listen: false)
                    .setFigure(figure);
              },
            ),
            context,
          );
        }
      });

      logger.i(figureURL);
    } catch (e, stacktrace) {
      logger.e("Error initializing dashboard: ${e.toString()}");
      logger.e("Stacktrace: ${stacktrace.toString()}");
    }
  }

  Future<CustomerInfo?> _getCustomerInfoSafely() async {
    try {
      return await Purchases.getCustomerInfo();
    } on PlatformException catch (e) {
      // Handle the RevenueCat error
      logger.e("RevenueCat error: ${e.message}");
      return null; // Return null to continue gracefully
    } catch (e) {
      logger.e("Unexpected error: $e");
      rethrow; // Rethrow any other exceptions
    }
  }

  void setAnimationHappy() {
    Provider.of<FigureModel>(context, listen: false)
        .controller
        .animationState
        .setAnimationByName(0, "happy", true);
  }

  void setAnimationSad() {
    Provider.of<FigureModel>(context, listen: false)
        .controller
        .animationState
        .setAnimationByName(0, "sad", true);
  }

  double? usableScreenHeight;
  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // Calculate responsive sizes
    const double chargeBarHeight = 20;
    final double chargeBarWidth = screenWidth * 0.6;
    final double robotImageHeight = screenHeight * 0.33;
    const double evBarHeight = 20;
    final double evBarWidth = screenWidth * 0.6;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        showDashedLines: true,
                        showInfoCircle: true,
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: AnimatedFigure(
                              height: robotImageHeight,
                              width: robotImageHeight,
                            ),
                          )
                        ],
                      ),
                      Consumer<UserModel>(
                        builder: (context, user, child) => (user.user != null &&
                                    user.user?.email == "chb263@msstate.ed" ||
                                user.user?.email == "blizard265@gmail.com")
                            ? DraggableAdminPanel(
                                onButton1Pressed: setAnimationSad,
                                onButton2Pressed: setAnimationHappy,
                                button1Text: "Sad Animation",
                                button2Text: "Happy Animation",
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
                      padding: const EdgeInsets.all(16.0),
                      child: EvBar(
                        showIcon: true,
                        currentXp: figure.figure?.evPoints ?? 0,
                        maxXp: figure1.evCutoffs[figure.EVLevel],
                        fillColor: Theme.of(context).colorScheme.secondary,
                        barHeight: evBarHeight,
                        barWidth: evBarWidth,
                        showInfoBox: true,
                        isMaxLevel: figure.EVLevel == 2,
                      ),
                    );
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 40, top: 12, bottom: 12, right: 40),
                  width: screenWidth,
                  height: screenHeight * 0.2,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromRGBO(51, 133, 162, 1),
                      ),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(28, 109, 189, 0.29),
                        Color.fromRGBO(0, 164, 123, 0.29),
                      ],
                    ),
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
