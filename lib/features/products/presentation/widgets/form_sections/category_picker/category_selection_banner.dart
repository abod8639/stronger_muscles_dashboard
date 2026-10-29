import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

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
        decoration: AppDesignTokens.softSurface(
          colorScheme,
          isDark: isDark,
          borderRadius: BorderRadius.circular(12),
          compact: true,
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
              decoration: AppDesignTokens.softSurface(
                colorScheme,
                isDark: isDark,
                borderRadius: BorderRadius.circular(8),
                depth: SoftDepth.inset,
                compact: true,
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: onClear,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.clear_rounded,
                          size: 14,
                          color: colorScheme.error,
                        ),
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
      decoration: AppDesignTokens.softSurface(
        colorScheme,
        isDark: isDark,
        borderRadius: BorderRadius.circular(12),
        depth: SoftDepth.inset,
        compact: true,
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
