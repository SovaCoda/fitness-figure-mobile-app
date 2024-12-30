import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedCoin extends StatefulWidget {
  final double size;

  const AnimatedCoin({super.key, required this.size});

  @override
  AnimatedCoinState createState() => AnimatedCoinState();
}

class AnimatedCoinState extends State<AnimatedCoin>
    with SingleTickerProviderStateMixin {
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();

    // Create an animation controller that runs for 2 seconds
    // and repeats indefinitely
    _shineController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    // Create a curved animation for a smooth shine effect
    _shineAnimation = Tween<double>(begin: -2.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _shineController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    // Always dispose of the controller when no longer needed
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Original coin SVG
        SvgPicture.asset("lib/assets/art/ffcoin.svg", width: widget.size),

        // Animated shine overlay
        AnimatedBuilder(
          animation: _shineAnimation,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment(_shineAnimation.value, 1.2),
                  end: Alignment(_shineAnimation.value + 1.2, 1.5),
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: SvgPicture.asset("lib/assets/art/ffcoin.svg",
                  width: widget.size,),
            );
          },
        ),
      ],
    );
  }
}
