import 'dart:ffi';

import 'package:ffapp/pages/auth/register.dart';
import 'package:ffapp/pages/auth/sign_in.dart';
import 'package:ffapp/pages/home/avatar_selection.dart';
import 'package:ffapp/pages/home/workout_frequency_selection.dart';
import 'package:ffapp/pages/landing.dart';
import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/pages/home/home.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AuthService auth = await AuthService.instance;
  runApp(Provider<AuthService>.value(
      value: auth,
      child: MyApp(authService: auth),  
    )
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
      builder: (context, state) => const WorkoutFrequencySelection())
]);

class MyApp extends StatelessWidget {
  final AuthService authService;
  const MyApp({Key? key, required this.authService}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fitness Figure',

      theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(255, 255, 255, 1),
          // ···
          brightness: Brightness.dark,
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          displayMedium: GoogleFonts.oswald(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          headlineLarge: GoogleFonts.raleway(
            fontSize: 26,
            fontStyle: FontStyle.italic,
          ),
          headlineMedium: GoogleFonts.raleway(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: GoogleFonts.roboto( 
            fontSize: 20,
          ),
          titleSmall: GoogleFonts.roboto( 
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          labelMedium: GoogleFonts.roboto( 
            fontSize: 12,
          )
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
