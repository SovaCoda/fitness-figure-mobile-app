import 'package:flutter/material.dart';

class ResearchProgressBar extends StatelessWidget {
    final String text;
    final VoidCallback onPressed;

    const ResearchProgressBar({super.key, required this.text, required this.onPressed});
  


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 176.31,
          height: 39.09,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 176.19,
                  height: 39.09,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF5F41B9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.39),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 176.31,
                  height: 39.09,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF2A1D53),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1.06,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: Color(0xFF733FBC),
                      ),
                      borderRadius: BorderRadius.circular(6.39),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0.08,
                top: 0,
                child: SizedBox(
                  width: 176.19,
                  height: 39.09,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 176.19,
                          height: 39.09,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF1B2F6F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.39),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -0,
                        top: 0,
                        child: Container(
                          width: 176.10,
                          height: 39.09,
                          decoration: ShapeDecoration(
                            gradient: const RadialGradient(
                              center: Alignment(-0.02, -0.19),
                              radius: 1.25,
                              colors: [Color(0xFFDD57FF), Color(0xFF732EC1)],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.39),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 176.31,
                  height: 39.09,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1.06,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFCDA9FF),
                      ),
                      borderRadius: BorderRadius.circular(6.39),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(6.39),
                child: Center(
                  child: Text(text, style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white)),
                ),
              ),
            ),
          ),
            ],
          ),
        ),
      ],
    );
  }
}
