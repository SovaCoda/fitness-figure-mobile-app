import 'package:ffapp/components/utils/time_utils.dart';
import 'package:flutter/material.dart';

class WorkoutTimeShower extends StatelessWidget {
  final int workoutMinTime;
  final Color themeColor;
  final TextStyle textStyle;
  final bool secondsTrueMinutesFalse;
  final bool goalMet;
  final bool showStatus;

  const WorkoutTimeShower(
      {super.key,
      required this.textStyle,
      this.workoutMinTime = 0,
      this.themeColor = Colors.white,
      this.secondsTrueMinutesFalse = false,
      this.showStatus = false,
      this.goalMet = false});

  @override
  Widget build(context) {
    return Row(
      children: [
        if (showStatus)
          goalMet
              ? Semantics(
                  identifier: 'goal-met-img',
                  child: Icon(Icons.check,
                      color: themeColor,
                      shadows: const [
                        BoxShadow(
                            blurRadius: 4,
                            color: Colors.black,
                            offset: Offset(0, 4))
                      ],
                      size: 15))
              : Semantics(
                  identifier: 'goal-not-met-img',
                  child: const Icon(Icons.timer_off_outlined,
                      color: Colors.red,
                      shadows: [
                        BoxShadow(
                            blurRadius: 4,
                            color: Colors.black,
                            offset: Offset(0, 4))
                      ],
                      size: 15)),
        Semantics(
            identifier: 'post-workout-time',
            child: Text(
                secondsTrueMinutesFalse
                    ? formatSeconds(workoutMinTime)
                    : formatSeconds(workoutMinTime * 60),
                style: textStyle.copyWith(
                    color: themeColor,
                    shadows: [],
                    fontFamily: "Roboto",
                    fontSize: 19))),
        const SizedBox(width: 7.13),
        Icon(Icons.access_time, color: themeColor, size: 30),
      ],
    );
  }
}
