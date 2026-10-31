import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'category_picker/category_search_field.dart';
import 'category_picker/category_selection_banner.dart';
import 'category_picker/category_tree_utils.dart';
import 'category_picker/category_tree_view.dart';
import 'package:stronger_muscles_dashboard/core/components/section_card.dart';

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
  final TextEditingController _tagController = TextEditingController();
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
    _tagController.dispose();
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

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final categories = widget.controller.categories.toList();
        final hasCategories = categories.isNotEmpty;
        final selectedId = widget.selectedCategoryId;
        final breadcrumbs = (selectedId != null && selectedId.isNotEmpty)
            ? CategoryTreeUtils.findBreadcrumbs(categories, selectedId)
            : <String>[];
        final hasSelection = breadcrumbs.isNotEmpty;

        return SectionCard(
          title: 'تصنيف المنتج',
          subtitle: 'اختر القسم المناسب للمنتج لتسهيل وصول وتصفح العملاء',
          icon: Icons.category_rounded,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: AppDesignTokens.softSurface(
              colorScheme,
              isDark: isDark,
              borderRadius: BorderRadius.circular(8),
              depth: SoftDepth.inset,
              compact: true,
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
              // بطاقة القسم المختار مع مسار الفتات الهرمي ونظام التحقق المتكامل
              FormField<String>(
                initialValue: widget.selectedCategoryId,
                validator: (val) {
                  final currentId = widget.selectedCategoryId ?? val;
                  if (currentId == null ||
                      currentId.trim().isEmpty ||
                      currentId == 'all') {
                    return 'يرجى اختيار قسم مناسب للمنتج من الشجرة أدناه';
                  }
                  return null;
                },
                builder: (fieldState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategorySelectionBanner(
                        hasSelection: hasSelection,
                        breadcrumbs: breadcrumbs,
                        onClear: () {
                          widget.onCategorySelected('');
                          fieldState.didChange('');
                        },
                      ),
                      if (fieldState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, right: 6),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 16,
                                color: colorScheme.error,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                fieldState.errorText!,
                                style: TextStyle(
                                  color: colorScheme.error,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
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
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'لا توجد أقسام مسجلة حالياً',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.8,
                            ),
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

              // محرر الوسوم والكلمات الدلالية (Tags)
              _buildTagsEditor(widget.controller, colorScheme, isDark, theme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTagsEditor(
    ProductsController ctrl,
    ColorScheme colorScheme,
    bool isDark,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Divider(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.tag_rounded, size: 18, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'الوسوم والكلمات الدلالية (Tags)',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'تساعد الوسوم العملاء في الوصول للمنتج بسهولة في البحث والفلترة (اكتب الوسم واضغط Enter)',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _tagController,
                decoration: InputDecoration(
                  hintText: 'مثال: حارق دهون، واي معزول، كيتو...',
                  prefixIcon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                onFieldSubmitted: (val) {
                  ctrl.addTag(val);
                  _tagController.clear();
                },
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: () {
                ctrl.addTag(_tagController.text);
                _tagController.clear();
              },
              child: const Text('إضافة'),
            ),
          ],
        ),
        if (ctrl.tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < ctrl.tags.length; i++)
                InputChip(
                  label: Text('#${ctrl.tags[i]}'),
                  onDeleted: () => ctrl.removeTag(i),
                  deleteIconColor: colorScheme.error,
                  backgroundColor: colorScheme.primaryContainer.withValues(
                    alpha: 0.35,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
