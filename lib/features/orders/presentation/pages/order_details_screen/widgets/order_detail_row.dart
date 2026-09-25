import 'package:flutter/material.dart';

/// صف تفاصيل الطلب بتصميم Neumorphism / Soft UI (بدون أنيميشن)
/// متوافق مع سمة التطبيق في الوضعين الفاتح والداكن بأيقونة مجسمة ناعمة وتباين بصري مريح.
class OrderDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  const OrderDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // أيقونة مجسمة بنمط Neumorphic
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
                        Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.12)!,
                      ]
                    : [
                        Colors.white,
                        Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.03)!,
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.40)
                      : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
                  offset: const Offset(1.5, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.02)
                      : Colors.white.withValues(alpha: 0.90),
                  offset: const Offset(-1.5, -1.5),
                  blurRadius: 3,
                ),
              ],
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.white.withValues(alpha: 0.80),
                width: 1.0,
              ),
            ),
            child: Icon(
              icon,
              size: 16,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: trailing ??
                  SelectionArea(
                    child: Text(
                      value,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
