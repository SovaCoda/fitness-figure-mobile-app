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
      this.goalMet = false});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (showStatus)
        goalMet
            ? showChevron
                ? Text('^',
                    style: textStyle.copyWith(
                      color: themeColor,
                    ))
                : Text('',
                    style: textStyle.copyWith(
                      color: themeColor,
                    ))
            : Text('X',
                style: textStyle.copyWith(
                  color: Colors.red,
                )),
      SizedBox(
        width: 10,
      ),
      Text(goalMet ? '$streak Days ' : 'BROKEN',
          style: textStyle.copyWith(
            color: themeColor,
            shadows: const [
              BoxShadow(
                  blurRadius: 4, color: Colors.black, offset: Offset(0, 4))
            ],
          )),
      Text(
        '🔥',
        style: textStyle.copyWith(fontSize: 30),
      )
    ]);
  }
}
