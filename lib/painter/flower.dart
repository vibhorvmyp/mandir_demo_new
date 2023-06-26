import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class Flower {
  Flower(int ms, this.rect, List<double> r, Size size)
      : startTimeMs = ms,
        scale = ui.lerpDouble(1, 0.5, r[0])!,
        rotation = math.pi * ui.lerpDouble(-2, 2, r[2])!,
        xSimulation = FrictionSimulation(0.9, r[2] * size.width,
            ui.lerpDouble(size.width / 2, -size.width / 2, r[1])!),
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
        flowers.add(Flower(ms, flowerRects[random.nextInt(4)],
            List.generate(3, (i) => random.nextDouble()), size));
      }

      final transforms =
          flowers.map((flower) => flower.transform(ms, size)).toList();
      final rects = flowers.map((flower) => flower.rect).toList();
      canvas.drawAtlas(
          flower!, transforms, rects, null, null, null, imagePaint);

      flowers.removeWhere((flower) => flower.isDead(ms));

      if (ms >= nextReport) {
        nextReport = ms + 2000;
        log('flowers population: ${flowers.length}');
      }
    }
  }

  @override
  bool shouldRepaint(FallingFlowersPainter oldDelegate) => false;
}
