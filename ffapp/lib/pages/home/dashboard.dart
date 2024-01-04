import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ffapp/components/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/components/double_line_divider.dart';
import 'package:ffapp/components/progress_bar.dart';

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
      backgroundColor: Colors.blueGrey[800],
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Center (
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //created below
              RobotImageHolder(),

              //Text underneath the robot
              Text(
                "Train consistently to power your Fitness Figure!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),

              SizedBox(height: 15),

              //created below
              WorkoutNumbersRow(),
              
              SizedBox(height: 20,),

              //imported from progress bar component
              ProgressBar(),

              SizedBox(height: 20,),

              //progress explanation text
              Text(
                "*Your figures battery is calculated by looking at your current week progress as well as past weeks",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,)

            ], 
          )
        ),
      ),
    ),
    );
  }
}

class RobotImageHolder extends StatelessWidget {
  const RobotImageHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.0,
      height: 400.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: Alignment(0, 0),
          colors: [
            Colors.white.withOpacity(1),
            Colors.white.withOpacity(0),
          ],
          radius: .48,
        ),
      ),
      child: Center(
        child: Image.asset(
          //TO DO: GET APPROPRIATE ROBOT GIF LINK
          "lib/assets/icons/robot1_skin0_cropped.gif",
          height: 260.0,
          width: 260.0,
        ),
      ),
    );
  }
}

class WorkoutNumbersRow extends StatelessWidget {
  const WorkoutNumbersRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Text(
                //TO DO: GET WEEKLY GOAL
                "3",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),
              Text(
                "Weekly Goal",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ]
          ),
          DoubleLineDivider(),
          Column(
            children: [
              Text(
                //TO DO: GET WEEKLY COMPLETED
                "0",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),
              Text(
                "Weekly Completed",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ]
          ),
          DoubleLineDivider(),
          Column(
            children: [
              Text(
                //TO DO: GET TOTAL COMPLETED
                "0",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),
              Text(
                "Total Completed",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ]
          ),
        ],
      ),
    );
  }
}