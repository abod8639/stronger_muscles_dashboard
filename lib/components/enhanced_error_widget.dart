
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class EnhancedErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;
  final IconData? icon;

  const EnhancedErrorWidget({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon ?? Icons.error_outline,
                  color: AppColors.error,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.refresh_outlined, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'إعادة المحاولة',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

