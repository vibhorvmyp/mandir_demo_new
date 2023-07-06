// import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandir_demo_new/animations/swinging_bell_animation.dart';
import 'package:mandir_demo_new/const/constant.dart';
import 'package:mandir_demo_new/controllers/home_controller.dart';
import 'package:mandir_demo_new/controllers/pooja_thaali_controller.dart';
import 'package:mandir_demo_new/controllers/swinging_bell_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final homeController = Get.put(HomeController());
  final swingingBellController = Get.put(SwingingBellController());
  final poojaThaaliController = Get.put(PoojaThaaliController());

  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _offsetAnimations = [];

  void _addRandomAnimation() {
    final random = Random();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final halfScreenHeight = screenHeight / 2;

    for (var i = 0; i < 25; i++) {
      final controller = AnimationController(
        duration: Duration(
          seconds: random.nextInt(7) + 7,
        ),
        vsync: this,
      );
      final horizontalOffset = random.nextDouble() * screenWidth;
      final verticalOffset = -random.nextDouble() * halfScreenHeight + 300;
      final animation = Tween<Offset>(
        begin: Offset(horizontalOffset, verticalOffset),
        end: Offset(
          horizontalOffset +
              (random.nextDouble() - 0.5) *
                  screenWidth *
                  4, //horizontal offset to create diagonal movement
          screenHeight + random.nextDouble() * halfScreenHeight,
        ),
      ).animate(controller);

      animation.addListener(() {
        setState(() {});
      });

      _controllers.add(controller);
      _offsetAnimations.add(animation);
      controller.forward();
    }

    // Timer(const Duration(seconds: 10), () {
    //   _clearAnimations();

    //   print('clear function called');
    // });
  }

  // void _clearAnimations() {
  //   for (var i = 0; i < _controllers.length; i++) {
  //     Timer(Duration(seconds: 10 * (i + 1)), () {
  //       // _controllers[i].stop();
  //       _controllers.removeAt(i);
  //       print('controller removed = ${_controllers[i]}');

  //       _offsetAnimations.removeAt(i);

  //       setState(() {});
  //     });
  //   }
  // }

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
                curve: const Interval(0.0, 1.0),
              ),
            ),
            child: SizedBox(
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

  @override
  void initState() {
    super.initState();
    // moveTheBells();
  }

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
      backgroundColor: const Color(0xFF281119),
      body: Stack(
        children: [
          Positioned(
            top: 175,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Color(0xFF281119), width: 5))),
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                Constant.godImgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Stack(
              children: _buildAnimationStack(),
              // child: CustomPaint(
              //   foregroundPainter: FallingFlowersPainter(
              //       homeController.flower, homeController.flowerNotifier),
              // ),
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
                _addRandomAnimation();
                // if (homeController.ticker.isTicking) {
                //   // homeController.setFlower();
                //   homeController.ticker.stop();
                //   setState(() {});
                // } else {
                //   homeController.ticker.start();
                //   setState(() {});
                // }
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
            top: 130,
            left: 280,
            child: SwingingBellAnimation(),
          ),
          Positioned(
            top: 130,
            right: 280,
            child: SwingingBellAnimation(),
          ),

          Positioned(
              top: 0,
              child: SizedBox(
                  // color: Colors.amber,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(Constant.mandirDesign2))),
        ],
      ),
    );
  }
}




  // void _addRandomAnimation() {
  //   final random = Random();
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final screenHeight = MediaQuery.of(context).size.height;
  //   final halfScreenHeight = screenHeight / 2;

  //   for (var i = 0; i < 50; i++) {
  //     final controller = AnimationController(
  //       duration: Duration(
  //           seconds: random.nextInt(7) +
  //               9), // Random duration between 2 to 6 seconds
  //       vsync: this,
  //     );
  //     final animation = Tween<Offset>(
  //       begin: Offset(random.nextDouble() * screenWidth,
  //           -random.nextDouble() * halfScreenHeight),
  //       end: Offset(random.nextDouble() * screenWidth,
  //           screenHeight + random.nextDouble() * halfScreenHeight),
  //     ).animate(controller);

  //     animation.addListener(() {
  //       setState(() {});
  //     });

  //     _controllers.add(controller);
  //     _offsetAnimations.add(animation);
  //     controller.forward();
  //   }

  //   Timer(Duration(seconds: 10), () {
  //     _clearAnimations();
  //   });
  // }

  // void _clearAnimations() {
  //   for (var i = 0; i < _controllers.length; i++) {
  //     Timer(Duration(seconds: 10 * (i + 1)), () {
  //       _controllers[i].stop();
  //       _controllers.removeAt(i);
  //       _offsetAnimations.removeAt(i);
  //       setState(() {});
  //     });
  //   }
  // }
