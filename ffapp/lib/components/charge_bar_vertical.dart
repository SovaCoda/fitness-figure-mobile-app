import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChargeBarVertical extends StatelessWidget {
  final int currentCharge;
  final Color fillColor;
  final double barHeight;
  final double barWidth;

  const ChargeBarVertical(
      {super.key,
      required this.currentCharge,
      required this.fillColor,
      required this.barHeight,
      required this.barWidth});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: barWidth,
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
              alignment: Alignment.bottomLeft,
              child: Container(
                width: barWidth,
                height: (currentCharge / 100).clamp(0, 1) * barHeight,
                decoration: BoxDecoration(color: fillColor, boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      spreadRadius: .1,
                      blurRadius: 1)
                ]),
              ),
            ),
          ),
        ],
      ),
      Transform.translate(
        offset: Offset(0, -5),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            width: barWidth,
            height: barWidth,
            margin: EdgeInsets.only(bottom: 27),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              shape: BoxShape.rectangle,
            ),
            child: OverflowBox(
                maxHeight: 150,
                maxWidth: 150,
                child: Container(
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: fillColor),
                    height: 75,
                    width: 75,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(0, 10),
                            child: Text(
                              "$currentCharge%",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                          Transform.rotate(
                            angle: 3.14 / 2,
                            child: const Icon(
                                Icons.battery_charging_full_outlined,
                                color: Colors.black,
                                size: 40),
                          ),
                        ],
                      ),
                    ))),
          ),
        ),
      ),
    ]);
  }
}
