import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class GradientBackgroundPainter extends CustomPainter {
  final bool isDark;

  GradientBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.topRight,
        radius: 1.5,
        colors: isDark
            ? [AppColors.primary.withValues(alpha: 0.15), Colors.transparent]
            : [AppColors.primary.withValues(alpha: 0.08), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Second gradient blob
    final paint2 = Paint()
      ..shader = RadialGradient(
        center: Alignment.bottomLeft,
        radius: 1.2,
        colors: isDark
            ? [const Color(0xFF6366F1).withValues(alpha: 0.1), Colors.transparent]
            : [const Color(0xFF6366F1).withValues(alpha: 0.05), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
