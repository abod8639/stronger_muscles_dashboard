import 'package:flutter/material.dart';
import 'order_card_section.dart';

/// بطاقة ملاحظات العميل على الطلب بتصميم Neumorphism / Soft UI (بدون أنيميشن)
class OrderNotesSection extends StatelessWidget {
  final String notes;

  const OrderNotesSection({
    super.key,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return OrderCardSection(
      title: 'ملاحظات العميل',
      icon: Icons.note_alt_outlined,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
                  ? Colors.black.withValues(alpha: 0.35)
                  : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
              offset: const Offset(2, 2.5),
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
                : Colors.white.withValues(alpha: 0.85),
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote_rounded,
              size: 20,
              color: colorScheme.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                notes,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: colorScheme.onSurface,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

