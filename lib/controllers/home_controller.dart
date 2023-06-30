import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mandir_demo_new/const/constant.dart';

import 'dart:ui' as ui;
// import 'dart:math' as math;

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HomeController() {
    ticker = Ticker(tick);
  }

  late Ticker ticker;

  final flowerNotifier = ValueNotifier(Duration.zero);

  ui.Image? flower;

  Offset draggablePosition = const Offset(0, 0);
  Offset initialPosition = const Offset(0, 0);

  final audioPlayer = AudioPlayer();

  bool isPlaying = false;

  // RxBool startingFlowersFlag = false.obs;

  // late AnimationController _controller;
  // late Animation<double> thaaliAnimation;
  // final Offset _initialPosition = const Offset(
  //   -30,
  //   -200,
  // );
  // Offset currentPosition = Offset.zero;

  final String audioUrl = Constant.aartiAudioUrl;

  void playPauseBgAartiAudio() async {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(audioUrl));
    }
  }

  tick(Duration d) => flowerNotifier.value = d;

  setFlower(ui.Image image) {
    // setState(() {
    flower = image;
    // });

    log(flower.toString());
  }

  //Pooja Thaali
  // void startPoojaThaaliAnimation() {
  //   if (_controller.isAnimating) {
  //     _controller.stop();
  //   }
  //   _controller.reset();
  //   _controller.repeat();
  // }

  // Offset calculateCircularPosition(double animationValue) {
  //   const double radius = 100.0;
  //   final double angle = animationValue * 6.5 * math.pi;
  //   final double x = radius * math.cos(angle);
  //   final double y = radius * math.sin(angle);
  //   return _initialPosition.translate(x, y);
  // }

  void resetDraggablePosition() {}

  @override
  void onInit() {
    super.onInit();

    ticker.start();

    ticker = Ticker(tick);

    rootBundle
        .load('assets/flower_2.png')
        .then((data) => decodeImageFromList(data.buffer.asUint8List()))
        .then(setFlower);

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        isPlaying = true;
      } else if (state == PlayerState.paused || state == PlayerState.stopped) {
        isPlaying = false;
      }
    });

    //Pooja Thaali Animation
    // _controller = AnimationController(
    //   duration: const Duration(seconds: 10),
    //   vsync: this,
    // );

    // thaaliAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    // thaaliAnimation.addListener(() {
    //   // setState(() {
    //   currentPosition = calculateCircularPosition(thaaliAnimation.value);
    //   // });
    // });
  }

  @override
  void onClose() {
    super.onClose();
    audioPlayer.release();
    audioPlayer.dispose();
  }
}
