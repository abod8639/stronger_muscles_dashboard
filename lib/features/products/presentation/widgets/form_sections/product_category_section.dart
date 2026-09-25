import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'category_picker/category_search_field.dart';
import 'category_picker/category_selection_banner.dart';
import 'category_picker/category_tree_utils.dart';
import 'category_picker/category_tree_view.dart';
import 'form_section_card.dart';

/// قسم تصنيف المنتج بتصميم Neumorphism / Soft UI وفق معايير Clean Architecture
/// منسق رئيسي يفصل المسؤوليات بين مكونات البحث، والراية التوجيهية، والشجرة الهرمية
class ProductCategorySection extends StatefulWidget {
  final ProductsController controller;
  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  const ProductCategorySection({
    super.key,
    required this.controller,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  State<ProductCategorySection> createState() => _ProductCategorySectionState();
}

class _ProductCategorySectionState extends State<ProductCategorySection> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _expandedIds = {};

  @override
  void initState() {
    super.initState();
    CategoryTreeUtils.expandAncestors(
      widget.controller.categories,
      widget.selectedCategoryId,
      _expandedIds,
    );
  }

  @override
  void didUpdateWidget(covariant ProductCategorySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategoryId != widget.selectedCategoryId) {
      CategoryTreeUtils.expandAncestors(
        widget.controller.categories,
        widget.selectedCategoryId,
        _expandedIds,
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleExpand(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final categories = widget.controller.categories.toList();
      final hasCategories = categories.isNotEmpty;
      final selectedId = widget.selectedCategoryId;
      final breadcrumbs = (selectedId != null && selectedId.isNotEmpty)
          ? CategoryTreeUtils.findBreadcrumbs(categories, selectedId)
          : <String>[];
      final hasSelection = breadcrumbs.isNotEmpty;

      return FormSectionCard(
        title: 'تصنيف المنتج',
        subtitle: 'اختر القسم المناسب للمنتج لتسهيل وصول وتصفح العملاء',
        icon: Icons.category_rounded,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          child: Text(
            '${categories.length} أقسام متاحة',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة القسم المختار مع مسار الفتات الهرمي
            CategorySelectionBanner(
              hasSelection: hasSelection,
              breadcrumbs: breadcrumbs,
              onClear: () => widget.onCategorySelected(''),
            ),
            const SizedBox(height: 16),

            // شريط البحث المباشر
            CategorySearchField(
              controller: _searchController,
              hasQuery: _searchQuery.isNotEmpty,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              onClear: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
            const SizedBox(height: 14),

            // شجرة وتصنيفات الأقسام في نفس المكان (In-Place)
            if (!hasCategories)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.folder_off_outlined,
                        size: 28,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'لا توجد أقسام مسجلة حالياً',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              CategoryTreeView(
                categories: categories,
                selectedCategoryId: selectedId,
                searchQuery: _searchQuery,
                expandedIds: _expandedIds,
                onSelectCategory: widget.onCategorySelected,
                onToggleExpand: _toggleExpand,
              ),
          ],
        ),
      );
    });
  }
}
