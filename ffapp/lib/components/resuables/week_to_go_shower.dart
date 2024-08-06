import 'package:ffapp/services/routes.pb.dart';
import 'package:ffapp/services/routes.pbgrpc.dart';
import 'package:flutter/material.dart';

class WeekToGoShower extends StatelessWidget {
  final List<int> workouts;
  final Size boxSize;
  final int weekGoal;

  const WeekToGoShower({super.key, required this.weekGoal, required this.workouts, this.boxSize = const Size(20,20)});
  
  @override
  Widget build(BuildContext context) {
    int numComplete = 0;
    for(int i = 0; i < workouts.length; i++)
    {
      if(workouts[i] == 2) { numComplete++;}
      else if ( workouts[i] == 1) { break;}
    }
    return Column(
      children: [
        Text('^ ${weekGoal - numComplete} To Go!', style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary),),
        Row(children: [for (int index = 0; index < workouts.length; index++)
          Container(width: boxSize.width, height: boxSize.height,
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(color: switch (workouts[index]) 
          {
            0 => Theme.of(context).colorScheme.primaryFixedDim,
            1 => Theme.of(context).colorScheme.surface,
            2 => Theme.of(context).colorScheme.primary,
            int() => throw UnimplementedError
          }
          ),
          )]),
      ],
    );
    }
  
}