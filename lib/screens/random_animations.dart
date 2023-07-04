import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mandir_demo_new/const/constant.dart';

class RandomAnimationStack extends StatefulWidget {
  const RandomAnimationStack({super.key});

  @override
  RandomAnimationStackState createState() => RandomAnimationStackState();
}

class RandomAnimationStackState extends State<RandomAnimationStack>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _offsetAnimations = [];

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addRandomAnimation,
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            color: Colors.red.shade900,
            image: DecorationImage(image: AssetImage(Constant.godImgUrl))),
        child: Stack(
          children: _buildAnimationStack(),
        ),
      ),
    );
  }

  void _addRandomAnimation() {
    final random = Random();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final halfScreenHeight = screenHeight / 2;

    for (var i = 0; i < 50; i++) {
      final controller = AnimationController(
        duration: Duration(
            seconds: random.nextInt(7) +
                9), // Random duration between 2 to 6 seconds
        vsync: this,
      );
      final animation = Tween<Offset>(
        begin: Offset(random.nextDouble() * screenWidth,
            -random.nextDouble() * halfScreenHeight),
        end: Offset(random.nextDouble() * screenWidth,
            screenHeight + random.nextDouble() * halfScreenHeight),
      ).animate(controller);

      animation.addListener(() {
        setState(() {});
      });

      _controllers.add(controller);
      _offsetAnimations.add(animation);
      controller.forward();
    }

    Timer(Duration(seconds: 10), () {
      _clearAnimations();
    });
  }

  void _clearAnimations() {
    for (var i = 0; i < _controllers.length; i++) {
      Timer(Duration(seconds: 10 * (i + 1)), () {
        _controllers[i].stop();
        _controllers.removeAt(i);
        _offsetAnimations.removeAt(i);
        setState(() {});
      });
    }
  }

  List<Widget> _buildAnimationStack() {
    List<Widget> stack = [];

    for (var i = 0; i < _offsetAnimations.length; i++) {
      stack.add(
        Positioned(
          left: _offsetAnimations[i].value.dx,
          top: _offsetAnimations[i].value.dy,
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 8.0).animate(
              CurvedAnimation(
                parent: _controllers[i],
                curve: Interval(0.0, 1.0),
              ),
            ),
            child: Container(
              width: 32,
              height: 32,
              child: Image.asset(Constant.flowerImgUrl),
            ),
          ),
        ),
      );
    }

    return stack;
  }
}
