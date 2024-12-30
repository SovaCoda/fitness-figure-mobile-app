import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChargeBar extends StatelessWidget {
  final int currentCharge;
  final Color fillColor;
  final double barHeight;
  final double barWidth;
  final int overrideGains;

  final bool isVertical;
  final bool showDashedLines;
  final bool showInfoCircle;
  final bool areWeShadowing;
  final bool simulateCurrentGains;
  final bool didWeWorkoutToday;

  const ChargeBar(
      {super.key,
      required this.currentCharge,
      required this.fillColor,
      required this.barHeight,
      required this.barWidth,
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
                        "Fitness is a marathon, not a sprint. In order to stay consistent you need to pace yourself. Your figure reflects this and you will not be able to gain any charge from multiple workouts per day. You can still gain Evo at a reduced rate.",
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
          children: [
            Visibility(
              visible: showInfoCircle,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.14,
                height: MediaQuery.of(context).size.width * 0.14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$currentCharge%",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.14,
                          height: MediaQuery.of(context).size.width * 0.07,
                          child: OverflowBox(
                            // maxHeight: 150,
                            // maxWidth: 150,
                            child: Transform.rotate(
                              angle: 3.14 / 2,
                              child: Icon(Icons.battery_charging_full_outlined,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: 40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: barWidth,
              height: barHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).colorScheme.primaryFixedDim,
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
                        child: Container(
                          width: isVertical
                              ? barWidth
                              : (currentCharge / 100).clamp(
                                          0, (showDashedLines ? 0.8 : 1)) *
                                      barWidth -
                                  0,
                          height: isVertical
                              ? (currentCharge / 100)
                                      .clamp(0, (showDashedLines ? 0.8 : 1)) *
                                  barHeight
                              : barHeight,
                          decoration: BoxDecoration(
                              color: fillColor,
                              borderRadius: showInfoCircle
                                  ? BorderRadius.circular(0)
                                  : BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary,
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius: 10.0,
                                )
                              ]),
                        ),
                      ),
                      if (simulateCurrentGains && !didWeWorkoutToday)
                        Transform.translate(
                          offset: const Offset(-2, 0),
                          child: Align(
                            alignment: isVertical
                                ? Alignment.topCenter
                                : Alignment.centerLeft,
                            child: Container(
                              width: isVertical
                                  ? barWidth
                                  : (totalGains / 100).clamp(
                                          0, (showDashedLines ? 0.8 : 1)) *
                                      barWidth,
                              height: isVertical
                                  ? (totalGains / 100).clamp(
                                          0, (showDashedLines ? 0.8 : 1)) *
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
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 10.0,
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      if (showDashedLines)
                        Align(
                          alignment: isVertical
                              ? Alignment.topCenter
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            width: isVertical
                                ? barWidth
                                : (currentCharge / 100).clamp(0, 1) *
                                    barWidth *
                                    0.11,
                            height: isVertical
                                ? (currentCharge / 100).clamp(0, 1) *
                                    barHeight *
                                    0.12
                                : barHeight,
                            decoration: BoxDecoration(
                                color: fillColor,
                                borderRadius: showInfoCircle
                                    ? BorderRadius.circular(0)
                                    : BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 10.0,
                                  )
                                ]),
                          ),
                        ),
                      if (showDashedLines)
                        Align(
                          alignment: isVertical
                              ? Alignment.topCenter
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            width: isVertical
                                ? barWidth
                                : (currentCharge / 100).clamp(0, 1) *
                                    barWidth *
                                    0.05,
                            height: isVertical
                                ? (currentCharge / 100).clamp(0, 1) *
                                    barHeight *
                                    0.05
                                : barHeight,
                            decoration: BoxDecoration(
                                color: fillColor,
                                borderRadius: showInfoCircle
                                    ? BorderRadius.circular(0)
                                    : BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 10.0,
                                  )
                                ]),
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
    );
  }
}
