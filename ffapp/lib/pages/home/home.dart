import 'package:ffapp/pages/home/dashboard.dart';
import 'package:ffapp/pages/home/history.dart';
import 'package:ffapp/pages/home/profile.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/pages/home/workout_adder.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/pages/home/profile.dart';
import 'package:ffapp/services/flutterUser.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  //acts as a directory of the widgets that the navbar can route to and render
  static final List<Widget> _pages = <Widget>[
    const Dashboard(),
    Store(),
    const WorkoutAdder(),
    History(),
    const Profile()
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[800],

        //permanent top bar if we want it
        appBar: AppBar(
          title: const Text('FF', style: TextStyle(color: Colors.lightGreen)),
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currency,
                      style:
                          TextStyle(color: Colors.lightGreen, fontSize: 18.0),
                    ),
                    SizedBox(width: 4.0),
                    Icon(
                      Icons.currency_exchange,
                      color: Colors.lightGreen,
                    ),
                    SizedBox(width: 10.0),
                    Icon(Icons.question_mark, color: Colors.lightGreen),
                    SizedBox(width: 4.0),
                  ],
                ),
              ),
            ),
          ],
        ),

        //renders the page that the nav bar has currently selected
        body: _pages.elementAt(_selectedIndex),

        //permanent footer navigation that changes the page index state to switch displays
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.grey[800],
            unselectedItemColor: Colors.green,
            selectedItemColor: Colors.lightGreen,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shop),
                label: 'Shop',
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
              )
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped));
  }
}
