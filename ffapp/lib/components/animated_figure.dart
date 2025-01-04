import 'package:ffapp/components/ff_app_button.dart';
import 'package:ffapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:spine_flutter/spine_flutter.dart';

@immutable
class AnimatedFigure extends StatefulWidget {
  final double height;
  final double width;
  // final int characterNumber;
  // final int level;
  // final SpineWidgetController animationController;

  const AnimatedFigure({
    super.key,
    required this.height,
    required this.width,
    // required this.characterNumber,
    // required this.level,
    // required this.animationController
  });

  @override
  AnimatedFigureState createState() => AnimatedFigureState();
}

class AnimatedFigureState extends State<AnimatedFigure> {
  late SpineWidgetController controller;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    controller = SpineWidgetController(onInitialized: (controller) {
      controller.animationState.setAnimationByName(0, "happy", true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FigureModel>(builder: (context, figure, child) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: OverflowBox(
          minHeight: 100,
          minWidth: 100,
          maxHeight: (widget.height) * ((figure.EVLevel + 1.7) / 2.8),
          maxWidth: (widget.width) * ((figure.EVLevel + 1.7) / 2.8),
          child: SpineWidget.fromAsset(
            "lib/assets/figures/Character_0${int.parse(figure.figure!.figureName.replaceAll(RegExp(r'[^0-9]'), ''))}_lvl${figure.figure!.evLevel + 1}/export/st_${figure.figure!.evLevel + 1}.atlas",
            "lib/assets/figures/Character_0${int.parse(figure.figure!.figureName.replaceAll(RegExp(r'[^0-9]'), ''))}_lvl${figure.figure!.evLevel + 1}/export/st_${figure.figure!.evLevel + 1}.json",
            figure.controller,
            boundsProvider: SkinAndAnimationBounds(animation: "happy"),
            sizedByBounds: true,
          ),
        ),
      );
    });
  }
}
