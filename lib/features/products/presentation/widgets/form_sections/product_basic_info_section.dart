import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/core/components/section_card.dart';
import 'package:stronger_muscles_dashboard/core/components/build_modern_text_field.dart';

/// قسم البيانات الأساسية للمنتج بتصميم Neumorphism / Soft UI
/// يتضمن مفتاح تبديل لغات ناعم، حقول إدخال مجسمة، وقائمة إكمال تلقائي ملموسة
class ProductBasicInfoSection extends StatefulWidget {
  final ProductsController controller;
  final String? selectedCategoryId;
  final ValueChanged<String>? onCategorySelected;

  const ProductBasicInfoSection({
    super.key,
    required this.controller,
    this.selectedCategoryId,
    this.onCategorySelected,
  });

  @override
  State<ProductBasicInfoSection> createState() =>
      _ProductBasicInfoSectionState();
}

class _ProductBasicInfoSectionState extends State<ProductBasicInfoSection> {
  String _selectedLang = 'ar';
  final FocusNode _brandFocusNode = FocusNode();

  @override
  void dispose() {
    _brandFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final ctrl = widget.controller;

    return SectionCard(
      title: 'البيانات الأساسية',
      subtitle: 'الاسم، العلامة التجارية، والوصف للمنتج',
      icon: Icons.edit_note_rounded,
      trailing: _buildLanguageSelector(colorScheme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language-specific Name and Description
          _selectedLang == 'ar'
              ? Column(
                  key: const ValueKey('lang_ar'),
                  children: [
                    ModernTextField(
                      controller: ctrl.textcontrollers['name_ar']!,
                      label: 'اسم المنتج باللغة العربية',
                      hint: 'مثال: واي بروتين جولد ستاندرد 2 كجم',
                      icon: Icons.title_rounded,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    ModernTextField(
                      controller: ctrl.textcontrollers['desc_ar']!,
                      label: 'وصف المنتج باللغة العربية',
                      hint: 'اكتب وصفاً مفصلاً للمنتج...',
                      icon: Icons.description_outlined,
                      maxLines: 4,
                    ),
                  ],
                )
              : Column(
                  key: const ValueKey('lang_en'),
                  children: [
                    ModernTextField(
                      controller: ctrl.textcontrollers['name_en']!,
                      label: 'Product Name (English)',
                      hint: 'e.g. Gold Standard 100% Whey 2kg',
                      icon: Icons.translate_rounded,
                    ),
                    const SizedBox(height: 16),
                    ModernTextField(
                      controller: ctrl.textcontrollers['desc_en']!,
                      label: 'Product Description (English)',
                      hint: 'Write a detailed description in English...',
                      icon: Icons.description_outlined,
                      maxLines: 4,
                    ),
                  ],
                ),
          const SizedBox(height: 18),

          // Brand Autocomplete
          _buildBrandAutocomplete(ctrl, colorScheme, isDark),
        ],
      ),
    );
  }

