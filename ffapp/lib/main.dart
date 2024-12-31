import 'dart:async';
import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:ffapp/components/skin_view.dart';
import 'package:ffapp/components/utils/chat_model.dart';
import 'package:ffapp/components/utils/history_model.dart';
import 'package:ffapp/pages/auth/register.dart';
import 'package:ffapp/pages/auth/sign_in.dart';
import 'package:ffapp/pages/home/avatar_selection.dart';
import 'package:ffapp/pages/home/chat.dart';
import 'package:ffapp/pages/home/evo.dart';
import 'package:ffapp/pages/home/fitventures.dart';
import 'package:ffapp/pages/home/home.dart';
import 'package:ffapp/pages/home/personality.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/pages/home/subscribe.dart';
import 'package:ffapp/pages/home/survey.dart';
import 'package:ffapp/pages/home/workout_frequency_selection.dart';
import 'package:ffapp/pages/landing.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/connectivity_manager.dart';
import 'package:ffapp/services/providers.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/services/routes.pbgrpc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as Purchases;
import 'package:shared_preferences/shared_preferences.dart';



class SelectedFigureProvider extends ChangeNotifier {
  int _selectedFigureIndex = 0;

  SelectedFigureProvider() {
    _loadSelectedIndex();
  }

  int get selectedFigureIndex => _selectedFigureIndex;

  void setSelectedFigureIndex(int index) async {
    _selectedFigureIndex = index;
    notifyListeners();

    // Save the selected index
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedFigureIndex', index);
  }

  Future<void> _loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFigureIndex = prefs.getInt('selectedFigureIndex') ?? 0;
    notifyListeners();
  }
}

class CurrencyModel extends ChangeNotifier {
  String currency = "0000";
  void setCurrency(String newCurrency) {
    currency = newCurrency;
    notifyListeners();
  }

  void addToCurrency(double numberToAdd) {
    double currentCurrency = double.parse(currency);
    String newCurrency = (currentCurrency + numberToAdd).toStringAsFixed(2);
    currency = newCurrency;
    notifyListeners();
  }
}

class UserModel extends ChangeNotifier {
  Routes.User? user = Routes.User();

  String newEmail = "";

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

  void setWorkoutMinTime(Int64 newValue) {
    user?.workoutMinTime = newValue;
    notifyListeners();
  }

  void setPremium(Int64 premium) {
    user?.premium = premium;
    notifyListeners();
  }

  bool isPremium() {
    if (user?.premium == Int64(1)) {
      return true;
    } else {
      return false;
    }
  }

  void setNewEmail(String newEmail) {
    this.newEmail = newEmail;
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
  Routes.FigureInstance? figure = Routes.FigureInstance(
      figureName: "robot1", curSkin: "0", evLevel: 0, evPoints: 0, charge: 0);
  bool readyToEvolve = false;

  Map<String, bool> capabilities = {
    "Research Unlocked": false,
    "Research 20% Faster": false,
    "Task EV +20%": false,
    "Multi Tasking": false,
    "Halve Research Time": false
  };

  Map<String, int> capabilityUnlocks = {
    "Research Unlocked": 1,
    "Research 20% Faster": 2,
    "Task EV +20%": 3,
    "Multi Tasking": 4,
    "Halve Research Time": 7,
  };

  void updateCapabilities(FigureInstance figure) {
    capabilities.forEach((key, value) {
      if (figure.evLevel >= capabilityUnlocks[key]!) {
        capabilities[key] = true;
      } else {
        capabilities[key] = false;
      }
    });

    notifyListeners();
  }

  void setFigure(Routes.FigureInstance newFigure) {
    figure = newFigure;
    updateCapabilities(newFigure);
    notifyListeners();
  }

  int get EVLevel => figure?.evLevel ?? 0;

  String composeFigureUrl() {
    if (figure == null) {
      return "robot1/robot1_skin0_evo0_cropped_happy";
    } else {
      return "${figure!.figureName}/${figure!.figureName}_skin0_evo${figure!.evLevel}_cropped_happy"; // set to skin0 for now bc no skins
    }
  }

  void setFigureSkin(String newValue) {
    if (figure != null) {
      figure?.curSkin = newValue;
      notifyListeners();
    }
  }

  void setFigureLevel(int newValue) {
    if (figure != null && newValue <= 7) {
      figure?.evLevel = newValue;
      notifyListeners();
    }
  }

  void setFigureEv(int newValue) {
    if (figure != null) {
      figure?.evPoints = newValue;
      notifyListeners();
    }
  }

  void setFigureCharge(int newValue) {
    if (figure != null) {
      figure?.charge = newValue;
      notifyListeners();
    }
  }

  int getFigureEvPoints(String figureName) {
    return figure?.figureName == figureName ? figure!.evPoints : 0;
  }

  int getFigureEvLevel(String figureName) {
    return figure?.figureName == figureName ? figure!.evLevel : 0;
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
  await dotenv.load(fileName: ".env");
  // Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  OpenAI.apiKey = dotenv.env['OPENAI_KEY']!;
  // await Stripe.instance.applySettings();

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
      ChangeNotifierProvider(create: (_) => FigureInstancesProvider()),
      ChangeNotifierProvider(create: (_) => SelectedFigureProvider()),
      ChangeNotifierProvider(
          create: (context) => ChatModel()..init(context: context)),
      ChangeNotifierProvider(create: (_) => HomeIndexProvider()),
    ], child: const MyApp()),
  );
}

