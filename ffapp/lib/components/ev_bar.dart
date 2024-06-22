import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EvBar extends StatelessWidget {

  final int currentXp;
  final int maxXp;
  final int currentLvl;
  final Color fillColor;
  final double barWidth;

  const EvBar({
    super.key,
    required this.currentXp,
    required this.maxXp,
    required this.currentLvl,
    required this.fillColor,
    required this.barWidth
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: barWidth,
              height: 5,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      spreadRadius: .1,
                      blurRadius: 1
                    )]
                ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: (currentXp/maxXp).clamp(0, 1) * barWidth,
                  height: 5,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                      color: fillColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          spreadRadius: .1,
                          blurRadius: 1
                        )]
                    ),
                ),
              ),
            ),
            const SizedBox(width: 5,),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: GestureDetector(
                onTap: () {
                  context.goNamed('Subscribe');
                },
                child: Text("+?", style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).colorScheme.tertiary)),
              ),
            ),
          ],
      ),
      const SizedBox(height: 3,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
          Text(currentLvl > 10 ? "Level MAX      " : "Level $currentLvl      ",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant
            ),
          ),
          Text("$currentXp / $maxXp EV",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant
            ),
          ),
        ],
      )
      ]
    );
  }
}