import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_error_widget.dart';

/// Dumb presentation error fallback widget for Navigation initialization failure.
/// Strictly decoupled from sibling features.
class NavigationErrorFallback extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const NavigationErrorFallback({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        error is Failure ? (error as Failure).toMessage() : error.toString();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: EnhancedErrorWidget(
              title: 'خطأ في تهيئة التنقل',
              message: errorMessage,
              onRetry: onRetry ?? () {},
            ),
          ),
        ),
      ),
    );
  }
}
