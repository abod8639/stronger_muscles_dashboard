import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';

/// بطاقة عنصر التصنيف الملموسة بتصميم Neumorphism / Soft UI
/// تدعم نمط الشجرة الهرمية ونمط نتائج البحث المفلترة
class CategoryTile extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;
  final int depth;
  final bool hasChildren;
  final bool isExpanded;
  final VoidCallback? onToggleExpand;
  final List<String>? breadcrumbs;

  const CategoryTile({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.depth = 0,
    this.hasChildren = false,
    this.isExpanded = false,
    this.onToggleExpand,
    this.breadcrumbs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final isSearchMode = breadcrumbs != null;
    final showBreadcrumbSubtitle = isSearchMode && breadcrumbs!.length > 1;

    return Container(
      decoration: AppDesignTokens.softSurface(
        colorScheme,
        isDark: isDark,
        borderRadius: BorderRadius.circular(10),
        depth: SoftDepth.inset,
        compact: true,
        selected: isSelected,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : (isSearchMode
                          ? Icons.label_outline_rounded
                          : (depth == 0
                              ? (isExpanded ? Icons.folder_open_rounded : Icons.folder_rounded)
                              : Icons.subdirectory_arrow_left_rounded)),
                  size: 18,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        category.displayName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                        ),
                      ),
                      if (showBreadcrumbSubtitle) ...[
                        const SizedBox(height: 2),
                        Text(
                          breadcrumbs!.join(' > '),
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected && isSearchMode)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'محدد',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                if (hasChildren && onToggleExpand != null)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: onToggleExpand,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
