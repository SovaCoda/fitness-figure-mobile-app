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
  final GlobalKey _appBarKey = GlobalKey();
  final GlobalKey _bottomNavBarKey = GlobalKey();
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

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    LocalNotificationService().initNotifications();
    initConnectivity();

    initialize();
    super.initState();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    await Future.delayed(const Duration(seconds: 3));
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      logger.e('Couldn\'t check connectivity status');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (mounted) {
      setState(() {
        _connectionStatus = result;
      });
      if (_connectionStatus[0] == ConnectivityResult.none) {
        logger.i(
            "Status was no connection, waiting 3 seconds and trying again...");
        await Future.delayed(const Duration(seconds: 3));
        List<ConnectivityResult> secondTry =
            await _connectivity.checkConnectivity();

        if (secondTry[0] == ConnectivityResult.none) {
          if (mounted) {
            logger.i("Status was twice no connection, sending reset request.");
            showFFDialogWithChildren(
                "Offline",
                [
                  const Text(
                      'It looks like youre offline, connect to the internet and reload!')
                ],
                false,
                FfButton(
                    text: "Okay!",
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () => {context.goNamed("SignIn")}),
                context);
          }
        }
      }
      // ignore: avoid_print
      print('Connectivity changed: $_connectionStatus');
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
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
    Provider.of<AppBarAndBottomNavigationBarModel>(context, listen: false)
        .setAppBarKey(_appBarKey);
    Provider.of<AppBarAndBottomNavigationBarModel>(context, listen: false)
        .setBottomNavBarKey(_bottomNavBarKey);
  }

  @override
  Widget build(BuildContext context) {
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
          bottomNavBarKey: _bottomNavBarKey,
          selectedIndex: _selectedIndex!,
          onItemTapped: _onItemTapped,
        ));
  }
}
