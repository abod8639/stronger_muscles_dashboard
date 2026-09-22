import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';

class CategoryTreeSelector extends StatefulWidget {
  final List<CategoryEntity> categories;
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label ?? "اختر القسم (التصنيف الشجري)",
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card.outlined(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.35),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: widget.categories
                  .map((cat) => _buildCategoryItem(cat, 0))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(CategoryEntity category, int level) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isSelected = widget.selectedId == category.id;
    final bool hasChildren = category.children.isNotEmpty;

    return Column(
      children: [
        InkWell(
          onTap: () => widget.onSelected(category.id),
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16 + (level * 20.0), 12),
            color: isSelected
                ? colorScheme.primaryContainer.withValues(alpha: 0.25)
                : Colors.transparent,
            child: Row(
              children: [
                if (hasChildren)
                  Icon(
                    Icons.subdirectory_arrow_left_rounded,
                    size: 16,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  )
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    category.displayName,
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 14 - (level * 0.5),
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: colorScheme.primary,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
        if (hasChildren)
          ...category.children.map(
            (child) => _buildCategoryItem(child, level + 1),
          ),
      ],
    );
  }
}
