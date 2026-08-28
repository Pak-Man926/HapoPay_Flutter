import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hapopay/features/parent/models/spend_model.dart';

class DonutChartPainter extends CustomPainter {
  final List<SpendCategory> categories;

  DonutChartPainter({required this.categories});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 12.0;

    double startAngle = -math.pi / 2;

    for (final cat in categories) {
      final sweepAngle = (cat.pct / 100.0) * (2 * math.pi) - 0.05;
      final paint = Paint()
        ..color = cat.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += (cat.pct / 100.0) * (2 * math.pi);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
