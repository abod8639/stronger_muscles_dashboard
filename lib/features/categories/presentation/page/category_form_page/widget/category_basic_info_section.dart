import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_controller.dart';
import 'category_id_field.dart';

/// قسم البيانات والمعلومات الأساسية ثنائية اللغة للتصنيف
class CategoryBasicInfoSection extends StatelessWidget {
  final CategoriesController controller;
  final CategoryEntity? category;
  final bool isWide;

  const CategoryBasicInfoSection({
    super.key,
    required this.controller,
    this.category,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. System ID Field
        CategoryIdField(controller: controller, category: category),
        const SizedBox(height: 20),

        // 2. Names (Arabic & English)
        if (isWide)
          Row(
            children: [
              Expanded(
                child: ModernTextField(
                  controller: controller.nameArController,
                  label: 'اسم التصنيف (بالعربي) *',
                  icon: Icons.label_important_outline_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ModernTextField(
                  controller: controller.nameEnController,
                  label: 'Category Name (EN)',
                  icon: Icons.translate_rounded,
                ),
              ),
            ],
          )
        else ...[
          ModernTextField(
            controller: controller.nameArController,
            label: 'اسم التصنيف (بالعربي) *',
            icon: Icons.label_important_outline_rounded,
          ),
          const SizedBox(height: 16),
          ModernTextField(
            controller: controller.nameEnController,
            label: 'Category Name (EN)',
            icon: Icons.translate_rounded,
          ),
        ],

        const SizedBox(height: 20),

        // 3. Descriptions (Arabic & English)
        if (isWide)
          Row(
            children: [
              Expanded(
                child: ModernTextField(
                  controller: controller.descArController,
                  label: 'وصف التصنيف (بالعربي) - اختياري',
                  icon: Icons.description_outlined,
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ModernTextField(
                  controller: controller.descEnController,
                  label: 'Description (EN) - Optional',
                  icon: Icons.description_outlined,
                  maxLines: 2,
                ),
              ),
            ],
          )
        else ...[
          ModernTextField(
            controller: controller.descArController,
            label: 'وصف التصنيف (بالعربي) - اختياري',
            icon: Icons.description_outlined,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          ModernTextField(
            controller: controller.descEnController,
            label: 'Description (EN) - Optional',
            icon: Icons.description_outlined,
            maxLines: 2,
          ),
        ],
      ],
    );
  }
}
