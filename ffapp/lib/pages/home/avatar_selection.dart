import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/services/flutterUser.dart';
import "package:ffapp/services/routes.pb.dart" as Routes;
import 'package:ffapp/services/auth.dart';

class AvatarSelection extends StatefulWidget {
  const AvatarSelection({super.key});

  @override
  State<AvatarSelection> createState() =>
      _AvatarSelectionState();
}

class _AvatarSelectionState extends State<AvatarSelection> {
  // Added variable for minutes selection
  FlutterUser user = FlutterUser();
  String curEmail = "Loading...";

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await user.initAuthService();
    await user.checkUser();
    curEmail = await user.getEmail();
    logger.i(user);
  }

  void submitFigure(String figureUrl) async {
    user.updateUser(Routes.User(
        email: curEmail,
        curFigure: figureUrl)); // Updated workoutMinTime value
    if (await user.getWorkoutGoal() == 0 || await user.getWorkoutMinTime() == 0) {
      context.goNamed('WorkoutFrequencySelection');
    } else {
      context.goNamed('Home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30,),

              const Text(
                "Pick your:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                )
              ),

              const Text(
                "Fitness Figure",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )
              ),

              const SizedBox(height: 10,),

              Container(
                width: 260.0,
                height: 260.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: IconButton(
                      icon: Image.asset('lib/assets/icons/robot1_skin0_cropped.gif'),
                      onPressed: () {submitFigure("robot1_skin0_cropped");},
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Container(
                width: 260.0,
                height: 260.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: IconButton(
                      icon: Image.asset('lib/assets/icons/robot2_skin0_cropped.gif'),
                      onPressed: () {submitFigure("robot2_skin0_cropped");},
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}