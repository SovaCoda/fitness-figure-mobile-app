import 'package:ffapp/components/utils/time_utils.dart';
import 'package:flutter/material.dart';

class WorkoutTimeShower extends StatelessWidget {
  final int workoutMinTime;
  final Color themeColor;
  final TextStyle textStyle;
  final bool secondsTrueMinutesFalse;
  final bool goalMet;
  final bool showStatus;

  const WorkoutTimeShower({super.key, required this.textStyle, this.workoutMinTime = 0, this.themeColor = Colors.white, this.secondsTrueMinutesFalse = false, this.showStatus = false, this.goalMet = false});


  @override
  Widget build(context) { 
    return Row(
            children: [
              if(showStatus)
              goalMet ?  
              Icon(Icons.check,
                  color: themeColor,
                  shadows: const [
                    BoxShadow(
                        blurRadius: 4,
                        color: Colors.black,
                        offset: Offset(0, 4))
                  ],
                  size: 15) : const Icon(Icons.timer_off_outlined,
                  color: Colors.red,
                  shadows: [
                    BoxShadow(
                        blurRadius: 4,
                        color: Colors.black,
                        offset: Offset(0, 4))
                  ],
                  size: 15) ,
              Text(
                  secondsTrueMinutesFalse ? formatSeconds(workoutMinTime) : formatSeconds(workoutMinTime * 60),
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