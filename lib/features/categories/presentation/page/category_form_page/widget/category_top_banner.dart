import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/icon_card_with_shadow.dart';

/// ترويسة معلوماتية بنمط Material Design 3 لصفحة إدارة التصنيف
class CategoryTopBanner extends StatelessWidget {
  final bool isEditing;

  const CategoryTopBanner({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card.outlined(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            IconCardWithShadow(
              icon: isEditing ? Icons.edit_note_rounded : Icons.category_rounded,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? 'تعديل التصنيف' : 'إنشاء تصنيف جديد',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isEditing
                        ? 'قم بتحديث مسميات وبيانات التصنيف والشجرة الهرمية التابعة له.'
                        : 'أضف تصنيفاً جديداً لتنظيم وترتيب منتجات المتجر بدقة وسهولة.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
