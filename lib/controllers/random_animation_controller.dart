import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RandomAnimationController extends GetxController
    with GetTickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<Offset>> _offsetAnimations = [];

  @override
  void onClose() {
    super.onClose();
    for (var controller in _controllers) {
      controller.dispose();
    }
  }
}
