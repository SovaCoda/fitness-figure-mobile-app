import 'package:flutter/material.dart';

class BackedFigureHolder extends StatelessWidget {
  final String figureUrl;
  final MainAxisAlignment mainAxisAlignment;
  final double height;
  final double width;
  const BackedFigureHolder({
    super.key,
    required this.figureUrl,
    this.height = 150,
    this.width = 50,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
            right: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
          ),
          color: Theme.of(context).colorScheme.primaryFixedDim),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Container(
                width: width / 3,
                height: height,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 3.0,
                    colors: [
                      Theme.of(context).colorScheme.primaryFixedDim,
                      Theme.of(context).colorScheme.onPrimary,
                    ],
                  ),
                )),
          ),
          Column(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              Image.asset(
                "lib/assets/$figureUrl.gif",
                height: width,
                width: height,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
