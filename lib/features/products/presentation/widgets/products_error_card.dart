import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';

/// بطاقة عرض الأخطاء المخصصة لطبقة المنتجات
/// تعرض تفاصيل الـ Failure المستخرجة عبر `toMessage()` مع إمكانية إعادة المحاولة (Retry)
class ProductsErrorCard extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ProductsErrorCard({
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
    final title = _resolveTitle(failure);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.redAccent.withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.redAccent, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
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
                        height: 1.45,
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
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.35),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
    if (failure is ServerFailure) return Icons.dns_rounded;
    return Icons.error_outline_rounded;
  }

  String _resolveTitle(Failure failure) {
    if (failure is NetworkFailure) return 'تعذر الاتصال بالشبكة';
    if (failure is AuthFailure) return 'خطأ في المصادقة والصلاحيات';
    if (failure is ValidationFailure) return 'البيانات غير صالحة';
    if (failure is ParsingFailure) return 'خطأ في معالجة بيانات المنتجات';
    if (failure is ServerFailure) return 'خطأ في خادم النظام';
    return 'حدث خطأ أثناء تحميل المنتجات';
  }
}