  /// محدد اللغة بنمط Neumorphic Soft UI
  Widget _buildLanguageSelector(ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: AppDesignTokens.softSurface(
        colorScheme,
        isDark: isDark,
        borderRadius: BorderRadius.circular(12),
        depth: SoftDepth.inset,
        compact: true,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLangPill(
            'ar',
            'العربية 🇸🇦',
            Icons.language_rounded,
            colorScheme,
            isDark,
          ),
          const SizedBox(width: 4),
          _buildLangPill(
            'en',
            'English 🇬🇧',
            Icons.translate_rounded,
            colorScheme,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildLangPill(
    String lang,
    String label,
    IconData icon,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final isSelected = _selectedLang == lang;
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: () => setState(() => _selectedLang = lang),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: AppDesignTokens.softSurface(
          colorScheme,
          isDark: isDark,
          borderRadius: BorderRadius.circular(9),
          compact: true,
          selected: isSelected,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandAutocomplete(
    ProductsController ctrl,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return ListenableBuilder(
      listenable: ctrl,
      builder: (context, _) {
        return Autocomplete<String>(
          focusNode: _brandFocusNode,
          textEditingController: ctrl.textcontrollers['brand'],
          optionsBuilder: (TextEditingValue textEditingValue) {
            final query = textEditingValue.text.trim();
            if (query.isEmpty) {
              return const Iterable<String>.empty();
            }
            final matches = ctrl.brands
                .where(
                  (b) =>
                      b.displayName.toLowerCase().contains(query.toLowerCase()) ||
                      b.nameAr.toLowerCase().contains(query.toLowerCase()) ||
                      b.nameEn.toLowerCase().contains(query.toLowerCase()),
                )
                .map((b) => b.displayName)
                .toList();

            final hasExactMatch = ctrl.brands.any(
              (b) =>
                  b.displayName.toLowerCase() == query.toLowerCase() ||
                  b.nameAr.toLowerCase() == query.toLowerCase() ||
                  b.nameEn.toLowerCase() == query.toLowerCase(),
            );

            if (!hasExactMatch) {
              matches.add('+ إضافة "$query" كعلامة تجارية جديدة');
            }

            return matches;
          },
          onSelected: (String selection) {
            if (selection.startsWith('+ إضافة "')) {
              final brandName = selection
                  .replaceFirst('+ إضافة "', '')
                  .replaceFirst('" كعلامة تجارية جديدة', '');
              ctrl.quickAddBrand(brandName);
            } else {
              ctrl.textcontrollers['brand']?.text = selection;
            }
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
                return ValueListenableBuilder<TextEditingValue>(
                  valueListenable: textEditingController,
                  builder: (context, value, _) {
                    final currentText = value.text.trim();
                    final isExisting = currentText.isNotEmpty &&
                        ctrl.brands.any(
                          (b) =>
                              b.displayName.toLowerCase() ==
                                  currentText.toLowerCase() ||
                              b.nameAr.toLowerCase() ==
                                  currentText.toLowerCase() ||
                              b.nameEn.toLowerCase() ==
                                  currentText.toLowerCase(),
                        );
                    final canAddNew = currentText.isNotEmpty && !isExisting;

                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onFieldSubmitted: (_) {
                        if (canAddNew) {
                          ctrl.quickAddBrand(currentText);
                        } else {
                          onFieldSubmitted();
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'العلامة التجارية (البراند)',
                        hintText: 'اختر أو اكتب براند جديد...',
                        prefixIcon: Icon(
                          Icons.verified_outlined,
                          size: 20,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        suffixIcon: ctrl.isCreatingBrand
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : canAddNew
                                ? Tooltip(
                                    message:
                                        'حفظ "$currentText" في قاعدة البيانات كعلامة تجارية جديدة',
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_rounded,
                                        color: Colors.green,
                                        size: 22,
                                      ),
                                      onPressed: () =>
                                          ctrl.quickAddBrand(currentText),
                                    ),
                                  )
                                : null,
                        filled: true,
                        fillColor: isDark
                            ? colorScheme.surfaceContainerLowest
                                .withValues(alpha: 0.5)
                            : colorScheme.surfaceContainerLow
                                .withValues(alpha: 0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.03)
                                : colorScheme.outlineVariant
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.03)
                                : colorScheme.outlineVariant
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 1.4,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 280,
                margin: const EdgeInsets.only(top: 8),
                constraints: const BoxConstraints(maxHeight: 220),
                decoration: AppDesignTokens.softSurface(
                  colorScheme,
                  isDark: isDark,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      final isAddNew = option.startsWith('+ إضافة ');

                      return ListTile(
                        dense: true,
                        leading: Icon(
                          isAddNew
                              ? Icons.add_circle_rounded
                              : Icons.business_rounded,
                          color: isAddNew ? Colors.green : colorScheme.primary,
                          size: 18,
                        ),
                        title: Text(
                          option,
                          style: TextStyle(
                            color:
                                isAddNew ? Colors.green : colorScheme.onSurface,
                            fontWeight: isAddNew
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
