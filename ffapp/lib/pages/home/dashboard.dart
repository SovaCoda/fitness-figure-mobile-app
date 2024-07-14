import 'package:ffapp/components/admin_panel.dart';
import 'package:ffapp/components/charge_bar_vertical.dart';
import 'package:ffapp/components/dashboard/workout_numbers.dart';
import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/ev_bar_vertical.dart';
import 'package:ffapp/components/message_sender.dart';
import 'package:ffapp/components/robot_dialog_box.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/components/robot_response.dart';
import 'package:ffapp/components/skin_view.dart';
import 'package:ffapp/components/user_message.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/chat.dart';
import 'package:ffapp/pages/home/store.dart' as store;
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:ffapp/services/robotDialog.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/services/routes.pbgrpc.dart';
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
  late Stream<FigureModel> figureStream;

  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  late AnimationController _phase2Controller;
  late Animation<double> _phase2Animation;

  late ScrollController _chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);

    _chatScrollController = ScrollController();

    _refreshController.addListener(refreshListener);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _phase2Controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(begin: 1, end: 0).animate(_controller);

    _phase2Animation =
        Tween<double>(begin: 0, end: 1).animate(_phase2Controller);

    initialize();
    appBarAndBottomNavigationBar =
        Provider.of<AppBarAndBottomNavigationBarModel>(context, listen: false);
  }

  @override
  void dispose() {
    _refreshController.removeListener(refreshListener);
    _refreshController.dispose();
    _controller.dispose();
    _phase2Controller.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _chatScrollController.animateTo(
      _chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  Future<void> _scrollToTop() async {
    _chatScrollController.animateTo(
      _chatScrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void refreshListener() {
    print(_refreshController.offset);
    if (_refreshController.offset < -80) {
      print('homing');
      initialize();
    }
    ;
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
          title: const Text("Skins"),
          content: SizedBox(
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
    Routes.User? databaseUser = await auth.getUserDBInfo();
    Routes.FigureInstance? databaseFigure = await auth.getFigureInstance(
        Routes.FigureInstance(
            userEmail: databaseUser?.email,
            figureName: databaseUser?.curFigure));
    Routes.Figure? figure =
        await auth.getFigure(Figure(figureName: databaseUser?.curFigure));

    String curEmail = databaseUser?.email ?? "Loading...";
    int curGoal = databaseUser?.weekGoal.toInt() ?? 0;
    int curWeekly = databaseUser?.weekComplete.toInt() ?? 0;
    String curFigure = databaseUser?.curFigure ?? "robot1_skin0_cropped";
    if (mounted) {
      Provider.of<CurrencyModel>(context, listen: false)
          .setCurrency(databaseUser?.currency.toString() ?? "0000");
      Provider.of<UserModel>(context, listen: false).setUser(databaseUser!);
      Provider.of<FigureModel>(context, listen: false)
          .setFigure(databaseFigure);
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
      logger.i(figureURL);
    }
  }

  void triggerFigureDecay() {
    auth.figureDecay(Provider.of<FigureModel>(context, listen: false).figure!);
  }

  void triggerUserReset() {
    auth.userReset(Provider.of<UserModel>(context, listen: false).user!);
  }

  Stream<FigureModel> _figureStream() async* {
    while (mounted) {
      try {
        final userModel = Provider.of<UserModel>(context, listen: false);
        final figureModel = Provider.of<FigureModel>(context, listen: false);
        final userEmail = userModel.user?.email;
        final curFigure = userModel.user?.curFigure;

        if (userEmail != null && curFigure != null) {
          Routes.FigureInstance? databaseFigure = await auth.getFigureInstance(
            Routes.FigureInstance(
              userEmail: userEmail,
              figureName: curFigure,
            ),
          );

          figureModel.setFigure(databaseFigure);
          yield figureModel;
        }
      } catch (e) {
        logger.e(e);
      }

      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }

  void toggleChatMode() async {
    if (chatEnabled) {
      await Future.delayed(const Duration(milliseconds: 500));

      await _scrollToTop();
      _controller.reverse();
      _phase2Controller.reverse();

      setState(() {
        chatEnabled = false;
      });

      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        showInteractions = false;
      });
    } else {
      _scrollToBottom();
      _controller.forward();
      setState(() {
        chatEnabled = true;
        showInteractions = true;
      });
      _phase2Controller.forward();
    }

    // setState(() {
    //   if (chatEnabled) {
    //     chatEnabled = false;
    //     showInteractions = false;
    //     _controller.reverse();
    //   } else {
    //     _controller.forward();
    //     chatEnabled = true;
    //     showInteractions = true;
    //     _phase2Controller.forward();
    //     showInteractions = true;
    //   }
    // });
  }

  ScrollController _refreshController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var usableScreenHeight;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final appBarHeight =
          appBarAndBottomNavigationBar.appBarKey.currentContext?.size?.height;
      final bottomNavBarHeight = appBarAndBottomNavigationBar
          .bottomNavBarKey.currentContext?.size?.height;
      usableScreenHeight = MediaQuery.sizeOf(context).height -
          (appBarHeight ?? 0) -
          (bottomNavBarHeight ?? 0);
    });
    Map<RobotResponse, UserMessage?> interactions =
        MessageProvider().getInteractions();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SafeArea(
          child: SizedBox(
            height: usableScreenHeight,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<UserModel>(builder: (context, user, child) {
                      if (user.user == null) {
                        return const CircularProgressIndicator();
                      }
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60, bottom: 20),
                          child: WorkoutNumbersRow(
                            weeklyCompleted: user.user!.weekComplete.toInt(),
                            weeklyGoal: user.user!.weekGoal.toInt(),
                            lifeTimeCompleted: 10,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Evolution bar
                      Visibility(
                        visible: !chatEnabled,
                        child: Opacity(
                          opacity: _sizeAnimation.value,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width / 8,
                              child: Consumer<FigureModel>(
                                builder: (context, figure, child) {
                                  if (figure.figure == null) {
                                    return const CircularProgressIndicator();
                                  }
                                  return Center(
                                    child: EvBarVertical(
                                        currentXp: figure.figure?.evPoints ?? 0,
                                        maxXp:
                                            figure1.EvCutoffs[figure.EVLevel],
                                        currentLvl: figure.EVLevel + 1 ?? 1,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        barHeight:
                                            ((usableScreenHeight) ?? 800) *
                                                0.5),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      // end evolution bar
                      // figure display
                      Expanded(
                        child: Stack(
                          children: [
                            Consumer<FigureModel>(
                              builder: (context, figure, child) {
                                String suffix;

                                // Implemented logic for determining the robot's happiness or sadness

                                if (figure.figure?.charge != null) {
                                  if (figure.figure!.charge.toInt() >= 0 &&
                                      figure.figure!.charge.toInt() <= 20) {
                                    suffix = "_sad";
                                  } else if (figure.figure!.charge.toInt() >=
                                          51 &&
                                      figure.figure!.charge.toInt() <= 100) {
                                    suffix = "_happy";
                                  } else {
                                    suffix = "";
                                  }
                                } else {
                                  suffix = "";
                                }
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: AnimatedContainer(
                                        padding: chatEnabled
                                            ? const EdgeInsets.only(top: 0)
                                            : const EdgeInsets.only(top: 100),
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Consumer<MessageProvider>(
                                                builder: (_, interactions, __) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                _scrollToBottom();
                                              });
                                              return Container(
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            500,
                                                    minHeight: 0),
                                                child: ListView.builder(
                                                    controller:
                                                        _chatScrollController,
                                                    shrinkWrap: false,
                                                    itemCount: interactions
                                                        .getInteractions()
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (index == 0) {
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            RobotImageHolder(
                                                              url: (figure.figure !=
                                                                      null)
                                                                  ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${figure.figure!.evLevel}_cropped$suffix")
                                                                  : "robot1/robot1_skin0_evo0_cropped_happy",
                                                              height:
                                                                  chatEnabled
                                                                      ? 75
                                                                      : 300,
                                                              width: chatEnabled
                                                                  ? 75
                                                                  : 300,
                                                            ),
                                                            Opacity(
                                                              opacity:
                                                                  _phase2Animation
                                                                      .value,
                                                              child: Visibility(
                                                                visible:
                                                                    showInteractions,
                                                                child: RobotResponse(
                                                                    isInitialChat:
                                                                        true,
                                                                    text:
                                                                        "Hey what do you want to talk about today?",
                                                                    figure_url: (figure.figure !=
                                                                            null)
                                                                        ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${figure.figure!.evLevel}_cropped$suffix")
                                                                        : "robot1/robot1_skin0_evo0_cropped_happy",
                                                                    datetime:
                                                                        "now"),
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      }
                                                      return interactions
                                                                  .getInteractions()
                                                                  .values
                                                                  .elementAt(
                                                                      index) ==
                                                              null
                                                          ? SizedBox(
                                                              width: MediaQuery
                                                                      .sizeOf(
                                                                          context)
                                                                  .width,
                                                              child: interactions
                                                                  .getInteractions()
                                                                  .keys
                                                                  .elementAt(
                                                                      index))
                                                          : Opacity(
                                                              opacity:
                                                                  _phase2Animation
                                                                      .value,
                                                              child: Visibility(
                                                                visible:
                                                                    showInteractions,
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                        width: MediaQuery.sizeOf(context)
                                                                            .width,
                                                                        child: interactions
                                                                            .getInteractions()
                                                                            .values
                                                                            .elementAt(index)),
                                                                    SizedBox(
                                                                        width: MediaQuery.sizeOf(context)
                                                                            .width,
                                                                        child: interactions
                                                                            .getInteractions()
                                                                            .keys
                                                                            .elementAt(index)!)
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                    }),
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                        visible: chatEnabled,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () => {
                                                _scrollToTop(),
                                                toggleChatMode()
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                    width: 2,
                                                  ),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainerHighest,
                                                ),
                                                width: 50,
                                                height: 50,
                                                child: const Icon(
                                                  Icons.home,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    50,
                                                child: const MessageSender()),
                                          ],
                                        )),
                                  ],
                                );
                              },
                            ),
                            Visibility(
                              visible: !chatEnabled,
                              child: Positioned(
                                top: 20,
                                right: 0,
                                child: GestureDetector(
                                  onTap: toggleChatMode,
                                  child: Opacity(
                                    opacity: _sizeAnimation.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          width: 2,
                                        ),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest,
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: const Icon(
                                        Icons.chat_bubble,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Visibility(
                            //   visible: !chatEnabled,
                            //   child: Positioned(
                            //     bottom: 40,
                            //     left: MediaQuery.sizeOf(context).width / 2 - 50,
                            //     child: Center(
                            //         child: ElevatedButton.icon(
                            //             onPressed: onViewSkins,
                            //             icon: const Icon(Icons.swap_calls),
                            //             label: const Text("Skins"))),
                            //   ),
                            // ),
                            Consumer<UserModel>(
                              builder: (context, user, child) =>
                                  (user.user != null &&
                                              user.user?.email ==
                                                  "chb263@msstate.ed" ||
                                          user.user?.email ==
                                              "blizard265@gmail.com")
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
                      Visibility(
                        visible: !chatEnabled,
                        child: Opacity(
                          opacity: _sizeAnimation.value,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width / 8,
                              child: Consumer<FigureModel>(
                                builder: (context, figure, child) {
                                  if (figure == null) {
                                    return const Text('No data available');
                                  }
                                  return ChargeBarVertical(
                                    currentCharge: figure.figure?.charge ?? 0,
                                    fillColor:
                                        Color.fromARGB(255, 77, 255, 115),
                                    barHeight:
                                        ((usableScreenHeight) ?? 800) * 0.5,
                                    barWidth: 15,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //imported from progress bar component
              ],
            ),
          ),
        );
      },
    );
  }
}
