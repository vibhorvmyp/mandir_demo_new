import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:math' as math;

import 'package:mandir_demo_new/const/constant.dart';

class SwingingBellController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> swingAnimation;

  final double _swingAngle = math.pi / 6;

  final player = AudioPlayer();

  void playBellSound() async {
    await player.play(UrlSource(Constant.bellAudioUrl));
  }

  void handleTap() {
    playBellSound();
    if (animationController.isCompleted) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  @override
  void onInit() {
    super.onInit();
    playBellSound();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    swingAnimation = Tween<double>(
      begin: -_swingAngle,
      end: _swingAngle,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    animationController.forward();
  }

  @override
  void onClose() {
    super.onClose();
    animationController.dispose();
    player.dispose();
  }
}
