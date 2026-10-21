import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/widgets/auth_error_card.dart';

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: AuthErrorCard(
              error: error,
              onRetry: onRetry,
            ),
          ),
        ),
      ),
    );
  }
}
