import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/category_picker_sheet.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/flavor_multi_select.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_size_selector.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_variant_manager.dart';

// ── Card Container للسكاشن (Material 3 Card.outlined) ─────────────────────────
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card.outlined(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1.2),
      ),
      color: colorScheme.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: colorScheme.onPrimaryContainer,
                size: 22,
              ),
            ),
            title: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: subtitle != null
                ? Text(subtitle!, style: theme.textTheme.bodySmall)
                : null,
            trailing: trailing,
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ── Material 3 Form Input (Pure TextFormField) ────────────────────────────────
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
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
      maxLines: maxLines,
      validator: isRequired
          ? (val) {
              if (val == null || val.trim().isEmpty) {
                return 'هذا الحقل مطلوب';
              }
              return null;
            }
          : null,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        suffixText: suffixText,
      ),
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
  String _selectedLang = 'ar';

  @override
  Widget build(BuildContext context) {
    final ctrl = widget.controller;

    return FormSectionCard(
      title: 'البيانات الأساسية',
      subtitle: 'الاسم، العلامة التجارية، التصنيف والوصف',
      icon: Icons.edit_note_rounded,
      trailing: SegmentedButton<String>(
        segments: const [
          ButtonSegment<String>(
            value: 'ar',
            label: Text('العربية 🇸🇦'),
            icon: Icon(Icons.language_rounded, size: 16),
          ),
          ButtonSegment<String>(
            value: 'en',
            label: Text('English 🇬🇧'),
            icon: Icon(Icons.translate_rounded, size: 16),
          ),
        ],
        selected: {_selectedLang},
        onSelectionChanged: (newSelection) {
          setState(() => _selectedLang = newSelection.first);
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language-specific Name and Description
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _selectedLang == 'ar'
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

  Widget _buildBrandAutocomplete(ProductsController ctrl) {
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
          decoration: const InputDecoration(
            labelText: 'العلامة التجارية (البراند)',
            hintText: 'اختر أو اكتب براند جديد...',
            prefixIcon: Icon(Icons.verified_outlined, size: 20),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final theme = Theme.of(context);
        return Align(
          alignment: Alignment.topRight,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.surfaceContainerHigh,
            child: Container(
              width: 280,
              margin: const EdgeInsets.only(top: 8),
              constraints: const BoxConstraints(maxHeight: 220),
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
                      color: theme.colorScheme.primary,
                      size: 18,
                    ),
                    title: Text(option),
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

// ── 2. قسم التسعير والمخزون ──────────────────────────────────────────────────
class ProductPricingStockSection extends StatelessWidget {
  final ProductsController controller;

  const ProductPricingStockSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormSectionCard(
      title: 'التسعير والمخزون',
      subtitle: 'الأسعار، الخصومات، المخزون، والقيم الغذائية',
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
                  Card.filled(
                    margin: EdgeInsets.zero,
                    color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: theme.colorScheme.onSecondaryContainer,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'تم تفعيل تسعير مخصص حسب الأحجام أدناه:',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.productSizes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
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
                          Card.outlined(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: Text(
                                size.size,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ModernFormField(
                              controller: priceCtrl,
                              label: 'سعر (${size.size})',
                              icon: Icons.price_change_outlined,
                              isNumber: true,
                              suffixText: 'ر.س',
                            ),
                          ),
                          const SizedBox(width: 12),
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
                  hint: '50',
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

// ── 3. قسم صور المنتج (Material 3) ───────────────────────────────────────────
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
      subtitle: 'ارفع صور واضحة (الصورة الأولى هي صورة الغلاف)',
      icon: Icons.photo_library_outlined,
      trailing: TextButton.icon(
        onPressed: () => _showAddUrlDialog(context),
        icon: const Icon(Icons.link_rounded, size: 18),
        label: const Text('رابط URL'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrls.isEmpty)
            _buildEmptyUploadZone(context)
          else
            Column(
              children: [
                SizedBox(
                  height: 155,
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
                      final theme = Theme.of(context);

                      return Card.outlined(
                        key: ValueKey('img_${url}_$index'),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isCover
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outlineVariant,
                            width: isCover ? 2 : 1,
                          ),
                        ),
                        child: SizedBox(
                          width: 130,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                !url.startsWith('http')
                                    ? Image.file(File(url), fit: BoxFit.cover)
                                    : CachedNetworkImage(
                                        imageUrl: url,
                                        fit: BoxFit.cover,
                                        placeholder: (_, _) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (_, _, _) => const Center(
                                          child: Icon(Icons.broken_image_rounded),
                                        ),
                                      ),

                                // Cover Badge
                                if (isCover)
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'الغلاف',
                                        style: TextStyle(
                                          color: theme.colorScheme.onPrimary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                // Delete Button
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: IconButton.filledTonal(
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.black54,
                                      foregroundColor: Colors.white,
                                    ),
                                    iconSize: 16,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 32,
                                      minHeight: 32,
                                    ),
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () => onRemoveImage(index),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '💡 يمكنك سحب الصور لإعادة ترتيبها وتحديد صورة الغلاف.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyUploadZone(BuildContext context) {
    final theme = Theme.of(context);
    return Card.outlined(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _pickAndUpload(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 36),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'انقر هنا لرفع صور المنتج من جهازك',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'PNG, JPG حتى 5 ميجابايت',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddCard(BuildContext context) {
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _pickAndUpload(context),
        child: const SizedBox(
          width: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, size: 28),
              SizedBox(height: 8),
              Text('إضافة صورة', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
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
      loadingWidget: const Center(child: CircularProgressIndicator()),
    );
  }

  void _showAddUrlDialog(BuildContext context) {
    final textCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة رابط صورة خارجي'),
        content: TextField(
          controller: textCtrl,
          decoration: const InputDecoration(
            hintText: 'https://example.com/image.jpg',
            prefixIcon: Icon(Icons.link),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              if (textCtrl.text.trim().isNotEmpty) {
                onAddImageUrl(textCtrl.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة الصورة'),
          ),
        ],
      ),
    );
  }
}

// ── 4. قسم الخيارات والتنويعات (Material 3) ───────────────────────────────────
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
          const SizedBox(height: 18),

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

// ── 5. قسم الإعدادات والنشر (Material 3 SwitchListTile) ───────────────────────
class ProductSettingsSection extends StatelessWidget {
  final ProductsController controller;

  const ProductSettingsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      title: 'إعدادات النشر والعرض',
      subtitle: 'التحكم في ظهور المنتج وتفضيلاته بالمتجر',
      icon: Icons.toggle_on_outlined,
      child: Column(
        children: [
          _buildSwitchCard(
            context: context,
            title: 'تفعيل المنتج (Active)',
            subtitle: 'عند التفعيل يظهر المنتج لجميع المستخدمين في التطبيق',
            icon: Icons.check_circle_outline_rounded,
            rxValue: controller.isActive,
          ),
          const SizedBox(height: 12),
          _buildSwitchCard(
            context: context,
            title: 'منتج مميز (Featured)',
            subtitle: 'يظهر المنتج في الأقسام والبانرات الرئيسية بالصفحة الأولى',
            icon: Icons.star_outline_rounded,
            rxValue: controller.isFeatured,
          ),
          const SizedBox(height: 12),
          _buildSwitchCard(
            context: context,
            title: 'خلفية بيضاء (White Background)',
            subtitle: 'عرض صورة المنتج بخلفية بيضاء ناصعة في واجهة العرض',
            icon: Icons.aspect_ratio_rounded,
            rxValue: controller.isBackgroundWhite,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required RxBool rxValue,
  }) {
    final theme = Theme.of(context);

    return Obx(() {
      final isVal = rxValue.value;
      return Card.outlined(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isVal
                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                : theme.colorScheme.outlineVariant,
          ),
        ),
        color: isVal
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.15)
            : theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
        child: SwitchListTile(
          value: isVal,
          onChanged: (v) => rxValue.value = v,
          secondary: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isVal
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isVal
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(
            subtitle,
            style: theme.textTheme.bodySmall,
          ),
        ),
      );
    });
  }
}

// ── 6. شريط الإجراءات السفلي (Material 3 BottomAppBar) ─────────────────────────
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
    final theme = Theme.of(context);

    return BottomAppBar(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      elevation: 3,
      color: theme.colorScheme.surfaceContainer,
      child: Row(
        children: [
          // Status Chip
          Obx(
            () => FilterChip(
              avatar: Icon(
                controller.isActive.value
                    ? Icons.check_circle_rounded
                    : Icons.pause_circle_outline_rounded,
                size: 16,
              ),
              label: Text(
                controller.isActive.value ? 'المنتج مفعّل' : 'مسودة غير مفعّلة',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              selected: controller.isActive.value,
              onSelected: (val) => controller.isActive.value = val,
            ),
          ),
          const Spacer(),

          // Cancel
          OutlinedButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          const SizedBox(width: 12),

          // Save FilledButton
          Obx(
            () => FilledButton.icon(
              onPressed:
                  controller.isLoading.value || controller.isSaving.value
                      ? null
                      : onSave,
              icon: controller.isSaving.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline_rounded, size: 20),
              label: Text(
                controller.isSaving.value
                    ? 'جاري الحفظ...'
                    : (isEditing ? 'تحديث ونشر المنتج' : 'حفظ وإضافة المنتج'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
