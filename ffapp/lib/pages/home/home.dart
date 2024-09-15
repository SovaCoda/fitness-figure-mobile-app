import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/chat.dart';
import 'package:ffapp/pages/home/core.dart';
import 'package:ffapp/pages/home/dashboard.dart';
import 'package:ffapp/pages/home/fitventureslite.dart';
import 'package:ffapp/pages/home/history.dart';
import 'package:ffapp/pages/home/inventory.dart';
import 'package:ffapp/pages/home/profile.dart';
import 'package:ffapp/pages/home/workout_adder.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

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
    const History(),
    const Profile(),
    const Core(),
    const ChatPage(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    LocalNotificationService().initNotifications();
    initialize();
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

        //permanent top bar if we want it
        appBar: AppBar(
          toolbarHeight: 60,
          key: _appBarKey,
          title: Text(
            'FF',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(127),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () => context.goNamed('SkinStore'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer<CurrencyModel>(
                      builder: (context, currencyModel, child) {
                        return Text(currencyModel.currency,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ));
                      },
                    ),
                    const SizedBox(width: 10.0),
                    Icon(
                      Icons.currency_exchange,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () => context.goNamed('Subscribe'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 10.0),
                    Text(
                      'FF',
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                    ),
                    Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ),

            //question mark area that displays an alert on tap
            InkWell(
                onTap: () => {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return FfAlertDialog(
                              child: Text('no content'),
                            );
                          })
                    },
                child: Row(
                  children: [
                    const SizedBox(width: 10.0),
                    Icon(Icons.question_mark,
                        color: Theme.of(context).colorScheme.onSurface),
                    const SizedBox(width: 4.0),
                  ],
                )),
          ],
        ),

        //renders the page that the nav bar has currently selected
        //indexed stack allows pages to retain their state when switching between them
        body: Container(
          child: Stack(children: [
            IndexedStack(
              index: _selectedIndex,
              children: _pages,
            )
          ]),
        ),

        //permanent footer navigation that changes the page index state to switch displays
        bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Theme.of(context).colorScheme.surface,
            ),
            child: BottomNavigationBar(
                key: _bottomNavBarKey,
                iconSize: 30,
                showSelectedLabels: false,
                selectedIconTheme: IconThemeData(size: 40, shadows: [
                  BoxShadow(
                      color: Theme.of(context).colorScheme.primary,
                      offset: Offset(0, 0),
                      blurRadius: 20)
                ]),
                unselectedItemColor: Theme.of(context).colorScheme.onSurface,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shop),
                    label: 'Inventory',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: 'Add Workout',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history_outlined),
                    label: 'History',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.science), label: 'Coreß'),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped)));
  }
}
