import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandir_demo_new/const/constant.dart';

import 'dart:math' as math;

import 'package:mandir_demo_new/controllers/pooja_thaali_controller.dart';

class PoojaThaaliAnimation extends StatelessWidget {
  PoojaThaaliAnimation({super.key});

  final poojaThaaliController = Get.find<PoojaThaaliController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          animation: poojaThaaliController.thaaliAnimation,
          builder: (BuildContext context, Widget? child) {
            final double angle =
                poojaThaaliController.thaaliAnimation.value * 2.0 * math.pi;
            return Transform.translate(
              offset: Offset(
                100.0 * math.cos(angle),
                100.0 * math.sin(angle),
              ),
              child: child!,
            );
          },
          child: Image.asset(Constant.poojaThaaliImgUrl)),
    );
  }
}
