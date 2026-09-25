import 'package:flutter/material.dart';

/// بطاقة عرض التصنيف المختار حالياً بتصميم Neumorphism / Soft UI
/// تتضمن مسار الفتات الهرمي مع زر ملموس لإلغاء التحديد، أو تنبيه توجيهي في حال عدم الاختيار
class CategorySelectionBanner extends StatelessWidget {
  final bool hasSelection;
  final List<String> breadcrumbs;
  final VoidCallback onClear;

  const CategorySelectionBanner({
    super.key,
    required this.hasSelection,
    required this.breadcrumbs,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    if (hasSelection) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Color.lerp(colorScheme.primaryContainer, Colors.white, 0.02)!,
                    Color.lerp(colorScheme.surfaceContainer, colorScheme.primary, 0.14)!,
                  ]
                : [
                    Color.lerp(colorScheme.primaryContainer, Colors.white, 0.40)!,
                    Color.lerp(colorScheme.primaryContainer, Colors.black, 0.02)!,
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.35)
                  : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
              offset: const Offset(1.5, 2),
              blurRadius: 3,
            ),
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.02)
                  : Colors.white.withValues(alpha: 0.90),
              offset: const Offset(-1.5, -1.5),
              blurRadius: 2.5,
            ),
          ],
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: isDark ? 0.5 : 0.6),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.folder_special_rounded,
                size: 18,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'القسم المختار للمنتج:',
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.primary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: [
                      for (int i = 0; i < breadcrumbs.length; i++) ...[
                        Text(
                          breadcrumbs[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: i == breadcrumbs.length - 1
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (i < breadcrumbs.length - 1)
                          Icon(
                            Icons.chevron_left_rounded,
                            size: 15,
                            color: colorScheme.outline,
                          ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // زر إلغاء التحديد
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.02)!,
                          Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.06)!,
                        ]
                      : [
                          Color.lerp(colorScheme.surface, Colors.white, 0.85)!,
                          Color.lerp(colorScheme.surface, const Color(0xFFA3B1C6), 0.08)!,
                        ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.30)
                        : const Color(0xFFA3B1C6).withValues(alpha: 0.20),
                    offset: const Offset(1, 1.5),
                    blurRadius: 2.5,
                  ),
                  BoxShadow(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.02)
                        : Colors.white.withValues(alpha: 0.90),
                    offset: const Offset(-1, -1),
                    blurRadius: 2,
                  ),
                ],
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.white.withValues(alpha: 0.85),
                  width: 1.0,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: onClear,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.clear_rounded, size: 14, color: colorScheme.error),
                        const SizedBox(width: 4),
                        Text(
                          'إلغاء التحديد',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // تنبيه توجيهي في حالة عدم اختيار قسم
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark
            ? Color.lerp(colorScheme.surfaceContainerLowest, Colors.black, 0.15)!
            : Color.lerp(colorScheme.surfaceContainerLow, Colors.white, 0.50)!,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.20),
            offset: const Offset(1.5, 1.5),
            blurRadius: 2.5,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.015)
                : Colors.white.withValues(alpha: 0.85),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 2.5,
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
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'لم يتم اختيار تصنيف بعد. يرجى النقر على القسم المطلوب من القائمة أدناه.',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
