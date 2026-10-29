import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

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

  /// يبني واجهة الخطأ من أي كائن خطأ: إن كان [Failure] تُستخرج الأيقونة والعنوان
  /// والرسالة حسب نوعه، وإلا يُعرض [fallbackTitle] مع نص الخطأ
  factory EnhancedErrorWidget.fromError(
    Object error, {
    Key? key,
    required VoidCallback onRetry,
    String fallbackTitle = 'حدث خطأ غير متوقع',
  }) {
    final failure = error is Failure
        ? error
        : UnknownFailure(message: error.toString());

    final (IconData icon, String title) = switch (failure) {
      NetworkFailure() => (Icons.wifi_off_rounded, 'تعذر الاتصال بالشبكة'),
      AuthFailure() => (
        Icons.lock_outline_rounded,
        'خطأ في المصادقة والصلاحيات',
      ),
      ValidationFailure() => (
        Icons.warning_amber_rounded,
        'البيانات غير صالحة',
      ),
      ParsingFailure() => (Icons.data_array_rounded, 'خطأ في معالجة البيانات'),
      ServerFailure() => (Icons.dns_rounded, 'خطأ في خادم النظام'),
      _ => (Icons.error_outline_rounded, fallbackTitle),
    };

    return EnhancedErrorWidget(
      key: key,
      title: title,
      message: failure.toMessage(),
      icon: icon,
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppDesignTokens.space24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: AppDesignTokens.radiusLarge,
                  ),
                  child: Icon(
                    icon ?? Icons.error_outline,
                    color: colorScheme.error,
                    size: 40,
                  ),
                ),
                const SizedBox(height: AppDesignTokens.space24),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppDesignTokens.space12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppDesignTokens.space32),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_outlined, size: 20),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
