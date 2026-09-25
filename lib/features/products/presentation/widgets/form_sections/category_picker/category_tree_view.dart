import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'category_tile.dart';
import 'category_tree_utils.dart';

/// عارض شجرة الأقسام ونتائج البحث بتصميم Neumorphism / Soft UI
/// يحتوي على شجرة هرمية تفاعلية وقائمة نتائج بحث ذكية في نفس المكان
class CategoryTreeView extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final String searchQuery;
  final Set<String> expandedIds;
  final ValueChanged<String> onSelectCategory;
  final ValueChanged<String> onToggleExpand;

  const CategoryTreeView({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.searchQuery,
    required this.expandedIds,
    required this.onSelectCategory,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final isSearching = searchQuery.trim().isNotEmpty;
    final flatList = isSearching ? CategoryTreeUtils.flatten(categories) : <CategoryEntity>[];
    final searchResults = isSearching
        ? flatList
            .where((c) =>
                c.displayName.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList()
        : <CategoryEntity>[];

    return Container(
      constraints: const BoxConstraints(maxHeight: 290),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark
            ? Color.lerp(colorScheme.surfaceContainerLowest, Colors.black, 0.12)!
            : Color.lerp(colorScheme.surfaceContainerLowest, Colors.white, 0.50)!,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: isSearching
            ? (searchResults.isEmpty
                ? _buildEmptyState(
                    message: 'لا توجد أقسام تطابق: "$searchQuery"',
                    icon: Icons.search_off_rounded,
                    colorScheme: colorScheme,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: searchResults.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final cat = searchResults[index];
                      final isSelected = selectedCategoryId == cat.id;
                      final breadcrumbs = CategoryTreeUtils.findBreadcrumbs(categories, cat.id);

                      return CategoryTile(
                        category: cat,
                        isSelected: isSelected,
                        onTap: () => onSelectCategory(cat.id),
                        breadcrumbs: breadcrumbs,
                      );
                    },
                  ))
            : ListView(
                padding: const EdgeInsets.all(10),
                children: categories
                    .map((cat) => _buildTreeNode(cat, 0))
                    .toList(),
              ),
      ),
    );
  }

  Widget _buildTreeNode(CategoryEntity cat, int depth) {
    final hasChildren = cat.children.isNotEmpty;
    final isSelected = selectedCategoryId == cat.id;
    final isExpanded = expandedIds.contains(cat.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: depth * 16.0,
            bottom: 8.0,
          ),
          child: CategoryTile(
            category: cat,
            isSelected: isSelected,
            depth: depth,
            hasChildren: hasChildren,
            isExpanded: isExpanded,
            onTap: () => onSelectCategory(cat.id),
            onToggleExpand: hasChildren ? () => onToggleExpand(cat.id) : null,
          ),
        ),
        if (hasChildren && isExpanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cat.children
                .map((child) => _buildTreeNode(child, depth + 1))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildEmptyState({
    required String message,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 12.5,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
