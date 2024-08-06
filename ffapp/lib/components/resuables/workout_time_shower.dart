import 'package:ffapp/components/utils/time_utils.dart';
import 'package:flutter/material.dart';

class WorkoutTimeShower extends StatelessWidget {
  final int workoutMinTime;
  final Color themeColor;
  final TextStyle textStyle;

  const WorkoutTimeShower({super.key, required this.textStyle, this.workoutMinTime = 0, this.themeColor = Colors.white});


  @override
  Widget build(context) { 
    return Row(
            children: [
              Text(
                  formatSeconds(workoutMinTime * 60),
                  style:
                      textStyle
                          .copyWith(
                              color: themeColor,
                              shadows: [
                        const BoxShadow(
                            blurRadius: 4,
                            color: Colors.black,
                            offset: Offset(0, 4))
                      ])),
              Icon(Icons.access_time,
                  color: themeColor,
                  shadows: const [
                    BoxShadow(
                        blurRadius: 4,
                        color: Colors.black,
                        offset: Offset(0, 4))
                  ],
                  size: 30),
            ],
          );
  }
  
}