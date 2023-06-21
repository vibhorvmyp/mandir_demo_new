import 'dart:math' as math;
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui;

class FlowersPaint extends StatefulWidget {
  const FlowersPaint({super.key});

  @override
  State<FlowersPaint> createState() => _FlowersPaintState();
}

class _FlowersPaintState extends State<FlowersPaint>
    with TickerProviderStateMixin {
  late Ticker ticker;
  // final notifier = ValueNotifier(Duration.zero);

  final flowerNotifier = ValueNotifier(Duration.zero);
  final bellNotifier = ValueNotifier(Duration.zero);

  ui.Image? flower;

  Offset draggablePosition = Offset(0, 0);
  Offset initialPosition = Offset(0, 0);

  final audioPlayer = AudioPlayer();

  bool isPlaying = false;

  late AnimationController _controller;
  late Animation<double> _animation;
  Offset _initialPosition = Offset(
    -30,
    -200,
  );
  Offset _currentPosition = Offset.zero;

  final String audioUrl =
      'https://dl.sndup.net/m28g/Hanuman%20Ji%20Ki%20Aarti.mp3';

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
        // setState(() {
        isPlaying = true;
        // });
      } else if (state == PlayerState.paused || state == PlayerState.stopped) {
        // setState(() {
        isPlaying = false;
        // });
      }
    });

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

    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   // Set the initial position to the middle of the screen
    //   setState(() {
    //     _initialPosition = Offset(
    //       MediaQuery.of(context).size.width / 2,
    //       MediaQuery.of(context).size.height / 2,
    //     );
    //   });
    // });
  }

  Offset calculateCircularPosition(double animationValue) {
    const double radius = 100.0;
    final double angle = animationValue * 6.5 * math.pi;
    final double x = radius * math.cos(angle);
    final double y = radius * math.sin(angle);
    return _initialPosition.translate(x, y);
  }

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

  void resetDraggablePosition() {
    // setState(() {
    //   draggablePosition = initialPosition;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/hanuman_1.jpg', // Replace with your image path
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

          //Draggable object
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: Draggable(
              feedback: SizedBox(
                width: 180,
                height: 180,
                child: Image.asset('assets/pooja_thaali.png'),
                // color: Colors.red.withOpacity(0.7),
              ),
              onDragStarted: () {
                // setState(() {
                initialPosition = Offset(
                  MediaQuery.of(context).size.width / 2 - 50,
                  MediaQuery.of(context).size.height - 100,
                );
                // });
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
                child: Container(
                  width: 180,
                  height: 180,
                  child: Image.asset('assets/pooja_thaali.png'),
                ),
              ),
              // onDraggableCanceled: (_, __) {
              //   resetDraggablePosition();
              // },
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
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Color(0xFFEB0C2E),
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
              // icon: Icon(, color: Colors.white),
            ),
          ),

          Positioned(
            bottom: 120,
            left: 16,
            child: GestureDetector(
              onTap: () => ticker.isTicking ? ticker.stop() : ticker.start(),
              child: Container(
                  width: 52,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.brown.shade400.withOpacity(0.9),
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Colors.brown)
                      // color: Colors.amber,
                      ),
                  child: Image.asset('assets/flower_2.png')),
              // icon: Icon(, color: Colors.white),
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
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Color(0xFFEB0C2E),
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.brown)
                    // color: Colors.amber,
                    ),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              // icon: Icon(, color: Colors.white),
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

class Flower {
  Flower(int ms, this.rect, List<double> r, Size size)
      : startTimeMs = ms,
        scale = lerpDouble(1, 0.5, r[0])!,
        rotation = math.pi * lerpDouble(-2, 2, r[2])!,
        xSimulation = FrictionSimulation(0.9, r[2] * size.width,
            ui.lerpDouble(size.width / 2, -size.width / 2, r[1])!),
        // ySimulation = GravitySimulation(ui.lerpDouble(10, 1000, r[0])!,
        //     -rect.height / 2, size.height + rect.height / 2, 100);
        ySimulation = GravitySimulation(
            40, -rect.height / 2, size.height + rect.height / 2, 100);

  final int startTimeMs;
  final Rect rect;
  final Simulation xSimulation;
  final Simulation ySimulation;
  final double scale;
  final double rotation;

  double x(int ms) => xSimulation.x(_normalizeTime(ms));

  double y(int ms) => ySimulation.x(_normalizeTime(ms));

  bool isDead(int ms) => ySimulation.isDone(_normalizeTime(ms));

  double _normalizeTime(int ms) =>
      (ms - startTimeMs) / Duration.millisecondsPerSecond;

  RSTransform transform(int ms, Size size) {
    final translateY = y(ms);
    return RSTransform.fromComponents(
      translateX: x(ms),
      translateY: translateY,
      anchorX: rect.width / 2,
      anchorY: rect.height / 2,
      rotation: rotation * translateY / size.height,
      scale: scale,
    );
  }
}

class FallingFlowersPainter extends CustomPainter {
  final ui.Image? flower;
  final ValueNotifier<Duration> notifier;
  final imagePaint = Paint();
  final backgroundPaint = Paint()..color = Colors.transparent;
  final random = math.Random();
  final flowers = <Flower>[];
  int nextReport = 0;

  static const flowerRects = [
    Rect.fromLTRB(000, 0, 103, 140),
    Rect.fromLTRB(103, 0, 217, 140),
    Rect.fromLTRB(217, 0, 312, 140),
    Rect.fromLTRB(312, 0, 410, 140),
  ];

  FallingFlowersPainter(this.flower, this.notifier) : super(repaint: notifier);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.drawPaint(backgroundPaint);
    if (flower != null) {
      final ms = DateTime.now().millisecondsSinceEpoch;
      if (random.nextDouble() < 1) {
        // drop new bird
        flowers.add(Flower(ms, flowerRects[random.nextInt(4)],
            List.generate(3, (i) => random.nextDouble()), size));
      }

      final transforms =
          flowers.map((flower) => flower.transform(ms, size)).toList();
      final rects = flowers.map((flower) => flower.rect).toList();
      canvas.drawAtlas(
          flower!, transforms, rects, null, null, null, imagePaint);

      // dead birds cleanup
      flowers.removeWhere((flower) => flower.isDead(ms));

      if (ms >= nextReport) {
        nextReport = ms + 2000;
        print('flowers population: ${flowers.length}');
      }
    }
  }

  @override
  bool shouldRepaint(FallingFlowersPainter oldDelegate) => false;
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
      duration: Duration(seconds: 3),
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
    await player.play(UrlSource(
        'https://2u039f-a.akamaihd.net/downloads/ringtones/files/mp3/temple-bell-543.mp3'));
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
          'assets/bell.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}

class CircularPathAnimation extends StatefulWidget {
  @override
  _CircularPathAnimationState createState() => _CircularPathAnimationState();
}

class _CircularPathAnimationState extends State<CircularPathAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(); // repeat the animation

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            final double angle = _animation.value * 2.0 * math.pi;
            return Transform.translate(
              offset: Offset(
                100.0 * math.cos(angle),
                100.0 * math.sin(angle),
              ),
              child: child!,
            );
          },
          child: Image.asset('assets/pooja_thaali.png')),
    );
  }
}
