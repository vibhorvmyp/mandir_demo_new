import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:mandir_demo_new/const/constant.dart';

import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:mandir_demo_new/painter/flower.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Ticker ticker;

  final flowerNotifier = ValueNotifier(Duration.zero);
  final bellNotifier = ValueNotifier(Duration.zero);

  ui.Image? flower;

  Offset draggablePosition = const Offset(0, 0);
  Offset initialPosition = const Offset(0, 0);

  final audioPlayer = AudioPlayer();

  bool isPlaying = false;

  late AnimationController _controller;
  late Animation<double> _animation;
  final Offset _initialPosition = const Offset(
    -30,
    -200,
  );
  Offset _currentPosition = Offset.zero;

  final String audioUrl = Constant.aartiAudioUrl;

  void playPauseAudio() async {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(audioUrl));
    }
  }

  @override
  void initState() {
    super.initState();
    ticker = Ticker(_tick);
    rootBundle
        .load('assets/flower_2.png')
        .then((data) => decodeImageFromList(data.buffer.asUint8List()))
        .then(_setSprite);

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        isPlaying = true;
      } else if (state == PlayerState.paused || state == PlayerState.stopped) {
        isPlaying = false;
      }
    });

    //Pooja Thaali Animation
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _animation.addListener(() {
      setState(() {
        _currentPosition = calculateCircularPosition(_animation.value);
      });
    });
  }

  Offset calculateCircularPosition(double animationValue) {
    const double radius = 100.0;
    final double angle = animationValue * 6.5 * math.pi;
    final double x = radius * math.cos(angle);
    final double y = radius * math.sin(angle);
    return _initialPosition.translate(x, y);
  }

  //Pooja Thaali
  void _startAnimation() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
  }

  _tick(Duration d) => flowerNotifier.value = d;

  _setSprite(ui.Image image) {
    setState(() {
      flower = image;
    });
  }

  void resetDraggablePosition() {}

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
                foregroundPainter:
                    FallingFlowersPainter(flower, flowerNotifier),
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
                initialPosition = Offset(
                  MediaQuery.of(context).size.width / 2 - 50,
                  MediaQuery.of(context).size.height - 100,
                );
              },
              onDragEnd: (_) {
                resetDraggablePosition();
              },
              onDraggableCanceled: (_, __) {
                resetDraggablePosition();
              },
              childWhenDragging: Container(),
              onDragCompleted: () {
                resetDraggablePosition();
              },
              child: AnimatedBuilder(
                animation: _animation,
                builder: (BuildContext context, Widget? child) {
                  return Transform.translate(
                    offset: _currentPosition,
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
                _startAnimation();
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
              onTap: () => ticker.isTicking ? ticker.stop() : ticker.start(),
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
                playPauseAudio();
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
          const Positioned(
            top: 100,
            left: 250,
            child: SwingingBellAnimation(),
          ),
          const Positioned(
            top: 100,
            right: 250,
            child: SwingingBellAnimation(),
          ),
        ],
      ),
    );
  }
}

class SwingingBellAnimation extends StatefulWidget {
  const SwingingBellAnimation({super.key});

  @override
  SwingingBellAnimationState createState() => SwingingBellAnimationState();
}

class SwingingBellAnimationState extends State<SwingingBellAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _swingAnimation;

  final double _swingAngle = math.pi / 6;

  @override
  void initState() {
    super.initState();

    playBellSound();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _swingAnimation = Tween<double>(
      begin: -_swingAngle,
      end: _swingAngle,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  final player = AudioPlayer();

  void playBellSound() async {
    await player.play(UrlSource(Constant.bellAudioUrl));
  }

  @override
  void dispose() {
    _animationController.dispose();
    player.dispose();
    super.dispose();
  }

  void _handleTap() {
    playBellSound();
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _swingAnimation.value *
                math.sin(_animationController.value * math.pi),
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
