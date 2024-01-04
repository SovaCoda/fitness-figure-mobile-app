import 'package:flutter/material.dart';

class AvatarSelection extends StatelessWidget {
  AvatarSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
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
                      onPressed: () {},
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
                      onPressed: () {},
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