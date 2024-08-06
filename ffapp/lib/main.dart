import 'package:dart_openai/dart_openai.dart';
import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:ffapp/pages/home/chat.dart';
import 'package:ffapp/pages/home/evo.dart';
import 'package:fixnum/fixnum.dart';
import 'package:ffapp/pages/auth/register.dart';
import 'package:ffapp/pages/auth/sign_in.dart';
import 'package:ffapp/pages/home/avatar_selection.dart';
import 'package:ffapp/pages/home/fitventures.dart';
import 'package:ffapp/pages/home/subscribe.dart';
import 'package:ffapp/pages/home/survey.dart';
import 'package:ffapp/pages/home/workout_frequency_selection.dart';
import 'package:ffapp/pages/landing.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/firebaseApi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/pages/home/home.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;

class HistoryModel extends ChangeNotifier {
  List<Routes.Workout> workouts = List.empty();
  bool workedOutToday = false;

  List<int> currentWeek = List.filled(7, 0, growable: false);

  DateTime mostRecentSunday(DateTime date)
  {
    return DateTime(date.year, date.month, date.day - date.weekday % 7);
  }

  void setWorkouts(List<Routes.Workout> newWorkouts) {
    DateTime now = DateTime.now();
    DateTime weekstart = mostRecentSunday(now); // get week start (sunday is 7)
    List<DateTime?> workoutsInCurrentWeek = List.filled(7, null, growable: false); // track workouts in our current week
    for (int i = 0; i < newWorkouts.length; i++) {
      DateTime curDate = DateTime.parse(newWorkouts[i].endDate);
      if(curDate.isAfter(weekstart)) {workoutsInCurrentWeek[curDate.weekday % 7] = curDate;} // if workout is in our current week add it to our list 
      if(curDate.day == now.day && curDate.month == now.month && curDate.year == now.year) {workedOutToday = true;}
    }

    for(int i = 0; i < currentWeek.length; i++)
    {
      int status = 0;
      if(workoutsInCurrentWeek[i] == null && weekstart.add(Duration(days: i)).isBefore(now)) {status = 0;} // in the past didnt workout Dark Green
      if(workoutsInCurrentWeek[i] == null && weekstart.add(Duration(days: i)).isAfter(now)) {status = 1;} // in the future hasnt workedout Gray Surface
      if(workoutsInCurrentWeek[i] != null) {status = 2;} // worked out Bright Green

      currentWeek[i] = status;
    }
    workouts = newWorkouts;
    notifyListeners();
  }
}

class CurrencyModel extends ChangeNotifier {
  String currency = "0000";
  void setCurrency(String newCurrency) {
    currency = newCurrency;
    notifyListeners();
  }

  void addToCurrency(int numberToAdd) {
    int currentCurrency = int.parse(currency);
    String newCurrency = (currentCurrency + numberToAdd).toString();
    currency = newCurrency;
    notifyListeners();
  }
}

class UserModel extends ChangeNotifier {
  Routes.User? user = Routes.User();

  int get baseGain => 5;

  int get streak => 5;

  void setUser(Routes.User newUser) {
    user = newUser;
    notifyListeners();
  }

  void setUserWeekCompleted(Int64 newValue) {
    user?.weekComplete = newValue;
    notifyListeners();
  }

  void setUserWeekGoal(Int64 newValue) {
    user?.weekGoal = newValue;
    notifyListeners();
  }
}

class InventoryModel extends ChangeNotifier {
  List<Routes.FigureInstance> figureInstancesList = List.empty();

  void setFigureInstancesList(
      List<Routes.FigureInstance> newFigureInstancesList) {
    figureInstancesList = newFigureInstancesList;
    notifyListeners();
  }
}

class FigureModel extends ChangeNotifier {
  Routes.FigureInstance? figure = Routes.FigureInstance(figureName: "robot1", curSkin: "0", evLevel: 0, evPoints: 0, charge: 0);
  int EVLevel = 0;
  bool readyToEvolve = false;

  void setFigure(Routes.FigureInstance newFigure) {
    figure = newFigure;
    notifyListeners();
  }

  String composeFigureUrl() {
    if (figure == null) {
      return "robot1/robot1_skin0_evo0_cropped_happy";
    } else {
      return "${figure!.figureName}/${figure!.figureName}_skin${figure!.curSkin}_evo${figure!.evLevel}_cropped_happy";
    }
  }

  void setFigureSkin(String newValue) {
    figure?.curSkin = newValue;
    notifyListeners();
  }

