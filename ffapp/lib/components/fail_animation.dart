import 'dart:math';

import 'package:ffapp/icons/fitness_icon.dart';
import 'package:flutter/material.dart';

class AnimatedFitnessIcon extends StatefulWidget {
  const AnimatedFitnessIcon({super.key});

  @override
  State<AnimatedFitnessIcon> createState() => _AnimatedFitnessIconState();
}

class _AnimatedFitnessIconState extends State<AnimatedFitnessIcon> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.15,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.25,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _playCount++;
        if (_playCount < 4) { // Since each complete animation requires forward and reverse
          _controller.reverse();
        }
      } else if (status == AnimationStatus.dismissed && _playCount < 1) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * pi * 2,
            child: const FitnessIcon(
              type: FitnessIconType.fail,
              size: 200,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
