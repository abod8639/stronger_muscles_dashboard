import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/data/models/product_model.dart';
import 'package:stronger_muscles_dashboard/screens/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/screens/components/image_gallery_editor.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/availability_switch.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/category_tree_selector.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/flavor_multi_select.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/product_size_selector.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/product_variant_manager.dart';

class ProductFormBody extends StatefulWidget {
  final ProductsController controller;

  /// قائمة روابط الصور — يمكن إدارتها من الخارج (Sheet) أو من الـ Controller (Page)
  final List<String> imageUrls;
  final void Function(String url) onAddImageUrl;
  final void Function(int index) onRemoveImage;
  final void Function(int oldIdx, int newIdx) onReorderImage;

  /// الـ Category المحدد حالياً
  final String? selectedCategoryId;
  final void Function(String id) onCategorySelected;

  const ProductFormBody({
    super.key,
    required this.controller,
    required this.imageUrls,
    required this.onAddImageUrl,
    required this.onRemoveImage,
    required this.onReorderImage,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  State<ProductFormBody> createState() => _ProductFormBodyState();
}

class _ProductFormBodyState extends State<ProductFormBody> {
  ProductsController get ctrl => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── الصور ────────────────────────────────────────────────────────
        _buildImageSection(),
        const SizedBox(height: 20),

        // ── الأسماء ───────────────────────────────────────────────────────
        _buildNamesSection(),
        const SizedBox(height: 16),

        // ── المخزون والعلامة التجارية ─────────────────────────────────────
        _buildStockAndBrandRow(),
        const SizedBox(height: 16),

        // ── التسعير (يتكيّف مع الأحجام) ──────────────────────────────────
        _buildPricingSection(),
        const SizedBox(height: 24),

        // ── تنويعات المنتج (SKU) ──────────────────────────────────────────
        ProductVariantManager(controller: ctrl),
        const SizedBox(height: 20),

        // ── الأحجام والنكهات والفئات ──────────────────────────────────────
        _buildSelectorsSection(),
        const SizedBox(height: 16),

        // ── القيم الغذائية ────────────────────────────────────────────────
        _buildNutritionalRow(),
        const SizedBox(height: 16),

        // ── الوصف ────────────────────────────────────────────────────────
        _buildDescriptionSection(),
        const SizedBox(height: 20),

        // ── مفاتيح الإعدادات ─────────────────────────────────────────────
        _buildSwitches(),
      ],
    );
  }

  // ── Image Section ──────────────────────────────────────────────────────────

  Widget _buildImageSection() {
    return ImageGalleryEditor(
      imageUrls: widget.imageUrls,
      onAddUrl: widget.onAddImageUrl,
      onRemove: widget.onRemoveImage,
      onPickImage: _handleImagePick,
      onReorder: (oldIdx, newIdx) {
        if (newIdx > oldIdx) newIdx -= 1;
        widget.onReorderImage(oldIdx, newIdx);
      },
    );
  }

  // ── Names ──────────────────────────────────────────────────────────────────

  Widget _buildNamesSection() {
    return Column(
      children: [
        buildModernTextField(
          ctrl.textcontrollers['name_ar']!,
          'اسم المنتج (AR)',
          Icons.shopping_bag_outlined,
        ),
        const SizedBox(height: 12),
        buildModernTextField(
          ctrl.textcontrollers['name_en']!,
          'Product Name (EN)',
          Icons.translate,
        ),
      ],
    );
  }

  // ── Stock & Brand ──────────────────────────────────────────────────────────

  Widget _buildStockAndBrandRow() {
    return Row(
      children: [
        Expanded(
          child: buildModernTextField(
            ctrl.textcontrollers['stock']!,
            'الكمية المتاحة',
            Icons.inventory_2_outlined,
            isNumber: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildModernTextField(
            ctrl.textcontrollers['brand']!,
            'العلامة التجارية',
            Icons.verified_outlined,
          ),
        ),
      ],
    );
  }

  // ── Pricing (adapts when sizes exist) ─────────────────────────────────────

  Widget _buildPricingSection() {
    return Obx(() {
      if (ctrl.productSizes.isEmpty) {
        return Row(
          children: [
            Expanded(
              child: buildModernTextField(
                ctrl.textcontrollers['price']!,
                'السعر الأساسي',
                Icons.payments_outlined,
                isNumber: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildModernTextField(
                ctrl.textcontrollers['discount']!,
                'سعر الخصم',
                Icons.sell_outlined,
                isNumber: true,
              ),
            ),
          ],
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ctrl.productSizes.length,
        itemBuilder: (context, index) {
          final size = ctrl.productSizes[index];
          final priceCtrl = ctrl.sizePriceControllers[size.size];
          final discountCtrl = ctrl.sizeDiscountControllers[size.size];

          if (priceCtrl == null || discountCtrl == null) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: buildModernTextField(
                    priceCtrl,
                    'سعر (${size.size})',
                    Icons.straighten,
                    isNumber: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildModernTextField(
                    discountCtrl,
                    'خصم (${size.size})',
                    Icons.sell_outlined,
                    isNumber: true,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  // ── Selectors: Sizes, Flavors, Category ───────────────────────────────────

  Widget _buildSelectorsSection() {
    return Column(
      children: [
        Obx(
          () => ProductSizeSelector(
            selectedSizes: ctrl.productSizes.toList(),
            selectedIndex: ctrl.selectedSizeIndex.value,
            onSelectSize: ctrl.selectSize,
            defaultPrice:
                double.tryParse(ctrl.textcontrollers['price']?.text ?? '0') ??
                0.0,
            onSelectionChanged: (List<ProductSize> newList) =>
                ctrl.productSizes.assignAll(newList),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => ProductFlavorSelector(
            selectedFlavors: ctrl.productFlavors.toList(),
            onSelectionChanged: (List<String> newList) =>
                ctrl.productFlavors.assignAll(newList),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => CategoryTreeSelector(
            categories: ctrl.categories.toList(),
            selectedId: widget.selectedCategoryId,
            onSelected: widget.onCategorySelected,
          ),
        ),
      ],
    );
  }

  // ── Nutritional ────────────────────────────────────────────────────────────

  Widget _buildNutritionalRow() {
    return Row(
      children: [
        Expanded(
          child: buildModernTextField(
            ctrl.textcontrollers['serving']!,
            'حجم الحصة (جرام)',
            Icons.scale_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildModernTextField(
            ctrl.textcontrollers['sessions']!,
            'عدد الحصص',
            Icons.format_list_numbered_rtl_outlined,
            isNumber: true,
          ),
        ),
      ],
    );
  }

  // ── Description ────────────────────────────────────────────────────────────

  Widget _buildDescriptionSection() {
    return Column(
      children: [
        buildModernTextField(
          ctrl.textcontrollers['desc_ar']!,
          'وصف المنتج بالتفصيل (AR)',
          Icons.description_outlined,
          maxLines: 4,
        ),
        const SizedBox(height: 12),
        buildModernTextField(
          ctrl.textcontrollers['desc_en']!,
          'Detailed Description (EN)',
          Icons.translate,
          maxLines: 4,
        ),
      ],
    );
  }

  // ── Switches ───────────────────────────────────────────────────────────────

  Widget _buildSwitches() {
    return Column(
      children: [
        AvailabilitySwitch(
          title: 'منتج مميز (Featured)',
          isAvailable: ctrl.isFeatured,
          onChanged: (val) => ctrl.isFeatured.value = val,
        ),
        const SizedBox(height: 8),
        AvailabilitySwitch(
          title: 'خلفية بيضاء (White Background)',
          isAvailable: ctrl.isBackgroundWhite,
          onChanged: (val) => ctrl.isBackgroundWhite.value = val,
        ),
      ],
    );
  }

  // ── Image Pick Helper ──────────────────────────────────────────────────────

  Future<void> _handleImagePick() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;

    Get.showOverlay(
      asyncFunction: () async {
        final url = await ctrl.uploadImage(image.path);
        if (url != null) widget.onAddImageUrl(url);
      },
      loadingWidget: const Center(child: CircularProgressIndicator()),
    );
  }
}
