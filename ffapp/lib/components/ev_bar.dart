import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/icons/fitness_icon.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/providers.dart';
import 'package:flutter/material.dart';
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
  final bool isMaxLevel;
  final bool showIcon;
  final double insetPixels = 4.0;
  final double iconSize;
  final double curvature = 20;
  final double textMargin = 4;

  const EvBar(
      {super.key,
      required this.currentXp,
      required this.maxXp,
      required this.fillColor,
      required this.barHeight,
      required this.barWidth,
      this.showIcon = false,
      this.isMaxLevel = false,
      this.overrideGains = 0,
      this.didWeWorkoutToday = false,
      this.areWeShadowing = false,
      this.showInfoBox = false,
      this.innerBarPercentage = 1,
      this.isVertical = false,
      this.iconSize = 50.0,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        showIcon
            ? FitnessIcon(
                type: FitnessIconType.evo,
                size: iconSize,
              )
            : Container(),
        Column(
          mainAxisAlignment:
              isVertical ? MainAxisAlignment.end : MainAxisAlignment.center,
          crossAxisAlignment: showInfoBox
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
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
                                    true,
                                    context)
                              }
                          : () => {},
                      child: Row(
                        
                        children: [
                        Text(
                          textAlign: TextAlign.left,
                          simulateCurrentGains
                              ? didWeWorkoutToday
                                  ? "$currentXp + ($totalGains) ?"
                                  : overrideGains == 0
                                      ? "$currentXp [+ ${(maxXp / 5).floor()} | ${user.user!.streak * 10}]"
                                      : "$currentXp + ($overrideGains)"
                              : currentXp.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                  fontFamily: "Roboto",
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color:
                                      const Color(0xFF00A7E1)),
                        ),
                        const FitnessIcon(type: FitnessIconType.fire, size: 30)
                      ]));
                },
              ),
            Visibility(
              visible: showInfoBox,
              child: GestureDetector(
                onTap: () {
                  if (!isMaxLevel && evoReady) {
                    Provider.of<HomeIndexProvider>(context, listen: false)
                        .setIndex(5);
                  }
                },
                child: Container(
                    margin: EdgeInsets.all(textMargin),
                    height: barHeight * 1.2,
                    width: barWidth * 0.5,
                    child: Center(
                        child: isMaxLevel
                            ? Text('MAX EVO',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary))
                            : evoReady
                                ? Text('EVO Ready!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary))
                                : Text('$currentXp',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer)))),
              ),
            ),
            Stack(
              alignment:
                  isVertical ? Alignment.topCenter : Alignment.centerLeft,
              children: [
                Container(
                  margin: showIcon
                      ? EdgeInsets.only(bottom: iconSize / 4, left: 4)
                      : null,
                  padding: EdgeInsets.only(
                      top: insetPixels / 2, bottom: insetPixels / 2),
                  width: barWidth,
                  height:
                      barHeight, // if vertical swap the width and height to reorient the bar
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(16, 117, 165, 1),
                        width: 1.85,
                        strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: BorderRadius.circular(curvature),
                    color: const Color.fromRGBO(0, 73, 90, 1),
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
                        alignment: isVertical
                            ? Alignment.topCenter
                            : Alignment.centerLeft,
                        child: Stack(
                          children: [
                            Container(
                              width: isVertical
                                  ? barWidth
                                  : (currentXp / maxXp).clamp(0, 1) * barWidth,
                              height: isVertical
                                  ? (currentXp / maxXp).clamp(0, 1) * barHeight
                                  : barHeight,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color.fromRGBO(0, 91, 123, 1),
                                    Color.fromRGBO(0, 167, 225, 1),
                                    Color.fromRGBO(64, 178, 250, 1),
                                    Color.fromRGBO(0, 167, 225, 1),
                                    Color.fromRGBO(0, 91, 123, 1)
                                  ], stops: [
                                    0,
                                    0.2,
                                    0.4,
                                    0.6,
                                    1
                                  ]),
                                  borderRadius:
                                      BorderRadius.circular(curvature)),
                            ),
                            Container(
                              width: isVertical
                                  ? barWidth
                                  : (currentXp / maxXp).clamp(0, 1) * barWidth,
                              height: isVertical
                                  ? (currentXp / maxXp).clamp(0, 1) * barHeight
                                  : barHeight,
                              decoration: BoxDecoration(
                                  border: const Border(
                                      right: BorderSide(
                                          color:
                                              Color.fromRGBO(51, 157, 195, 1),
                                          width: 1.85,
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside),
                                      top: BorderSide(
                                          color:
                                              Color.fromRGBO(51, 157, 195, 1),
                                          width: 1.85,
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside),
                                      bottom: BorderSide(
                                          color:
                                              Color.fromRGBO(51, 157, 195, 1),
                                          width: 1.85,
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside)),
                                  boxShadow: const [
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.11),
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                        blurStyle: BlurStyle.inner),
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.11),
                                        blurRadius: 0,
                                        spreadRadius: 2,
                                        blurStyle: BlurStyle.inner)
                                  ],
                                  backgroundBlendMode: BlendMode.plus,
                                  gradient: const RadialGradient(colors: [
                                    Color.fromRGBO(119, 196, 255, 0.22),
                                    Color.fromRGBO(5, 45, 70, 0.22)
                                  ], stops: [
                                    0,
                                    0
                                  ]),
                                  borderRadius:
                                      BorderRadius.circular(curvature)),
                            ),
                          ],
                        ),
                      ),
                      // if (simulateCurrentGains)
                      //   Align(
                      //     alignment: isVertical
                      //         ? Alignment.topCenter
                      //         : Alignment.centerLeft,
                      //     child: Container(
                      //       width: isVertical
                      //           ? barWidth
                      //           : ((totalGains / maxXp).clamp(0, 1) * barWidth)
                      //               .clamp(
                      //               0,
                      //               barWidth -
                      //                   (currentXp / maxXp).clamp(0, 1) *
                      //                       barWidth,
                      //             ),
                      //       height: isVertical
                      //           ? (totalGains / maxXp).clamp(0, 1) * barHeight
                      //           : barHeight,
                      //       decoration: BoxDecoration(
                      //         borderRadius: const BorderRadius.only(
                      //             topRight: Radius.circular(10),
                      //             bottomRight: Radius.circular(10)),
                      //         color: Theme.of(context)
                      //             .colorScheme
                      //             .secondaryContainer,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
