import 'package:ffapp/components/clippers/ev_bar_clipper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EvBar extends StatelessWidget {
  final int currentXp;
  final int maxXp;
  final Color fillColor;
  final double barHeight;
  final double barWidth;
  final double innerBarPercentage;
  final bool isVertical;
  final bool showInfoBox;

  const EvBar(
      {super.key,
      required this.currentXp,
      required this.maxXp,
      required this.fillColor,
      required this.barHeight,
      required this.barWidth,
      this.showInfoBox = false,
      this.innerBarPercentage = 1,
      this.isVertical = false});

  @override
  Widget build(BuildContext context) {
    bool evoReady = currentXp >= maxXp;
    return Column(
      mainAxisAlignment:
          isVertical ? MainAxisAlignment.end : MainAxisAlignment.center,
      crossAxisAlignment:
          showInfoBox ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        if (!showInfoBox)
          Text(currentXp.toString(),
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Theme.of(context).colorScheme.secondary)),
        Visibility(
          visible: showInfoBox,
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/evolution');
            },
            child: Container(
              height: barHeight,
              width: barWidth * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: evoReady
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.surface,
              ),
              child: Center(
                child: evoReady
                    ? Text('EVO Ready!',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary))
                    : Text('$currentXp/$maxXp EV',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.secondary)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: showInfoBox ? 5 : 0,
        ),
        Stack(
          alignment: isVertical ? Alignment.topCenter : Alignment.centerLeft,
          children: [
            Container(
              width: barWidth,
              height:
                  barHeight, // if vertical swap the width and height to reorient the bar
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.secondaryFixedDim,
              ),
              child: Align(
                alignment:
                    isVertical ? Alignment.topCenter : Alignment.centerLeft,
                child: Container(
                  width: isVertical
                      ? barWidth
                      : (currentXp / maxXp).clamp(0, 1) * barWidth,
                  height: isVertical
                      ? (currentXp / maxXp).clamp(0, 1) * barHeight
                      : barHeight,
                  decoration: BoxDecoration(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