  void setFigureLevel(int newValue) {
    if (newValue <= 7) {
      EVLevel = newValue;
      figure?.evLevel = newValue;
      notifyListeners();
    }
  }

  void setFigureEv(int newValue) {
    figure?.evPoints = newValue;
    notifyListeners();
  }

  void setFigureCharge(int newValue) {
    figure?.charge = newValue;
    notifyListeners();
  }
}

//provider class that provides the keys to other widgets for the app bar and navigation bar
class AppBarAndBottomNavigationBarModel extends ChangeNotifier {
  GlobalKey _appBarKey = GlobalKey();
  GlobalKey _bottomNavBarKey = GlobalKey();

  GlobalKey get appBarKey => _appBarKey;
  GlobalKey get bottomNavBarKey => _bottomNavBarKey;

  double usableScreenHeight = 0;

  void setAppBarKey(GlobalKey newKey) {
    _appBarKey = newKey;
    notifyListeners();
  }

  void setBottomNavBarKey(GlobalKey newKey) {
    _bottomNavBarKey = newKey;
    notifyListeners();
  }

  void setUsableScreenHeight(double newHeight) {
    usableScreenHeight = newHeight;
    notifyListeners();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  OpenAI.apiKey = "sk-proj-QpCgg3HzPQvHSRjXu9HRT3BlbkFJ4aGGyeCD6DyYcw1qx1w7";
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final AuthService auth = await AuthService.instance;
  //await FirebaseApi().initNotifications();
  runApp(
    MultiProvider(providers: [
      Provider(
        create: (context) => auth,
      ),
      ChangeNotifierProvider(
        create: (context) => CurrencyModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => UserModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => FigureModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => AppBarAndBottomNavigationBarModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => InventoryModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => HistoryModel(),
      ),
      ChangeNotifierProvider(create: (context) => MessageProvider()),
    ], child: const MyApp()),
  );
}

/// The route configuration.
final GoRouter _router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
      name: 'LandingPage',
      path: '/',
      builder: (context, state) => const LandingPage()),
  GoRoute(
    name: 'Home',
    path: '/home', // Update the path to '/home'
    builder: (context, state) => const DashboardPage(),
  ),
  GoRoute(
      name: 'Register',
      path: '/register',
      builder: (context, state) => const Register()),
  GoRoute(
      name: 'SignIn',
      path: '/signin',
      builder: (context, state) => const SignIn()),
  GoRoute(
      name: 'WorkoutFrequencySelection',
      path: '/workout_frequency_selection',
      builder: (context, state) => const WorkoutFrequencySelection()),
  GoRoute(
      name: 'AvatarSelection',
      path: '/avatar_selection',
      builder: (context, state) => const AvatarSelection()),
  GoRoute(
      name: 'SkinStore',
      path: '/store',
      builder: (context, state) => const Store()),
  GoRoute(
    name: 'Fitventures',
    path: '/fitventures',
    builder: (context, state) => const Fitventures(),
  ),
  GoRoute(
      name: 'Subscribe',
      path: '/subscribe',
      builder: (context, state) => const SubscribePage()),
  GoRoute(
    name: 'Survey',
    path: '/survey',
    builder: (context, state) => const SurveyWidget(),
  ),
  GoRoute(
    name: 'Evolution',
    path: '/evolution',
    builder: (context, state) => const EvolutionPage(),
  ),
