import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mandir_demo_new/const/constant.dart';

class RandomAnimationStack extends StatefulWidget {
  @override
  _RandomAnimationStackState createState() => _RandomAnimationStackState();
}

class _RandomAnimationStackState extends State<RandomAnimationStack>
    with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<Offset>> _offsetAnimations = [];

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

    for (var i = 0; i < 45; i++) {
      final controller = AnimationController(
        duration: const Duration(seconds: 4),
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

  // void _clearAnimations() {
  //   for (var controller in _controllers) {
  //     controller.stop();
  //   }
  //   _controllers.clear();
  //   _offsetAnimations.clear();
  //   // setState(() {});
  // }

  List<Widget> _buildAnimationStack() {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final halfScreenHeight = MediaQuery.of(context).size.height / 2;

    List<Widget> stack = [];
    for (var i = 0; i < _offsetAnimations.length; i++) {
      stack.add(
        Positioned(
          left: _offsetAnimations[i].value.dx,
          top: _offsetAnimations[i].value.dy,
          child: Image.asset(Constant.flowerImgUrl),
          // child: Icon(
          //   Icons.star,
          //   size: 50,
          //   color: Colors.yellow,
          // ),
        ),
      );
    }
    return stack;
  }
}
