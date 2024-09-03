import 'package:ffapp/components/resuables/border_fillable_%20container.dart';
import 'package:flutter/material.dart';

class WeekGoalShower extends StatelessWidget {
  final int weeklyGoal;
  final int weeklyCompleted;

  const WeekGoalShower(
      {super.key, required this.weeklyCompleted, required this.weeklyGoal});
  @override
  Widget build(BuildContext context) {
    return BorderFillableContainer(
      borderColor: Theme.of(context).colorScheme.primary,
      fillColor: Theme.of(context).colorScheme.surface,
      borderWidth: 2,
      max: weeklyGoal.toDouble(),
      current: weeklyCompleted.toDouble(),
      child: Column(children: [
        Text("Week Complete",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(weeklyCompleted.toString(),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    )),
            SizedBox(width: 10),
            Text("/",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    )),
            SizedBox(width: 10),
            Text(weeklyGoal.toString(),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    )),
          ],
        ),
      ]),
    );
  }
}
