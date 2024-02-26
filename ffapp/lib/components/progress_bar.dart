import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {

  final double progressPercent;
  final double barWidth;
  final Color fillColor;

  const ProgressBar({
    super.key,
    required this.progressPercent,
    required this.barWidth,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Container(
            width: barWidth,
            height: 40.0,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: fillColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  spreadRadius: .1,
                  blurRadius: 1
                )]
            ),
            child: Container(
              width: barWidth - 10,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: Row(
                  children: [
                    SizedBox(width: 20),

                    Container(
                      width: barWidth - 90,
                      height: 10.0,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                      child: Container(
                        width: (barWidth - 90) * (progressPercent.clamp(0, 1)),
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: fillColor,
                          boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            spreadRadius: .1,
                            blurRadius: .5
                          )]
                        ),
                      ),
                    ),

                    SizedBox(width: 10),

                    Text(
                      "${(progressPercent * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        color: fillColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]
                ),
            ),
          ),
      ],);
  }
}