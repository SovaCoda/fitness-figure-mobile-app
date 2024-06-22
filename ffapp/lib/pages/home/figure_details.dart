import 'package:ffapp/components/ev_bar.dart';
import 'package:ffapp/components/robot_image_holder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:ffapp/services/auth.dart';

class FigureDetails extends StatefulWidget {

  String? figureUrl;
  FigureDetails({super.key, this.figureUrl});

  @override
  State<FigureDetails> createState() =>
      _FigureDetails();
}

class _FigureDetails extends State<FigureDetails> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10,),
              RobotImageHolder(url: widget.figureUrl!, height: 300, width: 300),
              const SizedBox(height: 10,),
              EvBar(currentXp: 10, maxXp: 45, currentLvl: 1, fillColor: Theme.of(context).colorScheme.tertiary, barWidth: 200),
              const SizedBox(height: 40,),
              ElevatedButton(onPressed: () => {context.goNamed("Home")}, child: const Text("Go Back"))
            ],
          ),
        ),
      ),
    );
  }
}
