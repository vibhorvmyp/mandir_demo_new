import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:math' as math;

class PoojaThaaliController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> thaaliAnimation;

  Offset initialPosition = const Offset(
    0,
    -200,
  );

  Offset currentPosition = Offset.zero;

  // Offset currentPosition = const Offset(
  //   0,
  //   -200,
  // );

  void resetDraggablePosition() {}

  //Pooja Thaali
  void startPoojaThaaliAnimation() {
    if (controller.isAnimating) {
      controller.reset();
      controller.stop();

      initialPosition = const Offset(
        0,
        -200,
      );

      currentPosition = Offset.zero;

      // currentPosition = const Offset(
      //   0,
      //   -200,
      // );
    } else if (!controller.isAnimating) {
      controller.reset();
      controller.repeat();
      // Stop the animation after 5 seconds
      Future.delayed(const Duration(seconds: 11), resetPoojaThaaliAnimation);
    }
  }

  void resetPoojaThaaliAnimation() {
    controller.reset();
    controller.stop();

    initialPosition = const Offset(
      0,
      -200,
    );

    currentPosition = Offset.zero;
  }

  Offset calculateCircularPosition(double animationValue) {
    const double radius = 100.0;
    final double angle = animationValue * 6.5 * math.pi;
    final double x = radius * math.cos(angle);
    final double y = radius * math.sin(angle);
    return initialPosition.translate(x, y);
  }

  @override
  void onInit() {
    super.onInit();

    //Pooja Thaali Animation
    controller = AnimationController(
      duration: const Duration(seconds: 70),
      vsync: this,
    );

    thaaliAnimation = Tween(begin: 0.0, end: 2 * math.pi).animate(controller);

    thaaliAnimation.addListener(() {
      // setState(() {
      currentPosition = calculateCircularPosition(thaaliAnimation.value);
      // });
    });
  }

  @override
  void onClose() {
    super.onClose();
    controller.dispose();
  }
}
