import 'package:ffapp/pages/auth/register.dart';
import 'package:ffapp/pages/auth/sign_in.dart';
import 'package:ffapp/pages/landing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/pages/home/home.dart';

void main() {
  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes:[
    GoRoute(
      name: 'LandingPage',
      path: '/',
      builder: (context, state) => const LandingPage()
    ),
    GoRoute(
      name: 'Home',
      path: '/home', // Update the path to '/home'
      builder: (context, state) => const DashboardPage(),
    ),    
    GoRoute(
      name: 'Register',
      path: '/register',
      builder: (context, state) => const Register()
    ),
    GoRoute(
      name: 'SignIn',
      path:'/signin',
      builder: (context, state) => const SignIn()
    )
  ]
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fitness Figure',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }

}