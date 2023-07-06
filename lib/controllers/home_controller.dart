// import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mandir_demo_new/const/constant.dart';

// import 'dart:ui' as ui;
// import 'dart:math' as math;

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // HomeController() {
  //   ticker = Ticker(tick);
  // }

  // late Ticker ticker;

  // final flowerNotifier = ValueNotifier(Duration.zero);

  // ui.Image? flower;

  Offset draggablePosition = const Offset(0, 0);
  Offset initialPosition = const Offset(0, 0);

  final audioPlayer = AudioPlayer();

  bool isPlaying = false;

  final String audioUrl = Constant.aartiAudioUrl;

  void playPauseBgAartiAudio() async {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(audioUrl));
    }
  }

  // tick(Duration d) => flowerNotifier.value = d;

  // setFlower(ui.Image image) {
  //   // setState(() {
  //   flower = image;
  //   // });

  //   log(flower.toString());
  // }

  void resetDraggablePosition() {}

  @override
  void onInit() {
    super.onInit();

    // ticker.start();

    // ticker = Ticker(tick);

    // rootBundle
    //     .load('assets/flower_2.png')
    //     .then((data) => decodeImageFromList(data.buffer.asUint8List()))
    //     .then(setFlower);

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        isPlaying = true;
      } else if (state == PlayerState.paused || state == PlayerState.stopped) {
        isPlaying = false;
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    audioPlayer.release();
    audioPlayer.dispose();
  }
}
