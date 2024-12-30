import 'package:ffapp/icons/fitness_icon.dart';
import 'package:flutter/material.dart';

class StreakShower extends StatelessWidget {
  final int streak;
  final Color themeColor;
  final TextStyle textStyle;
  final bool showStatus;
  final bool showChevron;
  final bool goalMet;
  const StreakShower(
      {super.key,
      this.streak = 0,
      this.showChevron = false,
      required this.textStyle,
      this.themeColor = const Color.fromRGBO(255, 119, 0, 1),
      this.showStatus = false,
      this.goalMet = false,});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
      if (showStatus)
        goalMet
            ? showChevron
                ? Text('^',
                    style: textStyle.copyWith(
                      color: themeColor,
                    ),)
                : Text('',
                    style: textStyle.copyWith(
                      color: themeColor,
                    ),)
            : Text('X',
                style: textStyle.copyWith(
                  color: Colors.red,
                ),),
      const SizedBox(
        width: 10,
      ),
      Column(
      children: [
        const SizedBox(height: 10),
        Text(goalMet ? streak != 1 ? '$streak DAYS ' : '$streak DAY' : 'BROKEN',
          style: textStyle.copyWith(
            color: streak == 0 ? const Color(0xFF888888) : const Color(0xFF01C089),
            fontFamily: "Roboto",
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
          ),
      ],),
      const SizedBox(width: 7.13),
      FitnessIcon(type: FitnessIconType.dashboard_fire, size: MediaQuery.of(context).size.width * 0.1148854961832061068702290076336),
    ],);
  }
}
