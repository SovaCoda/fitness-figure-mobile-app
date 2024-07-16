import 'package:ffapp/components/clippers/ev_bar_clipper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EvBarVertical extends StatelessWidget {
  final int currentXp;
  final int maxXp;
  final int currentLvl;
  final Color fillColor;
  final double barHeight;
  final double barWidth;

  const EvBarVertical(
      {super.key,
      required this.currentXp,
      required this.maxXp,
      required this.currentLvl,
      required this.fillColor,
      required this.barHeight,
      required this.barWidth
      });

  @override
  Widget build(BuildContext context) {
    bool isReadyToEvolve = currentXp >= maxXp;
    double innerBarWidth = barWidth/2;
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: barWidth,
            height: barHeight,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: innerBarWidth,
                height: (currentXp / maxXp).clamp(0, 1) * barHeight,
                decoration: BoxDecoration(color: fillColor),
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
                maxHeight: 50,
                maxWidth: 150,
                alignment: Alignment.topLeft,
                child: ClipPath(
                  clipper: EvBarClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.secondaryFixed,
                            ]),
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
          ),
        ],
      ),
      const SizedBox(
        height: 3,
      ),
    ]);
  }
}
