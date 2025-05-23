import 'dart:ui';

import 'package:flutter/material.dart';

class GradientedContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final bool showTopRectangle;
  final String? title;
  final String? description;
  final bool isScrollable;

  const GradientedContainer(
      {super.key,
      this.child,
      this.width,
      this.height,
      this.margin = EdgeInsets.zero,
      this.padding = EdgeInsets.zero,
      this.showTopRectangle = false,
      this.title,
      this.description,
      this.isScrollable = false,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.9, sigmaY: 15.9),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F61E9).withOpacity(0.25 * 0.53),
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(255, 255, 255, 0.3),
                        Color(0xFF00CA98),
                      ],
                      stops: [0.0, 0.681666],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.27),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 31.8,
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final topPadding =
                          showTopRectangle ? constraints.maxHeight * 0.22 : 0;
                      final content = Padding(
                        padding: EdgeInsets.only(
                          top: topPadding.toDouble() + 8,
                          bottom: 8,
                          left: 8,
                          right: 8,
                        ),
                        child: Column(
                          children: [
                            if (description != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16.0,
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                child: Text(
                                  description!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            if (child != null) child!,
                          ],
                        ),
                      );

                      return isScrollable
                          ? SingleChildScrollView(child: content)
                          : content;
                    },
                  ),
                ),
              ),
            ),
            if (showTopRectangle)
              Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  widthFactor: 1.0,
                  heightFactor: 0.22,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF5FC3CC).withOpacity(0.12),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        title ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class GradientedContainerWidget extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final bool showTopRectangle;
  final Widget? title;
  final Widget? description;
  final bool isScrollable;

  const GradientedContainerWidget(
      {super.key,
      this.child,
      this.width,
      this.height,
      this.margin = EdgeInsets.zero,
      this.padding = EdgeInsets.zero,
      this.showTopRectangle = false,
      this.title,
      this.description,
      this.isScrollable = false,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.9, sigmaY: 15.9),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F61E9).withOpacity(0.25 * 0.53),
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(255, 255, 255, 0.3),
                        Color(0xFF00CA98),
                      ],
                      stops: [0.0, 0.681666],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.27),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 31.8,
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final topPadding =
                          showTopRectangle ? constraints.maxHeight * 0.55 : 0;
                      final content = Padding(
                        padding: EdgeInsets.only(
                          top: topPadding.toDouble() + 8,
                          bottom: 8,
                          left: 8,
                          right: 8,
                        ),
                        child: Column(
                          children: [
                            if (description != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16.0,
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                child: description
                              ),
                            if (child != null) child!,
                          ],
                        ),
                      );

                      return isScrollable
                          ? SingleChildScrollView(child: content)
                          : content;
                    },
                  ),
                ),
              ),
            ),
            if (showTopRectangle)
              Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  widthFactor: 1.0,
                  heightFactor: 0.55,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF5FC3CC).withOpacity(0.12),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                    ),
                    child: Center(
                      child: title
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
