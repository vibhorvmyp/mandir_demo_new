// import 'package:flutter/material.dart';

// class AnimationWidget extends StatefulWidget {
//   @override
//   _AnimationWidgetState createState() => _AnimationWidgetState();
// }

// class _AnimationWidgetState extends State<AnimationWidget>
//     with TickerProviderStateMixin {
//   List<AnimationController> _animationControllers = [];
//   CombinedListenable _combinedListenable = CombinedListenable();

//   @override
//   void dispose() {
//     for (var controller in _animationControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomPaint(
//         painter: CombinedPainter(),
//         foregroundPainter: CombinedForegroundPainter(_combinedListenable),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _addAnimation();
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   void _addAnimation() {
//     setState(() {
//       final controller = AnimationController(
//         duration: Duration(seconds: 1),
//         vsync: this,
//       );
//       _animationControllers.add(controller);
//       _combinedListenable.addController(controller);
//       controller.forward();
//     });
//   }
// }

// class CombinedPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     // Draw background animations here
//     final paint = Paint()..color = Colors.red;
//     final rect = Rect.fromLTWH(0, 0, size.width, size.height);
//     canvas.drawRect(rect, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

// class CombinedForegroundPainter extends CustomPainter {
//   final CombinedListenable combinedListenable;

//   CombinedForegroundPainter(this.combinedListenable)
//       : super(repaint: combinedListenable);

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Draw foreground animations here
//     final paint = Paint()..color = Colors.blue;

//     for (var controller in combinedListenable.animationControllers) {
//       final progress = controller.value;

//       final rect = Rect.fromLTWH(
//         size.width / 2 - size.width * progress / 2,
//         size.height / 2 - size.height * progress / 2,
//         size.width * progress,
//         size.height * progress,
//       );
//       canvas.drawRect(rect, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

// class CombinedListenable extends ChangeNotifier implements Listenable {
//   final List<AnimationController> _animationControllers = [];

//   void addController(AnimationController controller) {
//     _animationControllers.add(controller);
//     controller.addListener(_handleAnimationChanged);
//   }

//   void _handleAnimationChanged() {
//     notifyListeners();
//   }

//   List<AnimationController> get animationControllers =>
//       _animationControllers.toList();
// }
