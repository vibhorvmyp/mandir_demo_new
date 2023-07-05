import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mandir_demo_new/const/constant.dart';

class RandomAnimationStack extends StatefulWidget {
  const RandomAnimationStack({super.key});

  @override
  RandomAnimationStackState createState() => RandomAnimationStackState();
}

class RandomAnimationStackState extends State<RandomAnimationStack>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _offsetAnimations = [];

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

    for (var i = 0; i < 35; i++) {
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
                  4, // Add random horizontal offset to create diagonal movement
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
                curve: Interval(0.0, 1.0), //maybe can put random values here
              ),
            ),
            child: Container(
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
}





// void _addRandomAnimation() {
//     final random = Random();
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final halfScreenHeight = screenHeight / 2;

//     //Right to left flowers
//     for (var i = 0; i < 5; i++) {
//       final controller = AnimationController(
//         duration: Duration(seconds: random.nextInt(6) + 12),
//         vsync: this,
//       );
//       // final delay = Duration(milliseconds: random.nextInt(500));

//       final animation = Tween<Offset>(
//         begin: Offset(
//             screenWidth + 32.0, random.nextDouble() * halfScreenHeight - 400),
//         end: Offset(
//             -32.0, screenHeight + random.nextDouble() * halfScreenHeight),
//       ).animate(controller);

//       animation.addListener(() {
//         setState(() {});
//       });

//       _controllers.add(controller);
//       _offsetAnimations.add(animation);
//       controller.forward();
//     }

//     //Right to left flowers
//     for (var i = 0; i < 5; i++) {
//       final controller = AnimationController(
//         duration: Duration(seconds: random.nextInt(6) + 12),
//         vsync: this,
//       );
//       // final delay = Duration(milliseconds: random.nextInt(500));

//       final animation = Tween<Offset>(
//         begin: Offset(
//             screenWidth + 32.0, random.nextDouble() * halfScreenHeight - 400),
//         end: Offset(
//             -32.0, screenHeight + random.nextDouble() * halfScreenHeight),
//       ).animate(controller);

//       animation.addListener(() {
//         setState(() {});
//       });

//       _controllers.add(controller);
//       _offsetAnimations.add(animation);
//       controller.forward();
//     }

//     //Left to right flowers
//     for (var i = 0; i < 5; i++) {
//       final controller = AnimationController(
//         duration: Duration(seconds: random.nextInt(6) + 12),
//         vsync: this,
//       );

//       final animation = Tween<Offset>(
//         begin: Offset(-32.0, random.nextDouble() * halfScreenHeight - 400),
//         end: Offset(screenWidth + 32.0,
//             screenHeight + random.nextDouble() * halfScreenHeight),
//       ).animate(controller);

//       animation.addListener(() {
//         setState(() {});
//       });

//       _controllers.add(controller);
//       _offsetAnimations.add(animation);
//       controller.forward();
//     }

//     //Top to bottom flowers
//     for (var i = 0; i < 20; i++) {
//       final controller = AnimationController(
//         duration: Duration(seconds: random.nextInt(7) + 9),
//         vsync: this,
//       );
//       final animation = Tween<Offset>(
//         begin: Offset(random.nextDouble() * screenWidth,
//             -random.nextDouble() * halfScreenHeight),
//         end: Offset(random.nextDouble() * screenWidth,
//             screenHeight + random.nextDouble() * halfScreenHeight),
//       ).animate(controller);

//       animation.addListener(() {
//         setState(() {});
//       });

//       _controllers.add(controller);
//       _offsetAnimations.add(animation);
//       controller.forward();
//     }

//     Timer(Duration(seconds: 10), () {
//       _clearAnimations();
//     });
//   }