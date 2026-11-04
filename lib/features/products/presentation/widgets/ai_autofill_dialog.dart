import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/weight_unit_helper.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/form_sections/category_picker/category_tree_utils.dart';
import '../../domain/entities/ai_product_suggestion_entity.dart';

/// Interactive, user-friendly Preview Modal where AI-generated product fields
/// can be freely reviewed, edited, selected/unselected, and applied to the form.
class AiAutofillDialog extends StatefulWidget {
  final AiProductSuggestionEntity suggestion;
  final List<CategoryEntity> availableCategories;
  final Function(
    AiProductSuggestionEntity updatedSuggestion,
    Set<String> selectedSections,
    String? categoryIdToSet,
  ) onApply;

  const AiAutofillDialog({
    super.key,
    required this.suggestion,
    required this.availableCategories,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required AiProductSuggestionEntity suggestion,
    required List<CategoryEntity> availableCategories,
    required Function(
      AiProductSuggestionEntity updatedSuggestion,
      Set<String> selectedSections,
      String? categoryIdToSet,
    ) onApply,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AiAutofillDialog(
        suggestion: suggestion,
        availableCategories: availableCategories,
        onApply: onApply,
      ),
    );
  }

  @override
  State<AiAutofillDialog> createState() => _AiAutofillDialogState();
}

class _AiAutofillDialogState extends State<AiAutofillDialog> {
  // Active Sections to apply
  final Set<String> _selectedSections = {
    'names',
    'descriptions',
    'brand',
    'category',
    'nutrition',
    'allergens',
    'tags',
    'flavors',
    'sizes',
    'sku',
  };

  // Controllers for editable fields
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _nameEnCtrl;
  late final TextEditingController _descArCtrl;
  late final TextEditingController _descEnCtrl;
  late final TextEditingController _brandCtrl;
  late final TextEditingController _servingCtrl;
  late final TextEditingController _sessionsCtrl;
  late final TextEditingController _caloriesCtrl;
  late final TextEditingController _proteinCtrl;
  late final TextEditingController _carbsCtrl;
  late final TextEditingController _fatCtrl;
  late final TextEditingController _sugarCtrl;

  late final List<String> _flavors;
  late final List<String> _tags;
  late final List<String> _allergens;
  late final List<Map<String, dynamic>> _sizes;

  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    final s = widget.suggestion;
    _nameArCtrl = TextEditingController(text: s.nameAr);
    _nameEnCtrl = TextEditingController(text: s.nameEn);
    _descArCtrl = TextEditingController(text: s.descAr);
    _descEnCtrl = TextEditingController(text: s.descEn);
    _brandCtrl = TextEditingController(text: s.brandName ?? '');
    _servingCtrl = TextEditingController(text: s.servingSize ?? '');
    _sessionsCtrl = TextEditingController(
      text: s.servingsPerContainer?.toString() ?? '',
    );
    _caloriesCtrl = TextEditingController(text: s.calories ?? '');
    _proteinCtrl = TextEditingController(text: s.protein ?? '');
    _carbsCtrl = TextEditingController(text: s.carbs ?? '');
    _fatCtrl = TextEditingController(text: s.fat ?? '');
    _sugarCtrl = TextEditingController(text: s.sugar ?? '');

    _flavors = List.from(s.flavors);
    _tags = List.from(s.tags);
    _allergens = List.from(s.allergens);
    _sizes = List.from(s.suggestedSizes);

