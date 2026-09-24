import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_controller.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/category_tree_selector.dart';

/// قسم اختيار وتبعية التصنيف الأب مع إمكانية إلغاء التحديد
class CategoryParentSection extends StatelessWidget {
  final CategoriesController controller;

  const CategoryParentSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => CategoryTreeSelector(
            categories: controller.categories,
            selectedId: controller.parentId.value,
            onSelected: (id) => controller.parentId.value = id,
            label: 'اختر التصنيف الرئيسي الأب (اختياري)',
          ),
        ),
        Obx(() {
          if (controller.parentId.value.isNotEmpty) {
            return Padding(
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
                    onPressed: () => controller.parentId.value = '',
                    icon: const Icon(Icons.close_rounded, size: 16),
                    label: const Text('إلغاء التبعية (تصنيف رئيسي)'),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
