import 'package:ffapp/assets/data/figure_ev_data.dart';
import 'package:ffapp/components/ff_app_button.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:spine_flutter/spine_flutter.dart';

class AnimatedFigure extends StatefulWidget {
  final double height;
  final double width;
  final bool useEquippedFigure;
  final String figureName;
  final int figureLevel;
  final String animation;
  // final int characterNumber;
  // final int level;
  // final SpineWidgetController animationController;

  AnimatedFigure({
    super.key,
    required this.height,
    required this.width,
    this.useEquippedFigure = true,
    this.figureLevel = 0,
    this.figureName = "robot1",
    this.animation = "idle",
  });

  @override
  AnimatedFigureState createState() => AnimatedFigureState();
}

class AnimatedFigureState extends State<AnimatedFigure> {
  late SpineWidgetController controller;
  late int level;
  @override
  void initState() {
    super.initState();

    controller = SpineWidgetController(onInitialized: (controller) {
      controller.animationState.setAnimationByName(0, "idle", true);
    });

    // resetAnimations();
  }

  // void resetAnimations() async {
  //   Future.delayed(const Duration(milliseconds: 5000), () {
  //     setState(() {
  //       level = 2;
  //     });
  //   });
  // }

  @override
  void didUpdateWidget(covariant AnimatedFigure oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.figureName != widget.figureName) ||
        (oldWidget.figureLevel != widget.figureLevel)) {
      controller = SpineWidgetController(onInitialized: (controller) {
        controller.animationState.setAnimationByName(0, "idle", true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FigureModel>(builder: (context, figure, child) {
      String figureCode = widget.useEquippedFigure
          ? "${int.parse(figure.figure!.figureName.replaceAll(RegExp(r'[^0-9]'), ''))}${figure.figure!.evLevel + 1}"
          : "${int.parse(widget.figureName.replaceAll(RegExp(r'[^0-9]'), ''))}${widget.figureLevel + 1}";
      double figureSizeMultiplier = figureSizeMultipliers[figureCode]!;
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: OverflowBox(
          minHeight: 50,
          minWidth: 50,
          maxHeight: (widget.height) * (figureSizeMultiplier),
          maxWidth: (widget.width) * (figureSizeMultiplier),
          child: widget.useEquippedFigure
              ? SpineWidget.fromAsset(
                  "lib/assets/figures/Character_0${widget.useEquippedFigure ? int.parse(figure.figure!.figureName.replaceAll(RegExp(r'[^0-9]'), '')) : int.parse(widget.figureName.replaceAll(RegExp(r'[^0-9]'), ''))}_lvl${widget.useEquippedFigure ? figure.figure!.evLevel + 1 : widget.figureLevel + 1}/export/st_${widget.useEquippedFigure ? figure.figure!.evLevel + 1 : widget.figureLevel + 1}.atlas",
                  "lib/assets/figures/Character_0${widget.useEquippedFigure ? int.parse(figure.figure!.figureName.replaceAll(RegExp(r'[^0-9]'), '')) : int.parse(widget.figureName.replaceAll(RegExp(r'[^0-9]'), ''))}_lvl${widget.useEquippedFigure ? figure.figure!.evLevel + 1 : widget.figureLevel + 1}/export/st_${widget.useEquippedFigure ? figure.figure!.evLevel + 1 : widget.figureLevel + 1}.json",
                  widget.useEquippedFigure ? figure.controller : controller,
                  boundsProvider: SkinAndAnimationBounds(animation: "happy"),
                  sizedByBounds: true,
                )
              : Consumer<FigureSkeletonProvider>(
                  builder: (context, figureSkeletons, child) {
                    if (figureSkeletons.atlases[figureCode] != null) {
                      return SpineWidget.fromDrawable(
                          SkeletonDrawable(figureSkeletons.atlases[figureCode]!,
                              figureSkeletons.skeletons[figureCode]!, false),
                          controller);
                    }
                    return Text("data");
                  },
                ),
        ),
      );
    });
  }
}
