import 'package:ffapp/components/double_line_divider.dart';
import 'package:flutter/material.dart';



class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {           

    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center (
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //Robot image contianer with radiant background
              Container(
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
              ),

              //Text underneath the robot
              Text(
                "Train consistently to power your Fitness Figure!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 5),

              //Workout stats numbers row
              IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        Text("3"),
                        Text("Weekly Goal"),
                      ]
                    ),
                    DoubleLineDivider(),
                    Column(
                      children: [
                        Text("3"),
                        Text("Weekly Goal"),
                      ]
                    ),
                    DoubleLineDivider(),
                    Column(
                      children: [
                        Text("3"),
                        Text("Weekly Goal"),
                      ]
                    ),
                  ],
                ),
              ),
              

            ], 
          )
        ),
      ),
    ),
    );
  }
}