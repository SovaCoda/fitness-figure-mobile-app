import 'package:ffapp/components/ff_app_bar.dart';
import 'package:ffapp/components/ff_body_scaffold.dart';
import 'package:ffapp/components/ff_bottom_nav_bar.dart';
import 'package:ffapp/components/utils/chat_model.dart';
import 'package:ffapp/icons/fitness_icon.dart';
import 'package:ffapp/pages/home/core.dart';
import 'package:ffapp/pages/home/dashboard.dart';
import 'package:ffapp/pages/home/evo.dart';
import 'package:ffapp/pages/home/inventory.dart';
import 'package:ffapp/pages/home/profile.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/pages/home/workout_adder.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:ffapp/services/providers.dart';
import 'package:ffapp/pages/home/chat.dart';
import 'package:ffapp/services/auth.dart'; // for the logger
import 'package:flutter/material.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  //keys to access height of the appbar and bottom navbar throughout the app
  //acts as a directory of the widgets that the navbar can route to and render
  static final List<Widget> _pages = <Widget>[
    const Dashboard(),
    const Inventory(),
    const WorkoutAdder(),
    // const History(), implement this via the calendar in the dashboard
    const Profile(),
    const Core(),
    const EvolutionPage(),
    // const SkinViewer(),
    const Store(),
    const ChatPage()
  ];

  bool loading = true;
  double loadOpacity = 1.0;

  @override
  void initState() {
    LocalNotificationService().initNotifications();

    initialize();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // TODO: MOVE GENERAL LOGIC INTO THE HOME PAGE FROM DASHBOARD (Initializing providers etc.)
  Future<void> initialize() async {
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        loadOpacity = 0.0;
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            loading = false;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onError,

          // Custom app bar with the logo and store button
          // AppBar is constant 40 pixels tall across all screens
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.sizeOf(context).width, 40),
            child: const FfAppBar(),
          ), // Has to be a preferred size widget cause of scaffold parameter

          //renders the page that the nav bar has currently selected
          //indexed stack allows pages to retain their state when switching between them
          body: Consumer<HomeIndexProvider>(
            builder: (_, HomeIndexProvider homeIndex, __) {
              return FfBodyScaffold(
                  selectedIndex: homeIndex.selectedIndex, pages: _pages);
            },
          ),

          // Permanent footer navigation that changes the page index state to switch displays
          // Size is a constant 80 pixels tall across all screens
          bottomNavigationBar: Consumer<HomeIndexProvider>(
            builder: (_, HomeIndexProvider homeIndex, __) {
              return FfBottomNavBar(
                selectedIndex: homeIndex.selectedIndex,
              );
            },
          )),
      AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: loadOpacity,
        child: Visibility(
          visible: loading,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'lib/assets/art/ff_background.png',
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FitnessIcon(
                      type: FitnessIconType.logo_white,
                      size: 200,
                    ),
                    Text(
                      "Loading",
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(color: Colors.white),
                    ),
                    CircularProgressIndicator()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
