import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/icons/fitness_icon.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChargeBar extends StatelessWidget {
  final int currentCharge;
  final Color fillColor;
  final double barHeight;
  final double barWidth;
  final int overrideGains;
  final double curvature = 20.0;
  final double insetPixels = 4.0;
  final double iconSize = 50.0;
  final double textMargin = 4.0;

  final bool isVertical;
  final bool showDashedLines;
  final bool showInfoCircle;
  final bool areWeShadowing;
  final bool simulateCurrentGains;
  final bool didWeWorkoutToday;
  final bool showIcon;

  const ChargeBar(
      {super.key,
      required this.currentCharge,
      required this.fillColor,
      required this.barHeight,
      required this.barWidth,
      this.showIcon = false,
      this.didWeWorkoutToday = false,
      this.areWeShadowing = false,
      this.isVertical = false,
      this.showDashedLines = false,
      this.showInfoCircle = false,
      this.overrideGains = 0,
      this.simulateCurrentGains = false});

  @override
  Widget build(BuildContext context) {
    int totalGains = 0;
    if (simulateCurrentGains) {
      totalGains = overrideGains == 0
          ? Provider.of<UserModel>(context, listen: false).baseGain +
              (0.25 *
                      Provider.of<UserModel>(context, listen: false)
                          .user!
                          .streak
                          .toInt())
                  .ceil()
          : overrideGains;
    }
    return Column(
      children: [
        if (!showInfoCircle)
          Consumer<UserModel>(
            builder: (_, user, __) {
              return GestureDetector(
                onTap: didWeWorkoutToday
                    ? () => showFFDialog(
                        "Why am I not gaining Charge?",
                        "Fitness is a marathon, not a sprint. In order to stay consistent you need to pace yourself. Your figure reflects this and will not be able to gain any charge from multiple workouts per day. You can still gain Evo at a reduced rate.",
                        false,
                        context)
                    : () => {},
                child: Text(
                    simulateCurrentGains
                        ? overrideGains == 0
                            ? didWeWorkoutToday
                                ? "$currentCharge% + [0%] ?"
                                : "$currentCharge% + [${user.baseGain}% | ${(user.user!.streak.toInt() * 0.25).ceil()}%🔥]"
                            : "$currentCharge% + [$overrideGains%]"
                        : "$currentCharge%",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
              );
            },
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            showIcon
                ? FitnessIcon(type: FitnessIconType.charge, size: iconSize)
                : Container(),
            Column(
              children: [
                Visibility(
                  visible: showInfoCircle,
                  child: Container(
                      margin: EdgeInsets.all(textMargin),
                      height: barHeight,
                      width: barWidth * 0.5,
                      child: Center(
                          child: Text('$currentCharge%',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      color:
                                          Color.fromRGBO(255, 158, 69, 1))))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: showIcon
                          ? EdgeInsets.only(bottom: iconSize / 4, left: 4)
                          : null,
                      padding: EdgeInsets.only(
                          top: insetPixels / 2, bottom: insetPixels / 2),
                      width: barWidth,
                      height: barHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(curvature),
                        color: const Color.fromRGBO(87, 47, 34, 1),
                        border: Border.all(
                            color: const Color.fromRGBO(126, 66, 24, 1),
                            width: 1.85,
                            strokeAlign: BorderSide.strokeAlignOutside),
                        boxShadow: areWeShadowing
                            ? const [
                                BoxShadow(
                                    blurRadius: 4,
                                    color: Colors.black,
                                    offset: Offset(0, 4))
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: isVertical
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                          : (currentCharge / 100).clamp(0, 1) *
                                                  barWidth -
                                              0,
                                      height: isVertical
                                          ? (currentCharge / 100).clamp(0, 1) *
                                              barHeight
                                          : barHeight - insetPixels,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [
                                          Color.fromRGBO(175, 72, 0, 1),
                                          Color.fromRGBO(217, 106, 24, 1),
                                          Color.fromRGBO(241, 149, 44, 1),
                                          Color.fromRGBO(217, 106, 24, 1),
                                          Color.fromRGBO(175, 72, 0, 1)
                                        ], stops: [
                                          0,
                                          0.2,
                                          0.4,
                                          0.6,
                                          1
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(curvature),
                                      ),
                                    ),
                                    Container(
                                      width: isVertical
                                          ? barWidth
                                          : (currentCharge / 100).clamp(0, 1) *
                                                  barWidth -
                                              0,
                                      height: isVertical
                                          ? (currentCharge / 100).clamp(0, 1) *
                                              barHeight
                                          : barHeight - insetPixels,
                                      decoration: BoxDecoration(
                                          border: const Border(
                                              right: BorderSide(
                                                  color: Color.fromRGBO(
                                                      241, 149, 44, 1),
                                                  width: 1.85,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignOutside),
                                              top: BorderSide(
                                                  color: Color.fromRGBO(
                                                      241, 149, 44, 1),
                                                  width: 1.85,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignOutside),
                                              bottom: BorderSide(
                                                  color: Color.fromRGBO(
                                                      241, 149, 44, 1),
                                                  width: 1.85,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignOutside)),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.11),
                                                blurRadius: 3,
                                                spreadRadius: 1,
                                                blurStyle: BlurStyle.inner),
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.11),
                                                blurRadius: 0,
                                                spreadRadius: 2,
                                                blurStyle: BlurStyle.inner)
                                          ],
                                          backgroundBlendMode: BlendMode.plus,
                                          gradient: const RadialGradient(colors: [
                                            Color.fromRGBO(217, 238, 79, 0.22),
                                            Color.fromRGBO(47, 35, 27, 0.0858)
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
                              if (simulateCurrentGains && !didWeWorkoutToday)
                                Transform.translate(
                                  offset: Offset(-2, 0),
                                  child: Align(
                                    alignment: isVertical
                                        ? Alignment.topCenter
                                        : Alignment.centerLeft,
                                    child: Container(
                                      width: isVertical
                                          ? barWidth
                                          : (totalGains / 100).clamp(0, 1) *
                                              barWidth,
                                      height: isVertical
                                          ? (totalGains / 100).clamp(0, 1) *
                                              barHeight
                                          : barHeight,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              offset: Offset(0.0, 0.0),
                                              blurRadius: 10.0,
                                            )
                                          ]),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
