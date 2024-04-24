import 'dart:ffi';

import 'package:ffapp/pages/auth/register.dart';
import 'package:ffapp/pages/auth/sign_in.dart';
import 'package:ffapp/pages/home/avatar_selection.dart';
import 'package:ffapp/pages/home/figure_details.dart';
import 'package:ffapp/pages/home/workout_frequency_selection.dart';
import 'package:ffapp/pages/landing.dart';
import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/pages/home/home.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;

class CurrencyModel extends ChangeNotifier {
  String currency = "0000";
  void setCurrency(String newCurrency) {
    currency = newCurrency;
    notifyListeners();
  }
}

class UserModel extends ChangeNotifier {
  Routes.User? user;
  void setUser(Routes.User newUser) {
    user = newUser;
    notifyListeners();
  }
}

class FigureModel extends ChangeNotifier {
  Routes.FigureInstance? figure;
  int EVLevel = 0;
  
  void setFigure(Routes.FigureInstance newFigure) {
    figure = newFigure;
    notifyListeners();
  }

  void setFigureLevel(int newValue) {
    EVLevel = newValue;
    notifyListeners();
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AuthService auth = await AuthService.instance;
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
      builder: (context, state) => AvatarSelection()),
  GoRoute(
      name: 'SkinStore',
      path: '/store',
      builder: (context, state) => const Store()),
//   GoRoute(
//     path: '/figure_details/:figureUrl',  // 👈 Defination of params in the path is important
//     name: 'FigureDetails',
//     builder: (context, state) => FigureDetails(
//       figureUrl: state.pathParameters['figureUrl'],
//   ),
// ),   !!THIS WAS REMOVED IN FAVOR OF POPUP INSTEAD OF ACUTAL ROUTE BUT IM KEEPING IT CAUSE I DONT KNOW IF REESE WANTS IT!!
]);

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fitness Figure',
      theme: ThemeData(
        useMaterial3: true,
        

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(46, 207, 13, 1),
          // ···
          brightness: Brightness.dark,
          
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        // I've assigned these to different elements in the app, be careful
        // though because adding more might change the display of default
        // stuff like buttons and popups - Reese
        textTheme: TextTheme(
          //really big things like the timer counter
          displayMedium: GoogleFonts.orbitron(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          //top bar
          headlineLarge: GoogleFonts.oswald(
            fontSize: 26,
            fontStyle: FontStyle.italic,
            letterSpacing: 2.0,
          ),
          //page titles
          headlineMedium: GoogleFonts.orbitron(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          //less important big stuff, ex. numbers in the dashboard
          headlineSmall: GoogleFonts.orbitron(
            fontSize: 20,
          ),
          //medium title ex. frequency selection prompt
          titleMedium: GoogleFonts.roboto(
              fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: .1),
          //small titles, ex. dashboard message and settings
          titleSmall: GoogleFonts.roboto(
              fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: .1),
          //small labels, ex. shop labels and dashboard disclaimer
          labelMedium: GoogleFonts.roboto(
            fontSize: 12,
          ),
        ),
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
      home: SignIn(),
    );
  }
}
