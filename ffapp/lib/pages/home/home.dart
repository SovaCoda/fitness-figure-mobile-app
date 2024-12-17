import 'dart:async';

import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/components/ff_app_bar.dart';
import 'package:ffapp/components/ff_body_scaffold.dart';
import 'package:ffapp/components/ff_bottom_nav_bar.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/core.dart';
import 'package:ffapp/pages/home/dashboard.dart';
import 'package:ffapp/pages/home/inventory.dart';
import 'package:ffapp/pages/home/profile.dart';
import 'package:ffapp/pages/home/workout_adder.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/connectivity_manager.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DashboardPage extends StatefulWidget {
  final int index;
  const DashboardPage({super.key, this.index = 0});
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
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
        _selectedIndex = widget.index;
      });
    } catch (e) {
      print("Error initializing currency: $e");
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
        body: FfBodyScaffold(selectedIndex: _selectedIndex, pages: _pages),

        //permanent footer navigation that changes the page index state to switch displays
        bottomNavigationBar: FfBottomNavBar(
          selectedIndex: _selectedIndex!,
          onItemTapped: _onItemTapped,
        ));
  }
}
