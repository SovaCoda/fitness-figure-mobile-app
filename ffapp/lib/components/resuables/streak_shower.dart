import 'package:flutter/material.dart';

class StreakShower extends StatelessWidget {
  final int streak;
  final Color themeColor;
  final TextStyle textStyle;
  const StreakShower({super.key, this.streak = 0, required this.textStyle, this.themeColor = const Color.fromRGBO(255, 119, 0, 1)});
  

  @override
  Widget build(BuildContext context) {
    return Row(
            children: [
              Text('$streak Days ',
                  style: textStyle
                      .copyWith(
                    color: themeColor,
                    shadows: const [
                      BoxShadow(
                          blurRadius: 4,
                          color: Colors.black,
                          offset: Offset(0, 4))
                    ],
                  )),
              Text('🔥', style: textStyle.copyWith(fontSize: 30),)
            ]
          );
  }
}