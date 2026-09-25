import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'form_section_card.dart';
import 'modern_form_field.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final ctrl = widget.controller;

    return FormSectionCard(
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
                    ModernFormField(
                      controller: ctrl.textcontrollers['name_ar']!,
                      label: 'اسم المنتج باللغة العربية',
                      hint: 'مثال: واي بروتين جولد ستاندرد 2 كجم',
                      icon: Icons.title_rounded,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    ModernFormField(
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
                    ModernFormField(
                      controller: ctrl.textcontrollers['name_en']!,
                      label: 'Product Name (English)',
                      hint: 'e.g. Gold Standard 100% Whey 2kg',
                      icon: Icons.translate_rounded,
                    ),
                    const SizedBox(height: 16),
                    ModernFormField(
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark
            ? colorScheme.surfaceContainerLowest.withValues(alpha: 0.6)
            : colorScheme.surfaceContainerLow.withValues(alpha: 0.6),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.20),
            offset: const Offset(1, 1),
            blurRadius: 2,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.80),
            offset: const Offset(-1, -1),
            blurRadius: 1.5,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.white.withValues(alpha: 0.70),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLangPill(
              'ar', 'العربية 🇸🇦', Icons.language_rounded, colorScheme, isDark),
          const SizedBox(width: 4),
          _buildLangPill(
              'en', 'English 🇬🇧', Icons.translate_rounded, colorScheme, isDark),
        ],
      ),
    );
  }

  Widget _buildLangPill(String lang, String label, IconData icon,
      ColorScheme colorScheme, bool isDark) {
    final isSelected = _selectedLang == lang;
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: () => setState(() => _selectedLang = lang),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          Color.lerp(colorScheme.surfaceContainerHigh,
                              Colors.white, 0.02)!,
                          Color.lerp(colorScheme.surfaceContainerHigh,
                              Colors.black, 0.10)!,
                        ]
                      : [
                          Colors.white,
                          Color.lerp(colorScheme.surfaceContainerLow,
                              Colors.black, 0.02)!,
                        ],
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.35)
                        : const Color(0xFFA3B1C6).withValues(alpha: 0.30),
                    offset: const Offset(1.5, 2),
                    blurRadius: 3,
                  ),
                  BoxShadow(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.02)
                        : Colors.white.withValues(alpha: 0.90),
                    offset: const Offset(-1.5, -1.5),
                    blurRadius: 2.5,
                  ),
                ]
              : null,
          border: isSelected
              ? Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.white.withValues(alpha: 0.85),
                  width: 1.0,
                )
              : null,
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
      ProductsController ctrl, ColorScheme colorScheme, bool isDark) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return ctrl.brands
            .where((b) => b.displayName
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()))
            .map((b) => b.displayName);
      },
      onSelected: (String selection) {
        ctrl.textcontrollers['brand']!.text = selection;
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        if (textEditingController.text.isEmpty &&
            ctrl.textcontrollers['brand']!.text.isNotEmpty) {
          textEditingController.text = ctrl.textcontrollers['brand']!.text;
        }

        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (_) => onFieldSubmitted(),
          onChanged: (val) {
            ctrl.textcontrollers['brand']!.text = val;
          },
          decoration: InputDecoration(
            labelText: 'العلامة التجارية (البراند)',
            hintText: 'اختر أو اكتب براند جديد...',
            prefixIcon: Icon(
              Icons.verified_outlined,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
            filled: true,
            fillColor: isDark
                ? colorScheme.surfaceContainerLowest.withValues(alpha: 0.5)
                : colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : colorScheme.outlineVariant.withValues(alpha: 0.5),
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
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 280,
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Color.lerp(colorScheme.surfaceContainerHigh,
                            Colors.white, 0.02)!,
                        Color.lerp(colorScheme.surfaceContainerHigh,
                            Colors.black, 0.10)!,
                      ]
                    : [
                        Colors.white,
                        Color.lerp(colorScheme.surfaceContainerLow,
                            Colors.black, 0.035)!,
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.45)
                      : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
                  offset: const Offset(2, 3),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.02)
                      : Colors.white.withValues(alpha: 0.90),
                  offset: const Offset(-1.5, -1.5),
                  blurRadius: 4,
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 6),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.business_rounded,
                      color: colorScheme.primary,
                      size: 18,
                    ),
                    title: Text(
                      option,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
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
  }
}
