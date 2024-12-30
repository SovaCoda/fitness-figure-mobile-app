import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/flutterUser.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FigureDetails extends StatefulWidget {

  final String? figureUrl;
  const FigureDetails({super.key, this.figureUrl});

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

  Future<void> initialize() async {
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
              const SizedBox(height: 40,),
              ElevatedButton(onPressed: () => {context.goNamed("Home")}, child: const Text("Go Back")),
            ],
          ),
        ),
      ),
    );
  }
}
