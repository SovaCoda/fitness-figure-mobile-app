import 'package:ffapp/components/clippers/ev_bar_clipper.dart';
import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EvBar extends StatelessWidget {
  final int currentXp;
  final int maxXp;
  final int overrideGains;
  final Color fillColor;
  final double barHeight;
  final double barWidth;
  final double innerBarPercentage;
  final bool isVertical;
  final bool showInfoBox;
  final bool areWeShadowing;
  final bool simulateCurrentGains;
  final bool didWeWorkoutToday;

  const EvBar(
      {super.key,
      required this.currentXp,
      required this.maxXp,
      required this.fillColor,
      required this.barHeight,
      required this.barWidth,
      this.overrideGains = 0,
      this.didWeWorkoutToday = false,
      this.areWeShadowing = false,
      this.showInfoBox = false,
      this.innerBarPercentage = 1,
      this.isVertical = false,
      this.simulateCurrentGains = false});

  @override
  Widget build(BuildContext context) {
    bool evoReady = currentXp >= maxXp;
    int totalGains = 50;
    if (simulateCurrentGains && !didWeWorkoutToday) {
      totalGains = overrideGains == 0
          ? ((maxXp / 5).floor()) +
              Provider.of<UserModel>(context, listen: false)
                      .user!
                      .streak
                      .toInt() *
                  10
          : overrideGains;
    }
    return Column(
      mainAxisAlignment:
          isVertical ? MainAxisAlignment.end : MainAxisAlignment.center,
      crossAxisAlignment:
          showInfoBox ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        if (!showInfoBox)
          Consumer<UserModel>(
            builder: (_, user, __) {
              return GestureDetector(
                onTap: didWeWorkoutToday
                    ? () => {
                          showFFDialog(
                              'Why am I not gaining Evo?',
                              "Fitness is a marathon, not a sprint. In order to stay consistent you need to pace yourself. Your figure reflects this and you will not be able to gain any charge from multiple workouts per day. You can still gain Evo at a reduced rate.",
                              context)
                        }
                    : () => {},
                child: Text(
                    simulateCurrentGains
                        ? didWeWorkoutToday
                            ? "$currentXp + ($totalGains) ?"
                            : overrideGains == 0
                                ? "$currentXp + (${(maxXp / 5).floor()} | ${user.user!.streak * 10}🔥)"
                                : "$currentXp + ($overrideGains)"
                        : currentXp.toString(),
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary)),
              );
            },
          ),
        Visibility(
          visible: showInfoBox,
          child: GestureDetector(
            onTap: () {
              context.goNamed('Evolution');
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
                boxShadow: areWeShadowing
                    ? const [
                        BoxShadow(
                            blurRadius: 4,
                            color: Colors.black,
                            offset: Offset(0, 4))
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Align(
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
                  if (simulateCurrentGains)
                    Align(
                      alignment: isVertical
                          ? Alignment.topCenter
                          : Alignment.centerLeft,
                      child: Container(
                        width: isVertical
                            ? barWidth
                            : ((totalGains / maxXp).clamp(0, 1) * barWidth)
                                .clamp(
                                0,
                                barWidth -
                                    (currentXp / maxXp).clamp(0, 1) * barWidth,
                              ),
                        height: isVertical
                            ? (totalGains / maxXp).clamp(0, 1) * barHeight
                            : barHeight,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
