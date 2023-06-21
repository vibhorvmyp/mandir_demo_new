import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularPathAnimation extends StatefulWidget {
  @override
  _CircularPathAnimationState createState() => _CircularPathAnimationState();
}

class _CircularPathAnimationState extends State<CircularPathAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(); // repeat the animation

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            final double angle = _animation.value * 2.0 * math.pi;
            return Transform.translate(
              offset: Offset(
                100.0 * math.cos(angle),
                100.0 * math.sin(angle),
              ),
              child: child!,
            );
          },
          child: Image.asset('assets/pooja_thaali.png')),
    );
  }
}
