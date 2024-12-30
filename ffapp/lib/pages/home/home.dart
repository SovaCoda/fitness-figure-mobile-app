import 'package:ffapp/components/ff_app_bar.dart';
import 'package:ffapp/components/ff_body_scaffold.dart';
import 'package:ffapp/components/ff_bottom_nav_bar.dart';
import 'package:ffapp/components/skin_view.dart';
import 'package:ffapp/pages/home/core.dart';
import 'package:ffapp/pages/home/dashboard.dart';
import 'package:ffapp/pages/home/evo.dart';
import 'package:ffapp/pages/home/inventory.dart';
import 'package:ffapp/pages/home/profile.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/pages/home/workout_adder.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:ffapp/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:provider/provider.dart';

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
    const SkinViewer(),
    const Store()
  ];

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

  FlutterUser user = FlutterUser();
  late String currency = "0000";

  void initialize() async {
    try {
      await user.initAuthService();
      await user.checkUser();
      String usrCurrency = await user.getCurrency();
      setState(() {
        currency = usrCurrency;
      });
    } catch (e) {
      logger.e("Error initializing currency: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Connectivity service to check for internet connection and stop user from continuing offline

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onError,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.sizeOf(context).width, 40),
          child: const FfAppBar(),
        ), // Has to be a preferred size widget cause of scaffold parameter

        //renders the page that the nav bar has currently selected
        //indexed stack allows pages to retain their state when switching between them
        body: Consumer<HomeIndexProvider>(
          builder: (_, homeIndex, __) {
            return FfBodyScaffold(
                selectedIndex: homeIndex.selectedIndex, pages: _pages);
          },
        ),

        //permanent footer navigation that changes the page index state to switch displays
        bottomNavigationBar: Consumer<HomeIndexProvider>(
          builder: (_, homeIndex, __) {
            return FfBottomNavBar(
              selectedIndex: homeIndex.selectedIndex,
            );
          },
        ));
  }
}
