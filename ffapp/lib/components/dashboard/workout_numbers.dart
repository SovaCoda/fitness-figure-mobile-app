import 'package:ffapp/components/double_line_divider.dart';
import 'package:flutter/material.dart';

class WorkoutNumbersRow extends StatelessWidget {
  final int weeklyGoal;
  final int weeklyCompleted;
  final int lifeTimeCompleted;

  const WorkoutNumbersRow(
      {super.key,
      required this.weeklyCompleted,
      required this.weeklyGoal,
      required this.lifeTimeCompleted});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(children: [
            Text(weeklyGoal.toString(),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
            Text("Weekly",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
            Text("Complete",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ]),
          const DoubleLineDivider(),
          Column(children: [
            Text(weeklyCompleted.toString(),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: weeklyCompleted >= weeklyGoal
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
            Text("Weekly",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
            Text("Goal",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ]),
        ],
      ),
    );
  }
}
