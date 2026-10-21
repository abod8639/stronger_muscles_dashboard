import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';

class AuthErrorCard extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const AuthErrorCard({
    super.key,
    required this.error,
    this.onRetry,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final failure = error is Failure
        ? error as Failure
        : UnknownFailure(message: error.toString());

    final message = failure.toMessage();
    final IconData icon = _resolveIcon(failure);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.redAccent.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.redAccent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _resolveTitle(failure),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.white70),
                  onPressed: onDismiss,
                  tooltip: 'إغلاق',
                ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18, color: Colors.white),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _resolveIcon(Failure failure) {
    if (failure is NetworkFailure) return Icons.wifi_off_rounded;
    if (failure is AuthFailure) return Icons.lock_outline_rounded;
    if (failure is ValidationFailure) return Icons.warning_amber_rounded;
    if (failure is ParsingFailure) return Icons.data_array_rounded;
    return Icons.error_outline_rounded;
  }

  String _resolveTitle(Failure failure) {
    if (failure is NetworkFailure) return 'خطأ في الاتصال';
    if (failure is AuthFailure) return 'خطأ في المصادقة';
    if (failure is ValidationFailure) return 'بيانات غير صالحة';
    if (failure is ParsingFailure) return 'خطأ في معالجة البيانات';
    if (failure is ServerFailure) return 'خطأ في الخادم';
    return 'تنبيه';
  }
}
