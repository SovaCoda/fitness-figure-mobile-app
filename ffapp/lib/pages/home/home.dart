import 'dart:async';

import 'package:ffapp/components/button_themes.dart';
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
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/local_notification_service.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:ffapp/icons/fitness_icon.dart';

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

  int? _selectedIndex;

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
    await Future.delayed(Duration(seconds: 3));
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
        await Future.delayed(Duration(seconds: 3));
        List<ConnectivityResult> secondTry =
            await _connectivity.checkConnectivity();

        if (secondTry[0] == ConnectivityResult.none) {
          if (mounted) {
            logger.i("Status was twice no connection, sending reset request.");
            showFFDialogWithChildren(
                "Offline",
                [
                  Text(
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
        appBar: PreferredSize(preferredSize: Size(MediaQuery.sizeOf(context).width, 60), 
          child: SizedBox(
            width: 20,
            height: 400,
            child: OverflowBox(
              maxHeight: 400,
              maxWidth: MediaQuery.sizeOf(context).width + 10,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(offset: const Offset(0,10), child: SvgPicture.asset('lib/assets/art/panel_top_bg.svg', width: MediaQuery.sizeOf(context).width + 100, height: 150,)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 30, 8, 0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    
                      children: [
                      
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
                      onTap: () async {
                      try {
                        CustomerInfo customerInfo = await Purchases.getCustomerInfo();
                        // access latest customerInfo
                        if (customerInfo.entitlements.active['ff_plus'] != null)
                        {
                          DateTime expiraryDate = DateTime.parse(customerInfo.entitlements.active['ff_plus']!.expirationDate!).toLocal();
                          DateFormat displayFormat = DateFormat("MM/dd/yyyy hh:mm a");
                          showFFDialogWithChildren("Youre Subscribed!", [
                            Column(children: [
                              Text('Your benefits last until ${displayFormat.format(expiraryDate)}')
                            ],)
                          ], true, FfButton(text: "Awesome!", textColor: Theme.of(context).colorScheme.onPrimary, backgroundColor: Theme.of(context).colorScheme.primary, onPressed: () => Navigator.of(context).pop()), context);
                        }
                        else {
                          final offers = await Purchases.getOfferings();
                          final offer = offers.getOffering('ffigure_offering');
                          final paywallresult = await RevenueCatUI.presentPaywall(offering: offer, displayCloseButton: true);
                          logger.i('Paywall Result $paywallresult');
                          if(paywallresult == PaywallResult.purchased || paywallresult == PaywallResult.restored){
                            Provider.of<UserModel>(context, listen: false).setPremium(Int64.ONE);
                          }
                        }
                      } on PlatformException catch (e) {
                          // Error fetching customer info
                        }
                      },
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
                            showFFDialog(
                              "Questions/Concerns",
                              "Feel free to email us at fitnessfigure01@gmail.com with any feedback or questions, we'd love to hear from you!",
                              true,
                              context
                            )
                          },
                      child: Row(
                        children: [
                          const SizedBox(width: 10.0),
                          Icon(Icons.question_mark,
                              color: Theme.of(context).colorScheme.onSurface),
                          const SizedBox(width: 4.0),
                        ],
                      )),
                              ],),
                  )
                ],
              ),
            ),
          ),),
        //permanent top bar if we want it
        // appBar: AppBar(
        //   toolbarHeight: 60,
        //   key: _appBarKey,
        //   title: Text(
        //     'FF',
        //     style: Theme.of(context).textTheme.headlineLarge!.copyWith(
        //           color: Theme.of(context).colorScheme.onSurface,
        //         ),
        //   ),
        //   backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(127),
        //   actions: 
        // ),

        //renders the page that the nav bar has currently selected
        //indexed stack allows pages to retain their state when switching between them
        body: 
        Stack(children: [
          
          OverflowBox(maxWidth:MediaQuery.sizeOf(context).width, maxHeight: MediaQuery.sizeOf(context).height, child: Image.asset('lib/assets/art/ff_background.png', width: MediaQuery.sizeOf(context).width+ 200, height: MediaQuery.sizeOf(context).height,)),
          IndexedStack(
            index: _selectedIndex,
            children: _pages,
          )
        ]),

        //permanent footer navigation that changes the page index state to switch displays
        bottomNavigationBar: SizedBox(
          width: 200,
          height: 110,
          child: OverflowBox(
            
            alignment: Alignment.bottomCenter,
            minHeight: 200,
            minWidth: 200,
            maxHeight: 200,
            maxWidth: MediaQuery.sizeOf(context).width,
            child: Stack(
              alignment: Alignment.bottomCenter,
              
              children: [
                Transform.translate(offset: Offset(0, 0), child: SvgPicture.asset('lib/assets/art/panel_bottom_bg.svg', width: MediaQuery.sizeOf(context).width, height: 175,)) ,
                Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Theme.of(context).colorScheme.surface.withAlpha(0),
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
                        currentIndex: _selectedIndex ?? 0,
                        onTap: _onItemTapped)),
              ],
            ),
          ),
        ));
  }
}
