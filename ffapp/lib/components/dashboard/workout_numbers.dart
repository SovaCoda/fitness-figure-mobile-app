import 'package:ffapp/components/resuables/border_fillable_%20container.dart';
import 'package:ffapp/icons/fitness_icon.dart';
import 'package:flutter/material.dart';

class WorkoutNumbersRow extends StatelessWidget {
  final int weeklyGoal;
  final int weeklyCompleted;
  final int lifeTimeCompleted;
  final int streak;
  final double availableWidth;

  const WorkoutNumbersRow({
    Key? key,
    required this.weeklyCompleted,
    required this.streak,
    required this.weeklyGoal,
    required this.lifeTimeCompleted,
    this.availableWidth = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "WEEK COMPLETE",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 22,
                    ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 80,
                child: BorderFillableContainer(
                  borderColor: Theme.of(context).colorScheme.primary,
                  fillColor: Theme.of(context).colorScheme.surface,
                  borderWidth: 2,
                  max: weeklyGoal.toDouble(),
                  current: weeklyCompleted.toDouble(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        weeklyCompleted.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                color: const Color.fromRGBO(1, 204, 147, 1),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.06,
                                fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Text(
                        "/",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                color: const Color.fromRGBO(1, 204, 147, 1),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.06,
                                fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Text(
                        weeklyGoal.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                color: const Color.fromRGBO(1, 204, 147, 1),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.06,
                                fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "STREAK",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 22,
                    ),
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  const FitnessIcon(
                    type: FitnessIconType.dashboard_fire,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      child: Text(
                        streak.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                color: const Color.fromRGBO(1, 204, 147, 1),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.06,
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
