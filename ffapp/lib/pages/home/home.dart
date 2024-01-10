import 'package:ffapp/components/currency_button.dart';
import 'package:ffapp/pages/home/dashboard.dart';
import 'package:ffapp/pages/home/profile.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/pages/home/workout_adder.dart';
import 'package:flutter/material.dart';

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
  Text("History"),
  Profile()
  ];

  int _selectedIndex = 0; 

  void _onItemTapped(int index) {
    setState(() {
        _selectedIndex = index;
      });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.blueGrey[800],

      //permanent top bar if we want it
      appBar: AppBar(
        title: const Text('FF',
          style: TextStyle(
            color: Colors.lightGreen
          )
        ),
        backgroundColor: Colors.transparent,
        actions: [ 
          IconButton(
            icon: const Icon(
              Icons.currency_exchange,
              color: Colors.lightGreen,
            ),
            tooltip: 'Currency',
            onPressed: () {}
          ),
          IconButton(
            icon: const Icon(
              Icons.question_mark,
              color: Colors.lightGreen
            ),
            tooltip: 'Help',
            onPressed: () {}
          )
        ],
      ),

      //renders the page that the nav bar has currently selected
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),

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
        onTap: _onItemTapped
      )
    );
  }
}