//   GoRoute(
//     path: '/figure_details/:figureUrl',  // 👈 Defination of params in the path is important
//     name: 'FigureDetails',
//     builder: (context, state) => FigureDetails(
//       figureUrl: state.pathParameters['figureUrl'],
//   ),
// ),   !!THIS WAS REMOVED IN FAVOR OF POPUP INSTEAD OF ACUTAL ROUTE BUT IM KEEPING IT CAUSE I DONT KNOW IF REESE WANTS IT!!
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fitness Figure',
      theme: ThemeData(
        useMaterial3: true,

        // Default green theme
        // colorScheme: const ColorScheme(
        //   primary: Color.fromARGB(255, 0, 0, 0),
        //   brightness: Brightness.light,
        //   onPrimary: Color.fromRGBO(31, 112, 41, 1),
        //   onPrimaryContainer: Color.fromRGBO(31, 255, 61, 1),
        //   primaryFixedDim: Color.fromRGBO(0, 29, 1, 1),
        //   secondary: Color.fromRGBO(203, 222, 50, 1),
        //   onSecondary: Color.fromRGBO(52, 71, 6, 1),
        //   secondaryFixed: Color.fromRGBO(30, 157, 60, 1),
        //   error: Colors.red,
        //   onError: Colors.black,
        //   surface: Color.fromRGBO(239, 255, 239, 1),
        //   onSurface: Color.fromRGBO(226, 255, 227, 0.345),
        //   surfaceContainerHighest: Color.fromRGBO(200, 253, 196, 0.81),
        //   surfaceBright: Color.fromRGBO(76, 117, 18, 1), // Alert Dialog
        //   surfaceDim: Color.fromRGBO(59, 64, 13, 1), // Alert
        //   tertiary: Color.fromRGBO(28, 206, 255, 1),
        //   tertiaryFixedDim: Color.fromRGBO(10, 93, 101, 1),
        // ),

        colorScheme: const ColorScheme(
          brightness: Brightness.dark,

          primary: Color.fromARGB(255, 89, 255, 0),
          primaryContainer: Color.fromRGBO(0, 185, 27, 1),
          onPrimary: Color.fromRGBO(0, 0, 0, 1),
          primaryFixedDim: Color.fromRGBO(38, 64, 15, 1),

          secondary: Color.fromRGBO(15, 213, 255, 1),
          secondaryContainer: Color.fromRGBO(0, 141, 171, 1),
          onSecondary: Color.fromRGBO(0, 0, 0, 1),
          secondaryFixedDim: Color.fromRGBO(28, 112, 130, 1),

          tertiary: Color.fromRGBO(255, 119, 0, 1),

          surface: Color.fromRGBO(68, 68, 68, 1),
          onSurface: Color.fromRGBO(255, 255, 255, 1),
          surfaceContainerHighest: Color.fromRGBO(200, 253, 196, 0.81),
          surfaceBright: Color.fromRGBO(76, 117, 18, 1), // Alert Dialog
          surfaceDim: Color.fromRGBO(59, 64, 13, 1), // Alert

          error: Colors.red,
          onError: Colors.black,
        ),

        // A blue theme
        // colorScheme: const ColorScheme(
        //     primary: Color.fromARGB(125, 31, 236, 255),
        //     brightness: Brightness.light,
        //     onPrimary: Color.fromRGBO(31, 101, 112, 1),
        //     onPrimaryContainer: Color.fromRGBO(31, 255, 255, 1),
        //     primaryFixedDim: Color.fromRGBO(0, 29, 29, 1),
        //     secondary: Color.fromRGBO(27, 218, 225, 1),
        //     onSecondary: Color.fromRGBO(6, 71, 44, 1),
        //     secondaryFixed: Color.fromRGBO(30, 146, 157, 1),
        //     error: Colors.red,
        //     surface: Color.fromRGBO(239, 255, 239, 1),
        //     onSurface: Color.fromRGBO(226, 255, 227, 0.345),
        //     surfaceContainerHighest: Color.fromRGBO(200, 253, 196, 0.81),
        //     surfaceBright: Color.fromRGBO(18, 117, 81, 1), // Alert Dialog
        //     surfaceDim: Color.fromRGBO(13, 55, 64, 1) // Alert Dialog
        //     ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        // I've assigned these to different elements in the app, be careful
        // though because adding more might change the display of default
        // stuff like buttons and popups - Reese
        textTheme: TextTheme(
            //really big things like the timer counter
            displayLarge: GoogleFonts.novaSquare(
              fontSize: 64,
            ),
            displayMedium: GoogleFonts.novaSquare(
              fontSize: 20,
            ),
            displaySmall: GoogleFonts.novaSquare(
              fontSize: 16,
            ),

            //top bar
            headlineLarge: GoogleFonts.novaSquare(
              fontSize: 26,
              letterSpacing: 2.0,
            ),
            //page titles
            headlineMedium: GoogleFonts.novaSquare(
              fontSize: 36,
            ),
            //less important big stuff, ex. numbers in the dashboard
            headlineSmall: GoogleFonts.novaSquare(
              fontSize: 48,
            ),
            bodyMedium: GoogleFonts.novaSquare(
              fontSize: 24,
            ),
            //medium title ex. frequency selection prompt
            titleMedium: GoogleFonts.novaSquare(fontSize: 20),
            //small titles, ex. dashboard message and settings
            titleSmall: GoogleFonts.novaSquare(fontSize: 14),
            //small labels, ex. shop labels and dashboard disclaimer
            labelMedium: GoogleFonts.novaSquare(
              fontSize: 12,
            ),
            labelSmall: GoogleFonts.novaSquare(fontSize: 16)),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors.
      ),
      home: const SignIn(),
    );
  }
}
