import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/dashboard.dart';
import 'package:ffapp/pages/home/fitventures.dart';
import 'package:ffapp/pages/home/history.dart';
import 'package:ffapp/pages/home/inventory.dart';
import 'package:ffapp/pages/home/profile.dart';
import 'package:ffapp/pages/home/workout_adder.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  //acts as a directory of the widgets that the navbar can route to and render
  static final List<Widget> _pages = <Widget>[
    const Dashboard(),
    const Inventory(),
    const WorkoutAdder(),
    History(),
    const Profile(),
    const Fitventures()
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
        backgroundColor: Theme.of(context).colorScheme.background,

        //permanent top bar if we want it
        appBar: AppBar(
          title: Text(
            'FF', 
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          backgroundColor: Colors.transparent,
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
                        return Text(
                          currencyModel.currency,
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          )
                        );
                      },
                    ),
                    SizedBox(width: 10.0),
                    Icon(
                      Icons.currency_exchange,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ],
                ),
              ),
            ),

            //question mark area that displays an alert on tap
            InkWell(
              onTap:() => {
                showDialog(
                  context: context,
                  builder: (context) {
                  return AlertDialog(
                    title: const Text("Questions?"),
                    content: const Text(
                        '''Fitness figure is a gamified fitness motivation app that aims to combat inactivity and health probelms every where. If you have any questions feel free to reach out to us at our email: \n\n\t\t\t\t\t\t\t\tfitnessfigure@gmail.com'''),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();;
                        },
                      child: const Text("Get Fit")
                      ),
                    ],
                    );
                  }
                )
              },
              child: Row(
                children: [
                  SizedBox(width: 10.0),
                  Icon(Icons.question_mark, color: Theme.of(context).colorScheme.onBackground),
                  const SizedBox(width: 4.0),
                ],
              )
            )
          ],
        ),

        //renders the page that the nav bar has currently selected
        //indexed stack allows pages to retain their state when switching between them
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),

        //permanent footer navigation that changes the page index state to switch displays
        bottomNavigationBar: 
          Theme(
            data: Theme.of(context).copyWith(
               // sets the background color of the `BottomNavigationBar`
              canvasColor: Theme.of(context).colorScheme.surfaceVariant,
              
            ),
            
            child: BottomNavigationBar(
              unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
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
                  icon: Icon(Icons.map_outlined), 
                  label: 'Fitventures')
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped)
        )
              
    );
          
  }
}