/// The route configuration.
final GoRouter _router = 
GoRouter(initialLocation: '/', navigatorKey: ConnectivityService.navigatorKey, routes: [
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
    name: 'Workout',
    path: '/workout',
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
      name: 'FigureStore',
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
  GoRoute(
    name: 'Chat',
    path: '/chat',
    builder: (context, state) => const ChatPage(),
  ),
  GoRoute(
    name: 'Personality',
    path: '/edit_personality',
    builder: (context, state) => const EditPersonalityPage(),
  ),
  GoRoute(
    name: 'SkinViewer',
    path: '/skin_viewer',
    builder: (context, state) => const SkinViewer(),
  ),
//   GoRoute(
//     path: '/figure_details/:figureUrl',  // 👈 Defination of params in the path is important
//     name: 'FigureDetails',
//     builder: (context, state) => FigureDetails(
//       figureUrl: state.pathParameters['figureUrl'],
//   ),
// ),   !!THIS WAS REMOVED IN FAVOR OF POPUP INSTEAD OF ACUTAL ROUTE BUT IM KEEPING IT CAUSE I DONT KNOW IF REESE WANTS IT!!
],);

final bool _kAutoConsume = Platform.isIOS || true;
const String _fitnessFigurePlusSubscriptionId = 'ffigure';

const List<String> _kProductIds = <String>[_fitnessFigurePlusSubscriptionId];

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initRevenueCatPlatform();
    super.initState();
  }

  Future<void> initRevenueCatPlatform() async {
    await dotenv.load(fileName: ".env");

    if (kDebugMode) {
      await Purchases.Purchases.setLogLevel(Purchases.LogLevel.debug);
    }

    Purchases.PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      if (kDebugMode) {
        print("RevenueCat configuration for Android is not implemented yet.");
      }
      return; // Prevent further execution for Android
    } else if (Platform.isIOS) {
      configuration = Purchases.PurchasesConfiguration(
        dotenv.env['REVENUECAT_PROJECT_APPLE_API_KEY']!,
      );
    }
    if (configuration != null) {
      await Purchases.Purchases.configure(configuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityService();
    return MaterialApp.router(
      title: 'Fitness Figure',
      theme: ThemeData(
        useMaterial3: true,
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
        textTheme: TextTheme(
          displayLarge: GoogleFonts.novaSquare(fontSize: 64),
          displayMedium: GoogleFonts.novaSquare(fontSize: 20),
          displaySmall: GoogleFonts.novaSquare(fontSize: 16),
          headlineLarge:
              GoogleFonts.novaSquare(fontSize: 26, letterSpacing: 2.0),
          headlineMedium: GoogleFonts.novaSquare(fontSize: 36),
          headlineSmall: GoogleFonts.novaSquare(fontSize: 48),
          bodyMedium: GoogleFonts.novaSquare(fontSize: 24),
          titleMedium: GoogleFonts.novaSquare(fontSize: 20),
          titleSmall: GoogleFonts.novaSquare(fontSize: 14),
          labelMedium: GoogleFonts.novaSquare(fontSize: 12),
          labelSmall: GoogleFonts.novaSquare(fontSize: 16),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

// class TestApp extends StatelessWidget {
//   const TestApp({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     ConnectivityService();
//     return MaterialApp(
//       navigatorKey: ConnectivityService.navigatorKey,
//       title: 'Test App',
//       theme: ThemeData(
//         useMaterial3: true,

//         // Define the default brightness and colors.
//       ),
//       home: const SignIn(),
//     );
//   }
// }
