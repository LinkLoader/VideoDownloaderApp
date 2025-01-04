import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final Color primaryColor;
  final Color secondaryColor;

  AnimatedBackgroundPainter({
    required this.animation,
    this.primaryColor = const Color(0xFF8A2BE2),
    this.secondaryColor = const Color(0xFFFF69B4),
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    // Draw flowing curves
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Animated wave effect
    for (int i = 0; i < 3; i++) {
      final waveOffset = animation.value * 2 * math.pi + (i * math.pi / 2);
      path.reset();
      path.moveTo(0, h * 0.5);

      for (double x = 0; x <= w; x += 1) {
        final y = math.sin((x / w * 4 * math.pi) + waveOffset) *
                math.cos(x / w * 2 * math.pi + animation.value) *
                h *
                0.15 +
            h * 0.5;
        path.lineTo(x, y);
      }

      path.lineTo(w, h);
      path.lineTo(0, h);
      path.close();

      paint.color = i == 0
          ? primaryColor.withOpacity(0.3)
          : secondaryColor.withOpacity(0.2 - (i * 0.05));

      canvas.drawPath(path, paint);
    }

    // Draw floating bubbles
    const bubbleCount = 12;
    for (int i = 0; i < bubbleCount; i++) {
      final radius = (20 + (i % 3) * 15) *
          (1 + math.sin(animation.value * 2 * math.pi + i) * 0.2);
      final xOffset = (w / bubbleCount) * i +
          math.sin(animation.value * 2 * math.pi + i) * 30;
      final yOffset =
          h * 0.3 + math.cos(animation.value * 2 * math.pi + i) * 50;

      final gradient = RadialGradient(
        colors: [
          primaryColor.withOpacity(0.4),
          secondaryColor.withOpacity(0.1),
        ],
      );

      paint.shader = gradient.createShader(
        Rect.fromCircle(center: Offset(xOffset, yOffset), radius: radius),
      );

      canvas.drawCircle(Offset(xOffset, yOffset), radius, paint);
    }
  }

  @override
  bool shouldRepaint(AnimatedBackgroundPainter oldDelegate) => true;
}
