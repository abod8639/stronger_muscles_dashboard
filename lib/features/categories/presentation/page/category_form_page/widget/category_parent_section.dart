import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_controller.dart';
import 'package:stronger_muscles_dashboard/features/products/products_feature.dart';

/// قسم اختيار وتبعية التصنيف الأب مع إمكانية إلغاء التحديد
class CategoryParentSection extends StatelessWidget {
  final CategoriesController controller;

  const CategoryParentSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryTreeSelector(
            categories: controller.categories,
            selectedId: controller.parentId,
            onSelected: (id) => controller.parentId = id,
            label: 'اختر التصنيف الرئيسي الأب (اختياري)',
          ),
          if (controller.parentId.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'تم تحديد تصنيف أب',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => controller.parentId = '',
                    icon: const Icon(Icons.close_rounded, size: 16),
                    label: const Text('إلغاء التبعية (تصنيف رئيسي)'),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
