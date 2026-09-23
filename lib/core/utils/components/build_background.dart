import 'package:flutter/material.dart';

/// خلفية متدرجة هادئة متوافقة مع Material Design 3
class AppAmbientBackground extends StatelessWidget {
  const AppAmbientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          left: -150,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  colorScheme.secondary.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// دالة مساعدة للتوافق العكسي
Widget buildBackground() {
  return const AppAmbientBackground();
}
