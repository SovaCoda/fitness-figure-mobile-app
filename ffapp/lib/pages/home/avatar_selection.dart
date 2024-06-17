import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/services/flutterUser.dart';
import "package:ffapp/services/routes.pb.dart" as Routes;
import 'package:ffapp/services/auth.dart';
import 'package:provider/provider.dart';

class AvatarSelection extends StatefulWidget {
  const AvatarSelection({super.key});

  @override
  State<AvatarSelection> createState() =>
      _AvatarSelectionState();
}

class _AvatarSelectionState extends State<AvatarSelection> {
  // Added variable for minutes selection
  FlutterUser user = FlutterUser();
  late AuthService auth;
  String curEmail = "Loading...";

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);

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
        curFigure: figureUrl));

    await auth.createFigureInstance(Routes.FigureInstance(figureName: figureUrl, userEmail: curEmail, curSkin: "0", evPoints: 0, charge: 70, lastReset: '2001-09-04 19:21:00'));
    
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

              Text(
                "Pick your:",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                )
              ),

              Text(
                "Fitness Figure",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                )
              ),

              const SizedBox(height: 30,),

              Container(
                width: 260.0,
                height: 260.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: Center(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: IconButton(
                      icon: Image.asset('lib/assets/robot1/robot1_skin0_evo0_cropped_happy.gif'),
                      onPressed: () {submitFigure("robot1");},
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Container(
                width: 260.0,
                height: 260.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: Center(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: IconButton(
                      icon: Image.asset('lib/assets/robot2/robot2_skin0_evo0_cropped_happy.gif'),
                      onPressed: () {submitFigure("robot2");},
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