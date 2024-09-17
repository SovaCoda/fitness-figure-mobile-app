import 'package:ffapp/components/resuables/border_fillable_%20container.dart';
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
      height: MediaQuery.of(context).size.height * 0.138,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: BorderFillableContainer(
              borderColor: Theme.of(context).colorScheme.primary,
              fillColor: Theme.of(context).colorScheme.surface,
              borderWidth: 2,
              max: weeklyGoal.toDouble(),
              current: weeklyCompleted.toDouble(),
              child: Column(
                children: [
                  Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Week Complete",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: MediaQuery.of(context).size.height * 0.05,
                          ),
                    ),
                  ),
                  ),
                  Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            weeklyCompleted.toString(),
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: MediaQuery.of(context).size.height * 0.05
                                ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Text(
                        "/",
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: MediaQuery.of(context).size.height * 0.05
                            ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            weeklyGoal.toString(),
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: MediaQuery.of(context).size.height * 0.05
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
              )],
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.025),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Column(
                children: [
                  Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Streak",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: MediaQuery.of(context).size.height * 0.05
                          ),
                    ),
                  ),
                  ),
                  Flexible(
                  
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      streak.toString(),
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: MediaQuery.of(context).size.height * 0.05
                          ),
                    ),
                  ),
              )],
              ),
            ),
          ),
        ],
      ),
    );
  }
}