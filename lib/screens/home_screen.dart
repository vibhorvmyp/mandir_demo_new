import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandir_demo_new/animations/swinging_bell_animation.dart';
import 'package:mandir_demo_new/const/constant.dart';
import 'package:mandir_demo_new/controllers/home_controller.dart';
import 'package:mandir_demo_new/controllers/pooja_thaali_controller.dart';
import 'package:mandir_demo_new/controllers/swinging_bell_controller.dart';

import 'package:mandir_demo_new/painter/flower.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.put(HomeController());
  final swingingBellController = Get.put(SwingingBellController());
  final poojaThaaliController = Get.put(PoojaThaaliController());

  @override
  void initState() {
    super.initState();
    // moveTheBells();
  }

  // moveTheBells() {
  //   Future.delayed(Duration(seconds: 1));
  //   swingingBellController.animationController.forward();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Constant.godImgUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
              child: CustomPaint(
                foregroundPainter: FallingFlowersPainter(
                    homeController.flower, homeController.flowerNotifier),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: Draggable(
              feedback: SizedBox(
                width: 180,
                height: 180,
                child: Image.asset(Constant.poojaThaaliImgUrl),
              ),
              onDragStarted: () {
                homeController.initialPosition = Offset(
                  MediaQuery.of(context).size.width / 2 - 50,
                  MediaQuery.of(context).size.height - 100,
                );
              },
              onDragEnd: (_) {
                poojaThaaliController.resetDraggablePosition();
              },
              onDraggableCanceled: (_, __) {
                poojaThaaliController.resetDraggablePosition();
              },
              childWhenDragging: Container(),
              onDragCompleted: () {
                poojaThaaliController.resetDraggablePosition();
              },
              child: AnimatedBuilder(
                animation: poojaThaaliController.thaaliAnimation,
                builder: (BuildContext context, Widget? child) {
                  return Transform.translate(
                    offset: poojaThaaliController.currentPosition,
                    child: child,
                  );
                },
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: Image.asset(Constant.poojaThaaliImgUrl),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 200,
            left: 16,
            child: GestureDetector(
              onTap: () {
                if (poojaThaaliController.controller.isAnimating) {}
                poojaThaaliController.startPoojaThaaliAnimation();
              },
              child: Container(
                width: 55,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: const Color(0xFFEB0C2E),
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.brown)
                    // color: Colors.amber,
                    ),
                child: const Icon(
                  Icons.party_mode_sharp,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 120,
            left: 16,
            child: GestureDetector(
              onTap: () {
                if (homeController.ticker.isTicking) {
                  // homeController.setFlower();
                  homeController.ticker.stop();
                  setState(() {});
                } else {
                  homeController.ticker.start();
                  setState(() {});
                }
              },
              child: Container(
                  width: 52,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.brown.shade400.withOpacity(0.9),
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Colors.brown)),
                  child: Image.asset(Constant.flowerImgUrl)),
            ),
          ),

          Positioned(
            bottom: 120,
            right: 16,
            child: GestureDetector(
              onTap: () {
                homeController.playPauseBgAartiAudio();
              },
              child: Container(
                width: 55,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: const Color(0xFFEB0C2E),
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.brown)),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),

          // // Swinging bell
          Positioned(
            top: 100,
            left: 250,
            child: SwingingBellAnimation(),
          ),
          Positioned(
            top: 100,
            right: 250,
            child: SwingingBellAnimation(),
          ),
        ],
      ),
    );
  }
}
