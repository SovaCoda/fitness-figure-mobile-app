import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class WorkoutHistoryView extends StatelessWidget {
  final String dateTime;
  final String robotUrl;
  final int elapsedTime;
  final int chargeGain;
  final int evoGain;
  final int currencyGain;

  WorkoutHistoryView(
      {required this.dateTime,
      required this.elapsedTime,
      required this.chargeGain,
      required this.evoGain,
      required this.currencyGain,
      required this.robotUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 14, 99, 1),
          Color.fromARGB(253, 0, 5, 4)
        ])),
        child: Row(
          children: [
            Opacity(
                opacity: 0.5,
                child: Positioned(
                    bottom: 0,
                    left: 0,
                    child: Image.asset(robotUrl,
                        width: MediaQuery.sizeOf(context).width * 0.2,
                        height: 300, fit: BoxFit.none,))),
          ],
        ));
  }
}
