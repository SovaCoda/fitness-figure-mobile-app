import 'package:ffapp/components/clippers/progress_bar_clipper.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progressPercent;
  final double barWidth;
  final Color fillColor;
  final Icon icon;
  final Color gradientColor;

  const ProgressBar({
    super.key,
    required this.progressPercent,
    required this.barWidth,
    required this.fillColor,
    required this.icon,
    this.gradientColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    double internalBarWidth;
    if (barWidth < 200) {
      internalBarWidth = barWidth - 80;
    } else {
      internalBarWidth = barWidth - 130;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipPath(
          clipper: ProgressBarClipper(),
          child: Container(
            width: barWidth,
            height: 40.0,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onError,
                  spreadRadius: 4,
                  blurRadius: 0,
                )
              ],
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  gradientColor,
                  gradientColor,
                  gradientColor,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10),
                    child: Row(
                      children: [
                        Transform.rotate(
                          angle: 3.14 / 2,
                          child: (barWidth < 200) ? null : icon,
                        ),
                        Container(
                          width: internalBarWidth,
                          height: 10.0,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                          child: Container(
                            width: internalBarWidth *
                                (progressPercent.clamp(0, 1)),
                            height: 10,
                            decoration: BoxDecoration(
                                color: fillColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: fillColor,
                                      spreadRadius: 2,
                                      blurRadius: 4)
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Container(
                      width: 60,
                      alignment: Alignment.center,
                      child: Text(
                        "${(progressPercent * 100).toStringAsFixed(0)}%",
                        style: TextStyle(
                          color: fillColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ]),
          ),
        ),
      ],
    );
  }
}
