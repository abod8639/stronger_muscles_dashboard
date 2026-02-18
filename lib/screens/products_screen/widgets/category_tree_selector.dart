import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/models/category_model.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';

class CategoryTreeSelector extends StatefulWidget {
  final List<CategoryModel> categories;
  final String? selectedId;
  final Function(String) onSelected;

  final String? label;

  const CategoryTreeSelector({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
    this.label,
  });

  @override
  State<CategoryTreeSelector> createState() => _CategoryTreeSelectorState();
}

class _CategoryTreeSelectorState extends State<CategoryTreeSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label ?? "اختر القسم (التصنيف الشجري)",
          style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        GlassContainer(
          padding: const EdgeInsets.symmetric(vertical: 8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          child: Column(
            children: widget.categories.map((cat) => _buildCategoryItem(cat, 0)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(CategoryModel category, int level) {
    final bool isSelected = widget.selectedId == category.id;
    final bool hasChildren = category.children.isNotEmpty;

    return Column(
      children: [
        InkWell(
          onTap: () => widget.onSelected(category.id),
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16 + (level * 20.0), 12),
            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
            child: Row(
              children: [
                if (hasChildren)
                  Icon(
                    Icons.subdirectory_arrow_left_rounded,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.3),
                  )
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    category.displayName,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.8),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14 - (level * 0.5),
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
              ],
            ),
          ),
        ),
        if (hasChildren)
          ...category.children.map((child) => _buildCategoryItem(child, level + 1)),
      ],
    );
  }
}
