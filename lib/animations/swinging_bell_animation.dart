import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mandir_demo_new/const/constant.dart';

import 'dart:math' as math;

import 'package:mandir_demo_new/controllers/swinging_bell_controller.dart';

class SwingingBellAnimation extends StatelessWidget {
  SwingingBellAnimation({super.key});

  final swingingBellController = Get.find<SwingingBellController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: swingingBellController.handleTap,
      child: AnimatedBuilder(
        animation: swingingBellController.animationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: swingingBellController.swingAnimation.value *
                math.sin(
                    swingingBellController.animationController.value * math.pi),
            child: child,
          );
        },
        child: Image.asset(
          Constant.bellImgUrl,
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
