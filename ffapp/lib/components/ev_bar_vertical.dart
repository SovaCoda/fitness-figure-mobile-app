import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EvBarVertical extends StatelessWidget {
  final int currentXp;
  final int maxXp;
  final int currentLvl;
  final Color fillColor;
  final double barHeight;

  const EvBarVertical(
      {super.key,
      required this.currentXp,
      required this.maxXp,
      required this.currentLvl,
      required this.fillColor,
      required this.barHeight});

  @override
  Widget build(BuildContext context) {
    bool isReadyToEvolve = currentXp >= maxXp;
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: barHeight,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      spreadRadius: .1,
                      blurRadius: 1)
                ]),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 10,
                height: (currentXp / maxXp).clamp(0, 1) * barHeight,
                decoration: BoxDecoration(color: fillColor, boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      spreadRadius: .1,
                      blurRadius: 1)
                ]),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              if (isReadyToEvolve) {
                context.goNamed('Evolution');
              }
            },
            child: SizedBox(
              width: 10,
              height: 50,
              child: OverflowBox(
                alignment: Alignment.topLeft,
                maxWidth: 150,
                child: Container(
                  decoration: BoxDecoration(
                      color: isReadyToEvolve
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            spreadRadius: .1,
                            blurRadius: 1)
                      ]),
                  child: Center(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Text("$currentXp/",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    color: Colors.black,
                                  )),
                          Text("${maxXp}EV",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: Colors.black,
                                  )),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Evolution $currentLvl",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: Colors.black,
                                  )),
                        ],
                      )
                    ],
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 3,
      ),
    ]);
  }
}
