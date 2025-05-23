import 'package:flutter/material.dart';

class WeekToGoShower extends StatelessWidget {
  final List<int> workouts;
  final Size boxSize;
  final int weekGoal;
  final bool showChevron;
  final double invested;
  final bool isInvesting;

  const WeekToGoShower(
      {super.key,
      this.showChevron = true,
      this.isInvesting = false,
      this.invested = 0,
      required this.weekGoal,
      required this.workouts,
      this.boxSize = const Size(20, 20),});

  @override
  Widget build(BuildContext context) {
    int numComplete = 0;
    for (int i = 0; i < workouts.length; i++) {
      if (workouts[i] == 2) {
        numComplete++;
      } else if (workouts[i] == 1) {
        break;
      }
    }
    final bool isComplete = numComplete >= weekGoal;
    return Column(
      children: [
        Text(
          isComplete
              ? 'Done!'
              : '${showChevron ? "^" : ""} ${weekGoal - numComplete} To Go!',
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (int index = 0; index < workouts.length; index++)
            Container(
              width: boxSize.width,
              height: boxSize.height,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: switch (workouts[index]) {
                0 => Theme.of(context).colorScheme.primaryFixedDim,
                1 => Theme.of(context).colorScheme.primaryFixedDim,
                2 => Theme.of(context).colorScheme.primary,
                int() => throw UnimplementedError
              },),
            ),
        ],),
      ],
    );
  }
}
