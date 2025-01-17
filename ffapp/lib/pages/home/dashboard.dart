// ignore_for_file: unreachable_from_main

import 'dart:io';

import 'package:ffapp/components/admin_panel.dart';
import 'package:ffapp/components/animated_figure.dart';
import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/charge_bar.dart';
import 'package:ffapp/components/dashboard/workout_numbers.dart';
import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/components/utils/chat_model.dart';
import 'package:ffapp/components/utils/history_model.dart';
import 'package:ffapp/components/week_complete_showcase.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/services/routes.pbgrpc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:async';
import 'store.dart';

class IsolateInitData {
  IsolateInitData(this.token, this.email);
  final RootIsolateToken token;
  final String email;
}

/// The isolate function that gets database information for the user.
/// Note: An isolate has completely separate memory from the main thread, so
///       it must be a top level function, and the auth provider cannot be passed into it
///
/// Isolates cannot perform updateUserDBInfo as the proto requires the use of
/// setMessageHandler(), which only the root isolate can do
///
/// [@pragma('vm:entry-point')] lets the precompiler know to compile this code ahead of time
/// instead of discarding it as unused during compilation
@pragma('vm:entry-point')
Future<List<dynamic>> isolateFetchDatabaseInfo(IsolateInitData initData) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(initData.token);

  try {
    final AuthService auth = await AuthService.instance;

    // Create a timeout for the database call
    final userInfoFuture = auth
        .initializeUserInfo(initData.email)
        .timeout(const Duration(seconds: 10), onTimeout: () {
      throw TimeoutException('Database call timed out');
    });

    // Run futures in parallel
    final results = await Future.wait([
      userInfoFuture,
    ], eagerError: true);

    return results;
  } catch (e) {
    logger.e('Error in isolate: $e');
    return [null, null];
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AuthService auth;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);

    initialize();
  }

  Future<void> initialize() async {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    if (userModel.user?.email == null) {
      logger.e('No logged in user!');
      return;
    }

    final stopwatch = Stopwatch()..start();

    final initData =
        IsolateInitData(RootIsolateToken.instance!, userModel.user!.email);

    final isolateResult = await compute(
      isolateFetchDatabaseInfo,
      initData,
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('Isolate timed out');
      },
    );

    stopwatch.stop();

    final Routes.UserInfo? userInfo = isolateResult[0] as Routes.UserInfo?;
    final Routes.User? databaseUser = userInfo?.user;
    final Routes.MultiFigureInstance? figureInstances = userInfo?.figures;
    final Routes.MultiWorkout? workouts = userInfo?.workouts;

    // final Routes.MultiFigureInstance figureInstances =
    //     isolateResult[1] as Routes.MultiFigureInstance;

    logger.i('Database calls finished in ${stopwatch.elapsedMilliseconds}ms');

    // If databaseUser is null, exit early.
    // TODO: Implement an error screen & retry connecting to server error handling
    if (databaseUser == null) {
      logger.e('Failed to fetch user data.');
      return;
    }

    // Get customer info from isolate
    final CustomerInfo? customerInfo = await !Platform.isIOS
        ? await Future.value(null)
        : await Purchases.getCustomerInfo().catchError((e) {
            logger.e('RevenueCat error: $e');
            return null;
          });

    // Update user data based on customer info.
    if (Platform.isIOS) {
      if (customerInfo != null) {
        databaseUser.premium =
            (customerInfo.entitlements.active['ff_plus'] != null)
                ? Int64.ONE
                : Int64(-1);
      } else {
        // Handle the case where customerInfo is null (due to RevenueCat error)
        // databaseUser.premium = Int64(-1); TODO: determine what to do with this code
      }
    }

    // hide the keyboard if open
    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusManager.instance.primaryFocus?.unfocus();
      FocusScope.of(context).unfocus();
    });

    if (!mounted) {
      return;
    }
    // Set all providers for use around the app
    Provider.of<UserModel>(context, listen: false).setUser(databaseUser);
    Provider.of<FigureInstancesProvider>(context, listen: false)
        .setListOfFigureInstances(figureInstances!.figureInstances);
    Provider.of<FigureModel>(context, listen: false).setFigure(
        figureInstances.figureInstances[
            Provider.of<SelectedFigureProvider>(context, listen: false)
                .selectedFigureIndex]);
    Provider.of<HistoryModel>(context, listen: false)
        .setWorkouts(workouts!.workouts);
    final FigureInstance databaseFigure =
        Provider.of<FigureModel>(context, listen: false).figure!;

    // Get the current game state to use in offline notifications
    final Map<String, dynamic> gameState = {
      'charge': databaseFigure.charge,
      'evo': databaseFigure.evPoints,
      'currency': databaseUser.currency,
      'evoNeededForLevel': figure1.evCutoffs[databaseFigure.evLevel],
      'workoutsCompleteThisWeek': databaseUser.weekComplete,
      'workoutsNeededThisWeek': databaseUser.weekGoal,
    };

    // Schedule notifications based on user's premium status
    if (databaseUser.hasPremium() &&
        await LocalNotificationService().isReadyForNotification()) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!mounted) {
        return;
      }
      final String? premiumOfflineNotification =
          await Provider.of<ChatModel>(context, listen: false)
              .generatePremiumOfflineStatusMessage(gameState);

      if (premiumOfflineNotification != null) {
        LocalNotificationService().scheduleOfflineNotification(
            title: 'Your Figure', body: premiumOfflineNotification);
      } else {
        logger.e('Received null response from OpenAI for push notification');
      }
    } else if (await LocalNotificationService().isReadyForNotification()) {
      final String body = databaseFigure.charge > 50
          ? "My charge is at ${databaseFigure.charge}, great job! Let's keep it that way."
          : 'My charge is at ${databaseFigure.charge}, you need to workout more if you want me to stay online';
      LocalNotificationService()
          .scheduleOfflineNotification(title: 'Your Figure', body: body);
    }

    // Show week information popup after the user completed their week
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (databaseUser.readyForWeekReset == 'yes') {
        final bool isUsersFirstWeek = databaseUser.isInGracePeriod == 'yes';
        showFFDialogWithChildren(
          'Week Complete!',
          [
            WeekCompleteShowcase(isUserFirstWeek: isUsersFirstWeek),
          ],
          false,
          FfButton(
            text: 'Get Fit',
            textColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              final bool isComplete = isUsersFirstWeek ||
                  Provider.of<HistoryModel>(context, listen: false)
                          .lastWeek
                          .where((element) => element == 2)
                          .length >=
                      Provider.of<UserModel>(context, listen: false)
                          .user!
                          .weekGoal
                          .toInt();

              final double investment =
                  Provider.of<HistoryModel>(context, listen: false)
                      .lastWeekInvestment;
              final int investmentAdd = (investment / 100).toInt();
              final int numComplete =
                  Provider.of<HistoryModel>(context, listen: false)
                      .lastWeek
                      .where((element) => element == 2)
                      .length;

              final int chargeGain = isComplete ? numComplete * 3 : numComplete;
              final int evGain = isComplete
                  ? numComplete * 50 + investmentAdd
                  : numComplete * 25;

              final User user =
                  Provider.of<UserModel>(context, listen: false).user!;
              final FigureInstance figure =
                  Provider.of<FigureModel>(context, listen: false).figure!;
              figure.charge += chargeGain;
              figure.charge = figure.charge > 100 ? 100 : figure.charge;
              figure.evPoints += evGain;

              Navigator.of(context).pop();
              user.readyForWeekReset = 'no';
              user.weekComplete = Int64.ZERO;

              // update in database
              await auth.updateUserDBInfo(user);
              await auth.updateFigureInstance(figure);
              await auth.resetUserWeekComplete(user);
              await auth.resetUserStreak(user);

              // update providers
              if (mounted) {
                Provider.of<UserModel>(context, listen: false).setUser(user);
                Provider.of<FigureModel>(context, listen: false)
                    .setFigure(figure);
              }
            },
          ),
          context,
        );
      }
    });
  }

  void setAnimationHappy() {
    Provider.of<FigureModel>(context, listen: false)
        .controller
        .animationState
        .setAnimationByName(0, 'happy', true);
  }

  void setAnimationSad() {
    Provider.of<FigureModel>(context, listen: false)
        .controller
        .animationState
        .setAnimationByName(0, 'sad', true);
  }

  double? usableScreenHeight;
  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen size
    final Size screenSize = MediaQuery.sizeOf(context);
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<FigureModel>(
                              builder: (context, figure, child) => Center(

                                  // delay the execution of the animated figure to prevent freezing (any faster causes set state after dispose)
                                  child: FutureBuilder(
                                      future: Future<void>.delayed(
                                          const Duration(
                                              seconds:
                                                  2)), // Add a 2-second delay
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // While waiting for the delay, you can show a placeholder
                                          return const CircularProgressIndicator(); // Replace with your desired placeholder
                                        } else {
                                          // Once the delay is over, build the AnimatedFigure
                                          return AnimatedFigure(
                                            height: robotImageHeight,
                                            width: robotImageHeight,
                                            useEquippedFigure: false,
                                            figureName:
                                                figure.figure!.figureName,
                                            figureLevel: figure.figure!.evLevel,
                                          );
                                        }
                                      })))
                        ],
                      ),
                      Consumer<UserModel>(
                        builder: (context, user, child) => (user.user != null &&
                                    user.user?.email == 'chb263@msstate.ed' ||
                                user.user?.email == 'blizard265@gmail.com')
                            ? DraggableAdminPanel(
                                onButton1Pressed: setAnimationSad,
                                onButton2Pressed: setAnimationHappy,
                                button1Text: 'Sad Animation',
                                button2Text: 'Happy Animation',
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

/// Old database fetching algorithm (unused)
// Future<List<dynamic>> fetchDatabaseInfo() {
  //   final Future<Routes.User?> databaseUserFuture = auth.getUserDBInfo();

  //   final List<Future<dynamic>> databaseCalls = [
  //     databaseUserFuture,
  //     // gets customer information
  //     // _getCustomerInfoSafely(),
  //     // fetches all figure instances that the user has and stores it in a provider
  //     databaseUserFuture.then((databaseUser) {
  //       return auth
  //           .getFigureInstances(databaseUser!)
  //           .then((Routes.MultiFigureInstance value) => {
  //                 Provider.of<FigureInstancesProvider>(context, listen: false)
  //                     .setListOfFigureInstances(value.figureInstances),
  //                 Provider.of<FigureModel>(context, listen: false).setFigure(
  //                     value.figureInstances[Provider.of<SelectedFigureProvider>(
  //                             context,
  //                             listen: false)
  //                         .selectedFigureIndex])
  //               });
  //     }),
  //     // updates the user's last login time in the database to now
  //     databaseUserFuture.then((databaseUser) async => {
  //           databaseUser!.lastLogin = DateTime.now().toUtc().toString(),
  //           auth.updateUserDBInfo(databaseUser)
  //         }),
  //     databaseUserFuture.then((databaseUser) => {
  //           Provider.of<UserModel>(context, listen: false)
  //               .setUser(databaseUser!)
  //         }),
  //     // Retrieves workouts from database and stores it in HistoryModel provider
  //     Provider.of<HistoryModel>(context, listen: false).retrieveWorkouts()
  //   ];

  //   return Future.wait(databaseCalls);
  // }
  
