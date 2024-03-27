import 'package:flutter/material.dart';

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
                  borderRadius: BorderRadius.all(Radius.circular(2)),
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
                      borderRadius: BorderRadius.all(Radius.circular(2)),
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
            )
          ],
      ),
      SizedBox(height: 3,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
          Text(currentLvl > 10 ? "Level MAX      " : "Level " + currentLvl.toString() + "      ",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant
            ),
          ),
          Text( currentXp.toString() + " / " + maxXp.toString() + " EV",
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