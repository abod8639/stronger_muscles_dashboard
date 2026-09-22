import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/category_picker_sheet.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/flavor_multi_select.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_size_selector.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_variant_manager.dart';

// ── Card Container للسكاشن ───────────────────────────────────────────────────
class FormSectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const FormSectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsExtended.cardBg.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.25),
                        AppColors.primary.withValues(alpha: 0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          Padding(
            padding: const EdgeInsets.all(18),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ── Modern Form Input ────────────────────────────────────────────────────────
class ModernFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData icon;
  final bool isNumber;
  final bool isRequired;
  final int maxLines;
  final String? suffixText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;

  const ModernFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    required this.icon,
    this.isNumber = false,
    this.isRequired = false,
    this.maxLines = 1,
    this.suffixText,
    this.onChanged,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.redAccent, fontSize: 14),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
            keyboardType: isNumber
                ? const TextInputType.numberWithOptions(decimal: true)
                : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            validator: isRequired
                ? (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  }
                : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
              suffixText: suffixText,
              suffixStyle: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── 1. قسم المعلومات الأساسية ────────────────────────────────────────────────
class ProductBasicInfoSection extends StatefulWidget {
  final ProductsController controller;
  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  const ProductBasicInfoSection({
    super.key,
    required this.controller,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  State<ProductBasicInfoSection> createState() =>
      _ProductBasicInfoSectionState();
}

class _ProductBasicInfoSectionState extends State<ProductBasicInfoSection> {
  int _selectedLangIndex = 0; // 0: العربية, 1: English

  @override
  Widget build(BuildContext context) {
    final ctrl = widget.controller;

    return FormSectionCard(
      title: 'البيانات الأساسية',
      subtitle: 'الاسم، البراند، التصنيف والوصف التفصيلي',
      icon: Icons.edit_note_rounded,
      trailing: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLangPill(0, 'العربية 🇸🇦'),
            _buildLangPill(1, 'English 🇬🇧'),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language-specific Name and Description
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _selectedLangIndex == 0
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
                        hint: 'اكتب وصفاً جذاباً وشاملاً للمنتج ومميزاته...',
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
                        hint: 'Provide a detailed description of the product in English...',
                        icon: Icons.description_outlined,
                        maxLines: 4,
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 18),

          // Brand Autocomplete & Category Picker
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand
              Expanded(
                child: _buildBrandAutocomplete(ctrl),
              ),
              const SizedBox(width: 14),
              // Category
              Expanded(
                child: CategoryPickerField(
                  categories: ctrl.categories.toList(),
                  selectedId: widget.selectedCategoryId,
                  onSelected: widget.onCategorySelected,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLangPill(int index, String label) {
    final isSelected = _selectedLangIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() => _selectedLangIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandAutocomplete(ProductsController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.verified_outlined, size: 15, color: Colors.white70),
            SizedBox(width: 6),
            Text(
              'العلامة التجارية (البراند)',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Autocomplete<String>(
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

            return Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: TextField(
                controller: textEditingController,
                focusNode: focusNode,
                onSubmitted: (_) => onFieldSubmitted(),
                onChanged: (val) {
                  ctrl.textcontrollers['brand']!.text = val;
                },
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'اختر أو اكتب براند جديد...',
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 13),
                  prefixIcon: Icon(
                    Icons.branding_watermark_outlined,
                    color: Colors.white54,
                    size: 18,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topRight,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 260,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: AppColorsExtended.surfaceDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.business_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        title: Text(
                          option,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ── 2. قسم التسعير والمخزون ──────────────────────────────────────────────────
class ProductPricingStockSection extends StatelessWidget {
  final ProductsController controller;

  const ProductPricingStockSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      title: 'التسعير والمخزون',
      subtitle: 'الأسعار، التخفيضات، المخزون، والقيم الغذائية',
      icon: Icons.payments_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pricing Row
          Obx(() {
            final hasSizes = controller.productSizes.isNotEmpty;
            if (hasSizes) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.info.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.info,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'تم تفعيل تسعير مخصص حسب الأحجام. سيتم تحديد السعر لكل حجم أدناه.',
                            style: TextStyle(
                              color: AppColors.info,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.productSizes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final size = controller.productSizes[i];
                      final priceCtrl =
                          controller.sizePriceControllers[size.size];
                      final discountCtrl =
                          controller.sizeDiscountControllers[size.size];

                      if (priceCtrl == null || discountCtrl == null) {
                        return const SizedBox.shrink();
                      }

                      return Row(
                        children: [
                          Container(
                            width: 80,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Center(
                              child: Text(
                                size.size,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ModernFormField(
                              controller: priceCtrl,
                              label: 'سعر (${size.size})',
                              icon: Icons.price_change_outlined,
                              isNumber: true,
                              suffixText: 'ر.س',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ModernFormField(
                              controller: discountCtrl,
                              label: 'سعر الخصم',
                              icon: Icons.sell_outlined,
                              isNumber: true,
                              suffixText: 'ر.س',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ModernFormField(
                    controller: controller.textcontrollers['price']!,
                    label: 'السعر الأساسي',
                    hint: '0.00',
                    icon: Icons.price_change_outlined,
                    isNumber: true,
                    isRequired: true,
                    suffixText: 'ر.س',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ModernFormField(
                    controller: controller.textcontrollers['discount']!,
                    label: 'سعر الخصم (اختياري)',
                    hint: '0.00',
                    icon: Icons.sell_outlined,
                    isNumber: true,
                    suffixText: 'ر.س',
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 18),

          // Stock & Servings Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ModernFormField(
                  controller: controller.textcontrollers['stock']!,
                  label: 'الكمية في المخزن',
                  hint: 'مثال: 50',
                  icon: Icons.inventory_2_outlined,
                  isNumber: true,
                  isRequired: true,
                  suffixText: 'قطعة',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ModernFormField(
                  controller: controller.textcontrollers['serving']!,
                  label: 'حجم الحصة',
                  hint: 'مثال: 30g',
                  icon: Icons.scale_outlined,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ModernFormField(
                  controller: controller.textcontrollers['sessions']!,
                  label: 'عدد الحصص',
                  hint: 'مثال: 60',
                  icon: Icons.format_list_numbered_rtl_rounded,
                  isNumber: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── 3. قسم صور المنتج ────────────────────────────────────────────────────────
class ProductMediaSection extends StatelessWidget {
  final ProductsController controller;
  final List<String> imageUrls;
  final ValueChanged<String> onAddImageUrl;
  final ValueChanged<int> onRemoveImage;
  final Function(int oldIdx, int newIdx) onReorderImage;

  const ProductMediaSection({
    super.key,
    required this.controller,
    required this.imageUrls,
    required this.onAddImageUrl,
    required this.onRemoveImage,
    required this.onReorderImage,
  });

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      title: 'معرض صور المنتج',
      subtitle: 'ارفع صور واضحة (أول صورة تُعد صورة الغلاف الرئيسية)',
      icon: Icons.photo_library_outlined,
      trailing: TextButton.icon(
        onPressed: () => _showAddUrlDialog(context),
        icon: const Icon(Icons.link_rounded, size: 18, color: AppColors.info),
        label: const Text(
          'إضافة رابط URL',
          style: TextStyle(color: AppColors.info, fontSize: 13),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gallery Grid / Reorderable
          if (imageUrls.isEmpty)
            _buildEmptyUploadZone(context)
          else
            Column(
              children: [
                SizedBox(
                  height: 150,
                  child: ReorderableListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length + 1,
                    onReorderItem: (oldIdx, newIdx) {
                      if (oldIdx < imageUrls.length &&
                          newIdx <= imageUrls.length) {
                        onReorderImage(oldIdx, newIdx);
                      }
                    },
                    itemBuilder: (context, index) {
                      if (index == imageUrls.length) {
                        return Container(
                          key: const ValueKey('add_button'),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          child: _buildAddCard(context),
                        );
                      }

                      final url = imageUrls[index];
                      final isCover = index == 0;

                      return Container(
                        key: ValueKey('img_${url}_$index'),
                        width: 130,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCover
                                ? AppColors.primary
                                : Colors.white.withValues(alpha: 0.15),
                            width: isCover ? 2 : 1,
                          ),
                          boxShadow: [
                            if (isCover)
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                              ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              !url.startsWith('http')
                                  ? Image.file(File(url), fit: BoxFit.cover)
                                  : CachedNetworkImage(
                                      imageUrl: url,
                                      fit: BoxFit.cover,
                                      placeholder: (_, _) => const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (_, __, ___) => const Center(
                                        child: Icon(
                                          Icons.broken_image_rounded,
                                          color: Colors.white38,
                                        ),
                                      ),
                                    ),

                              // Cover Badge
                              if (isCover)
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star_rounded,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 2),
                                        Text(
                                          'الغلاف',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              // Delete Button
                              Positioned(
                                top: 8,
                                right: 8,
                                child: InkWell(
                                  onTap: () => onRemoveImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black87,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.redAccent,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '💡 يمكنك سحب الصور لإعادة ترتيبها وتغيير صورة الغلاف.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyUploadZone(BuildContext context) {
    return InkWell(
      onTap: () => _pickAndUpload(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'انقر هنا لرفع صور المنتج من جهازك',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'PNG, JPG حتى 5 ميجابايت',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCard(BuildContext context) {
    return InkWell(
      onTap: () => _pickAndUpload(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 110,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.25),
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 24),
            SizedBox(height: 8),
            Text(
              'إضافة صورة',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUpload(BuildContext context) async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;

    Get.showOverlay(
      asyncFunction: () async {
        final url = await controller.uploadImage(image.path);
        if (url != null) onAddImageUrl(url);
      },
      loadingWidget: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  void _showAddUrlDialog(BuildContext context) {
    final textCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColorsExtended.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'إضافة رابط صورة خارجي',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: TextField(
          controller: textCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'https://example.com/image.jpg',
            hintStyle: TextStyle(color: Colors.white30),
            prefixIcon: Icon(Icons.link, color: AppColors.info),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (textCtrl.text.trim().isNotEmpty) {
                onAddImageUrl(textCtrl.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة الصورة', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── 4. قسم الخيارات والتنويعات ───────────────────────────────────────────────
class ProductVariantsSection extends StatelessWidget {
  final ProductsController controller;

  const ProductVariantsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      title: 'الأحجام والنكهات والتنويعات',
      subtitle: 'تحديد خيارات المنتج وربطها برمز SKU الخاص بالمخزن',
      icon: Icons.tune_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sizes Selector
          Obx(
            () => ProductSizeSelector(
              selectedSizes: controller.productSizes.toList(),
              selectedIndex: controller.selectedSizeIndex.value,
              onSelectSize: controller.selectSize,
              defaultPrice: double.tryParse(
                    controller.textcontrollers['price']?.text ?? '0',
                  ) ??
                  0.0,
              onSelectionChanged: (newList) =>
                  controller.productSizes.assignAll(newList),
            ),
          ),
          const SizedBox(height: 16),

          // Flavors Selector
          Obx(
            () => ProductFlavorSelector(
              selectedFlavors: controller.productFlavors.toList(),
              onSelectionChanged: (newList) =>
                  controller.productFlavors.assignAll(newList),
            ),
          ),
          const SizedBox(height: 20),

          // SKU Variants Manager
          ProductVariantManager(controller: controller),
        ],
      ),
    );
  }
}

// ── 5. قسم الإعدادات والنشر ──────────────────────────────────────────────────
class ProductSettingsSection extends StatelessWidget {
  final ProductsController controller;

  const ProductSettingsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      title: 'إعدادات النشر والعرض',
      subtitle: 'التحكم في ظهور المنتج وتفضيلات العرض بالمتجر',
      icon: Icons.toggle_on_outlined,
      child: Column(
        children: [
          _buildToggleTile(
            title: 'تفعيل المنتج (Active)',
            subtitle: 'عند التفعيل يظهر المنتج لجميع المستخدمين في التطبيق',
            icon: Icons.check_circle_outline_rounded,
            rxValue: controller.isActive,
            activeColor: AppColors.success,
          ),
          const SizedBox(height: 12),
          _buildToggleTile(
            title: 'منتج مميز (Featured)',
            subtitle: 'يظهر المنتج في البانرات الرئيسية والصفحة الأولى',
            icon: Icons.star_outline_rounded,
            rxValue: controller.isFeatured,
            activeColor: AppColors.warning,
          ),
          const SizedBox(height: 12),
          _buildToggleTile(
            title: 'خلفية بيضاء (White Background)',
            subtitle: 'عرض صورة المنتج داخل إطار بخلفية بيضاء ناصعة',
            icon: Icons.aspect_ratio_rounded,
            rxValue: controller.isBackgroundWhite,
            activeColor: AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required RxBool rxValue,
    required Color activeColor,
  }) {
    return Obx(() {
      final isVal = rxValue.value;
      return InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => rxValue.value = !isVal,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isVal
                ? activeColor.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isVal
                  ? activeColor.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.08),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isVal
                      ? activeColor.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isVal ? activeColor : Colors.white54,
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isVal ? Colors.white : Colors.white70,
                        fontWeight: isVal ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isVal,
                onChanged: (v) => rxValue.value = v,
                activeColor: activeColor,
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ── 6. شريط الإجراءات السفلي الثابت (Sticky Bottom Bar) ─────────────────────────
class ProductStickyBottomBar extends StatelessWidget {
  final ProductsController controller;
  final VoidCallback onSave;
  final bool isEditing;

  const ProductStickyBottomBar({
    super.key,
    required this.controller,
    required this.onSave,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: AppColorsExtended.surfaceDark.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Status Preview
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: controller.isActive.value
                      ? AppColors.success.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: controller.isActive.value
                        ? AppColors.success.withValues(alpha: 0.3)
                        : Colors.white12,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 4,
                      backgroundColor: controller.isActive.value
                          ? AppColors.success
                          : Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      controller.isActive.value ? 'المنتج مفعّل' : 'مسودة غير مفعّلة',
                      style: TextStyle(
                        color: controller.isActive.value
                            ? AppColors.success
                            : Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // Cancel Button
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            const SizedBox(width: 12),

            // Save Button
            Obx(
              () => ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                  shadowColor: AppColors.primary.withValues(alpha: 0.4),
                ),
                onPressed:
                    controller.isLoading.value || controller.isSaving.value
                        ? null
                        : onSave,
                icon: controller.isSaving.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: Text(
                  controller.isSaving.value
                      ? 'جاري الحفظ...'
                      : (isEditing ? 'تحديث ونشر المنتج' : 'حفظ وإضافة المنتج'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