    // Match suggested category with existing store categories (including subcategories)
    final flatCategories = CategoryTreeUtils.flatten(widget.availableCategories);
    if (s.suggestedCategory != null && flatCategories.isNotEmpty) {
      final query = s.suggestedCategory!.toLowerCase().trim();
      for (final cat in flatCategories) {
        if (cat.nameAr.toLowerCase().contains(query) ||
            cat.nameEn.toLowerCase().contains(query) ||
            query.contains(cat.nameAr.toLowerCase()) ||
            query.contains(cat.nameEn.toLowerCase())) {
          _selectedCategoryId = cat.id;
          break;
        }
      }
    }
    if (_selectedCategoryId == null && flatCategories.isNotEmpty) {
      _selectedCategoryId = flatCategories.first.id;
    }
  }

  @override
  void dispose() {
    _nameArCtrl.dispose();
    _nameEnCtrl.dispose();
    _descArCtrl.dispose();
    _descEnCtrl.dispose();
    _brandCtrl.dispose();
    _servingCtrl.dispose();
    _sessionsCtrl.dispose();
    _caloriesCtrl.dispose();
    _proteinCtrl.dispose();
    _carbsCtrl.dispose();
    _fatCtrl.dispose();
    _sugarCtrl.dispose();
    super.dispose();
  }

  void _toggleSection(String sectionKey) {
    setState(() {
      if (_selectedSections.contains(sectionKey)) {
        _selectedSections.remove(sectionKey);
      } else {
        _selectedSections.add(sectionKey);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedSections.length == 10) {
        _selectedSections.clear();
      } else {
        _selectedSections.addAll([
          'names',
          'descriptions',
          'brand',
          'category',
          'nutrition',
          'allergens',
          'tags',
          'flavors',
          'sizes',
          'sku',
        ]);
      }
    });
  }

  void _handleApply() {
    final updated = widget.suggestion.copyWith(
      nameAr: _nameArCtrl.text.trim(),
      nameEn: _nameEnCtrl.text.trim(),
      descAr: _descArCtrl.text.trim(),
      descEn: _descEnCtrl.text.trim(),
      brandName: _brandCtrl.text.trim(),
      servingSize: _servingCtrl.text.trim(),
      servingsPerContainer: int.tryParse(_sessionsCtrl.text.trim()),
      calories: _caloriesCtrl.text.trim(),
      protein: _proteinCtrl.text.trim(),
      carbs: _carbsCtrl.text.trim(),
      fat: _fatCtrl.text.trim(),
      sugar: _sugarCtrl.text.trim(),
      flavors: _flavors,
      tags: _tags,
      allergens: _allergens,
      suggestedSizes: _sizes,
    );

    widget.onApply(updated, _selectedSections, _selectedCategoryId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: 850,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(colorScheme, isDark, theme),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionWrapper(
                      keyName: 'names',
                      title: 'الأسماء (العربي والإنجليزي)',
                      icon: Icons.title_rounded,
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameArCtrl,
                            decoration: InputDecoration(
                              labelText: 'اسم المنتج باللغة العربية',
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _nameEnCtrl,
                            decoration: InputDecoration(
                              labelText: 'اسم المنتج باللغة الإنجليزية',
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildSectionWrapper(
                      keyName: 'descriptions',
                      title: 'الأوصاف التسويقية (العربي والإنجليزي)',
                      icon: Icons.description_outlined,
                      child: Column(
                        children: [
                          TextField(
                            controller: _descArCtrl,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'الوصف التسويقي بالعربية',
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _descEnCtrl,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'الوصف باللغة الإنجليزية',
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildSectionWrapper(
                      keyName: 'brand',
                      title: 'العلامة التجارية والتصنيف',
                      icon: Icons.branding_watermark_outlined,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _brandCtrl,
                              decoration: InputDecoration(
                                labelText: 'العلامة التجارية (Brand)',
                                filled: true,
                                fillColor: colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          if (widget.availableCategories.isNotEmpty) ...[
                            const SizedBox(width: 14),
                            Builder(
                              builder: (context) {
                                final flatCategories =
                                    CategoryTreeUtils.flatten(
                                  widget.availableCategories,
                                );
                                final validSelection = flatCategories.any(
                                  (c) => c.id == _selectedCategoryId,
                                )
                                    ? _selectedCategoryId
                                    : (flatCategories.isNotEmpty
                                        ? flatCategories.first.id
                                        : null);

                                return Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: validSelection,
                                    decoration: InputDecoration(
                                      labelText: 'القسم المقترح',
                                      filled: true,
                                      fillColor: colorScheme
                                          .surfaceContainerHighest
                                          .withValues(alpha: 0.3),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                    items: flatCategories.map((c) {
                                      final breadcrumbs =
                                          CategoryTreeUtils.findBreadcrumbs(
                                        widget.availableCategories,
                                        c.id,
                                      );
                                      final label = breadcrumbs.isNotEmpty
                                          ? breadcrumbs.join(' > ')
                                          : c.displayName;
                                      return DropdownMenuItem<String>(
                                        value: c.id,
                                        child: Text(
                                          label,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (v) =>
                                        setState(() => _selectedCategoryId = v),
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildSectionWrapper(
                      keyName: 'nutrition',
                      title: 'الحصص والقيم الغذائية (Nutrition Facts)',
                      icon: Icons.fact_check_outlined,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _servingCtrl,
                                  decoration: InputDecoration(
                                    labelText: 'حجم الحصة',
                                    hintText: 'مثال: 30g (1 Scoop)',
                                    filled: true,
                                    fillColor: colorScheme
                                        .surfaceContainerHighest
                                        .withValues(alpha: 0.3),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _sessionsCtrl,
                                  decoration: InputDecoration(
                                    labelText: 'عدد الحصص',
                                    hintText: 'مثال: 60',
                                    filled: true,
                                    fillColor: colorScheme
                                        .surfaceContainerHighest
                                        .withValues(alpha: 0.3),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _buildMiniField(
                                _caloriesCtrl,
                                'السعرات',
                                '120',
                                colorScheme,
                              ),
                              const SizedBox(width: 8),
                              _buildMiniField(
                                _proteinCtrl,
                                'البروتين',
                                '24g',
                                colorScheme,
                              ),
                              const SizedBox(width: 8),
                              _buildMiniField(
                                _carbsCtrl,
                                'الكاربوهيدرات',
                                '3g',
                                colorScheme,
                              ),
                              const SizedBox(width: 8),
                              _buildMiniField(
                                _fatCtrl,
                                'الدهون',
                                '1.5g',
                                colorScheme,
                              ),
                              const SizedBox(width: 8),
                              _buildMiniField(
                                _sugarCtrl,
                                'السكر',
                                '1g',
                                colorScheme,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildSectionWrapper(
                      keyName: 'flavors',
                      title: 'النكهات المقترحة (${_flavors.length})',
                      icon: Icons.icecream_outlined,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _flavors.map((f) {
                          final cleanName = f.contains('|')
                              ? f.split('|').first.trim()
                              : f.trim();
                          return Chip(
                            avatar: const Icon(Icons.icecream_outlined, size: 16),
                            label: Text(
                              cleanName,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onDeleted: () {
                              setState(() => _flavors.remove(f));
                            },
                            deleteIconColor: Colors.redAccent,
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildSectionWrapper(
                      keyName: 'sizes',
                      title: 'الأحجام والعبوات المعتمدة بالجرام والكيلو (${_sizes.length})',
                      icon: Icons.scale_outlined,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _sizes.map((s) {
                          final rawSize = s['size']?.toString() ?? '';
                          final sizeName =
                              WeightUnitHelper.normalizeToMetric(rawSize);
                          final rawWeight = s['weight']?.toString() ?? '';
                          final weight =
                              WeightUnitHelper.normalizeToMetric(rawWeight);
                          final servings = s['servings']?.toString() ?? '';
                          return Chip(
                            avatar:
                                const Icon(Icons.straighten_rounded, size: 16),
                            label: Text(
                              '$sizeName ${weight.isNotEmpty && weight != sizeName ? "($weight)" : ""} ${servings.isNotEmpty ? "• $servings حصة" : ""}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            onDeleted: () {
                              setState(() => _sizes.remove(s));
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildSectionWrapper(
                      keyName: 'tags',
                      title: 'الوسوم ومسببات الحساسية',
                      icon: Icons.local_offer_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_allergens.isNotEmpty) ...[
                            Text(
                              'مسببات الحساسية:',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              children: _allergens.map((a) {
                                return Chip(
                                  backgroundColor:
                                      Colors.orange.withValues(alpha: 0.15),
                                  label: Text(
                                    a,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  onDeleted: () =>
                                      setState(() => _allergens.remove(a)),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                          ],
                          Text(
                            'وسوم البحث المقترحة (Tags):',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: _tags.map((t) {
                              return Chip(
                                label: Text(t, style: const TextStyle(fontSize: 11)),
                                onDeleted: () => setState(() => _tags.remove(t)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer / Actions
            _buildFooter(colorScheme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniField(
    TextEditingController ctrl,
    String label,
    String hint,
    ColorScheme colorScheme,
  ) {
    return Expanded(
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          isDense: true,
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildSectionWrapper({
    required String keyName,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final isSelected = _selectedSections.contains(keyName);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.5)
              : colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleSection(keyName),
              ),
              Icon(icon, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (isSelected) ...[
            const SizedBox(height: 10),
            child,
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.tertiary],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معاينة اقتراحات الذكاء الاصطناعي (Gemini)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'يمكنك تعديل أي بيانات واستبعاد أو تضمين الحقول قبل تطبيقها في النموذج',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: _toggleSelectAll,
            icon: Icon(
              _selectedSections.length == 10
                  ? Icons.deselect_rounded
                  : Icons.select_all_rounded,
              size: 18,
            ),
            label: Text(
              _selectedSections.length == 10 ? 'إلغاء التحديد' : 'تحديد الكل',
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'تم تحديد ${_selectedSections.length} أقسام للتطبيق',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('إلغاء'),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _selectedSections.isEmpty ? null : _handleApply,
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.check_circle_rounded, size: 18),
                label: const Text('تطبيق البيانات على النموذج'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
