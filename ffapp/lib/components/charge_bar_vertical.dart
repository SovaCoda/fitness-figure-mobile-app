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
    double internalBarWidth = barWidth - 10;
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: barWidth,
            height: barHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(49, 89, 21, 1),
                    Color.fromRGBO(0, 0, 0, 0)
                  ]),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: internalBarWidth,
                    height: 4,
                    decoration:
                        BoxDecoration(color: fillColor, boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(127, 31, 255, 60),
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                      )
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: internalBarWidth,
                    height: 8,
                    decoration:
                        BoxDecoration(color: fillColor, boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(127, 31, 255, 60),
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                      )
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: internalBarWidth,
                    height: (currentCharge / 100).clamp(0, 1) * barHeight,
                    decoration:
                        BoxDecoration(color: fillColor, boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(127, 31, 255, 60),
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                      )
                    ]),
                  ),
                ),
              ],
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
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: fillColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(127, 31, 255, 60),
                            offset: Offset(0.0, 0.0),
                            blurRadius: 15.0,
                          )
                        ]),
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
