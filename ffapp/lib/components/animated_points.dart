import 'package:flutter/material.dart';

class FloatingText extends StatefulWidget {
  final String text;
  final Color color;

  const FloatingText({super.key, required this.text, required this.color});
  @override
  FloatingTextState createState() => FloatingTextState();
}

class FloatingTextState extends State<FloatingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller);

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideTransition(
          position: _positionAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              widget.text,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: widget.color),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
