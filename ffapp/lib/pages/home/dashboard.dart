import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ffapp/components/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late AuthService auth;
  late String text = "Loading...";

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await initAuthService();
    await checkUser();
    String email = await getText();
    setState(() {
      text = email;
    });
  }

  Future<void> checkUser() async {
    logger.i("Checking User Status");
    User? user = await auth.getUser();
    if (user != null) {
      logger.i("User is signed in");
      return;
    }
    logger.i("User is not signed in");
    context.goNamed('SignIn');
  }

  Future<String> getText() async {
    logger.i("getting user");
    return auth.getUser().then((value) => value!.email.toString());
  }

  Future<void> initAuthService() async {
    auth = await AuthService.init();
    logger.i("AuthService initialized");
  }

  void logoutUser() {
    auth.signOut();
    context.goNamed('SignIn');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: AlwaysStoppedAnimation(1),
              builder: (BuildContext context, Widget? child) {
                return Transform.rotate(
                  angle: 2 * 3.1415 * 1,
                  child: child,
                );
              },
              child: Text(
                text,
                style: TextStyle(fontSize: 24),
              ),
            ),
            CustomButton(
              text: 'Logout',
              onTap: logoutUser,
            ),
          ],
        ),
      ),
    );
  }
}
