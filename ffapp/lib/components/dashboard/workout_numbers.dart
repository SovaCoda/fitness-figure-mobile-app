import 'package:ffapp/components/resuables/border_fillable_%20container.dart';
import 'package:flutter/material.dart';

class WorkoutNumbersRow extends StatelessWidget {
  final int weeklyGoal;
  final int weeklyCompleted;
  final int lifeTimeCompleted;
  final int streak;
  final double availableWidth;

  const WorkoutNumbersRow(
      {super.key,
      required this.weeklyCompleted,
      required this.streak,
      required this.weeklyGoal,
      required this.lifeTimeCompleted,
      this.availableWidth = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: availableWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: BorderFillableContainer(
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
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                    SizedBox(width: 10),
                    Text("/",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                    SizedBox(width: 10),
                    Text(weeklyGoal.toString(),
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                  ],
                ),
              ]),
            ),
          ),
          Container(
            width: 146,
            margin: const EdgeInsets.only(left: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(children: [
              Text("Streak",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      )),
              Text(streak.toString(),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                      )),
            ]),
          ),
        ],
      ),
    );
  }
}
