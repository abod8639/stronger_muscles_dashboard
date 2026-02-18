import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/screens/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/screens/components/image_gallery_editor.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/models/product_model.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/flavor_multi_select.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/availability_switch.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/category_tree_selector.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/product_size_selector.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/product_variant_manager.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/product_form_mixin.dart';

class ProductFormSheet extends StatefulWidget {
  final ProductModel? product;
  const ProductFormSheet({super.key, this.product});

  @override
  State<ProductFormSheet> createState() => ProductFormSheetState();
}

class ProductFormSheetState extends State<ProductFormSheet>
    with ProductFormMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  final ProductsController controller = Get.find<ProductsController>();

  @override
  ProductModel? get product => widget.product;

  String? selectedCategoryId;
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    initializeProductFields();
    imageUrls = getInitialImageUrls();
    selectedCategoryId = getInitialCategoryId();
  }

  @override
  void dispose() {
    disposeProductControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveLayout responsive = context.responsive;
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: AppColorsExtended.darkBg,
      child: GlassContainer(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            _buildDragHandle(),
            _buildHeader(responsive),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildImageSection(),
                      const SizedBox(height: 24),
                      _buildBasicInfoSection(responsive),
                      const SizedBox(height: 16),
                      _buildStockAndBrandSection(responsive),
                      const SizedBox(height: 16),
                      _buildPricingSection(responsive),


                      const SizedBox(height: 24),
                      ProductVariantManager(controller: controller),
                      const SizedBox(height: 16),
                      _buildSelectorsSection(),
                      
                      const SizedBox(height: 16),
                      _buildNutritionalSection(responsive),
                      const SizedBox(height: 16),
                      _buildDescriptionSection(controller),

                      const SizedBox(height: 24),
                      AvailabilitySwitch(
                        title: "Featured",
                        onChanged: (value) {
                          controller.isFeatured.value = value;
                        },
                        isAvailable: controller.isFeatured,
                      ),
                      const SizedBox(height: 24),
                      AvailabilitySwitch(
                        onChanged: (value) {
                          controller.isBackgroundWhite.value = value;
                        },
                        title: "Background White",
                        isAvailable: controller.isBackgroundWhite,
                      ),
                      const SizedBox(height: 100), // مساحة للزر بالأسفل
                    ],
                  ),
                ),
              ),
            ),
            _buildSubmitButton(responsive),
          ],
        ),
      ),
    );
  }

  // --- مكونات الواجهة الصغيرة ---

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 50,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildHeader(ResponsiveLayout responsive) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.product == null ? 'إضافة منتج جديد' : 'تعديل المنتج',
            style: TextStyle(
              fontSize: responsive.getTitleFontSize(),
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return ImageGalleryEditor(
      imageUrls: imageUrls,
      onAddUrl: (url) => setState(() => imageUrls.add(url)),
      onRemove: (index) => setState(() => imageUrls.removeAt(index)),
      onPickImage: _handleImagePick,
      onReorder: (oldIdx, newIdx) {
        setState(() {
          if (newIdx > oldIdx) newIdx -= 1;
          imageUrls.insert(newIdx, imageUrls.removeAt(oldIdx));
        });
      },
    );
  }

  Widget _buildBasicInfoSection(ResponsiveLayout responsive) {
    return Column(
      children: [
        buildModernTextField(
          controller.textcontrollers['name_ar']!,
          'اسم المنتج (AR)',
          Icons.shopping_bag_outlined,
        ),
        const SizedBox(height: 12),
        buildModernTextField(
          controller.textcontrollers['name_en']!,
          'Product Name (EN)',
          Icons.translate,
        ),
      ],
    );
  }

  Widget _buildPricingSection(ResponsiveLayout responsive) {
    return Obx(() {
      if (controller.productSizes.isEmpty) {
        return Row(
          children: [
            Expanded(
              child: buildModernTextField(
                controller.textcontrollers['price']!,
                'السعر الأساسي',
                Icons.payments_outlined,
                isNumber: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildModernTextField(
                controller.textcontrollers['discount']!,
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
        itemCount: controller.productSizes.length,
        itemBuilder: (context, index) {
          final size = controller.productSizes[index];
          final priceCtrl = controller.sizePriceControllers[size.size];
          final discountCtrl = controller.sizeDiscountControllers[size.size];

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

  Widget _buildStockAndBrandSection(ResponsiveLayout responsive) {
    return Row(
      children: [
        Expanded(
          child: buildModernTextField(
            controller.textcontrollers['stock']!,
            'الكمية متوفرة',
            Icons.inventory_2_outlined,
            isNumber: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildModernTextField(
            controller.textcontrollers['brand']!,
            'العلامة التجارية',
            Icons.verified_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalSection(ResponsiveLayout responsive) {
    return Row(
      children: [
        Expanded(
          child: buildModernTextField(
            controller.textcontrollers['serving']!,
            'حجم الحصة (جرام)',
            Icons.scale_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildModernTextField(
            controller.textcontrollers['sessions']!,
            'عدد الحصص',
            Icons.format_list_numbered_rtl_outlined,
            isNumber: true,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectorsSection() {
    return Column(
      children: [
        Obx(
          () => ProductSizeSelector(
            selectedSizes: controller.productSizes.toList(),
            selectedIndex: controller.selectedSizeIndex.value,
            onSelectSize: (index) => controller.selectSize(index),
            defaultPrice: double.tryParse(
                    controller.textcontrollers['price']?.text ?? '0') ??
                0.0,
            onSelectionChanged: (newList) =>
                controller.productSizes.assignAll(newList),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => ProductFlavorSelector(
            selectedFlavors: controller.productFlavors.toList(),
            onSelectionChanged: (newList) =>
                controller.productFlavors.assignAll(newList),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => CategoryTreeSelector(
          categories: controller.categories.toList(),
          selectedId: selectedCategoryId,
          onSelected: (id) => setState(() => selectedCategoryId = id),
        )),
      ],
    );
  }

  Widget _buildDescriptionSection(ProductsController controller) {
    return Column(
      children: [
        buildModernTextField(
          controller.textcontrollers['desc_ar']!,
          'وصف المنتج بالتفصيل (AR)',
          Icons.description_outlined,
          maxLines: 4,
        ),
        const SizedBox(height: 12),
        buildModernTextField(
          controller.textcontrollers['desc_en']!,
          'Detailed Description (EN)',
          Icons.translate,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(ResponsiveLayout responsive) {
    return GlassContainer(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
          ),
          onPressed: () => controller.saveProduct(
            existingProduct: widget.product,
            formKey: _formKey,
            categoryId: selectedCategoryId!,
            productImages: imageUrls,
          ),
          child: Obx(
            () => controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'حفظ المنتج الآن',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // --- Logic Functions ---

  Future<void> _handleImagePick() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      Get.showOverlay(
        asyncFunction: () async {
          final url = await controller.uploadImage(image.path);
          if (url != null) setState(() => imageUrls.add(url));
        },
        loadingWidget: const Center(child: CircularProgressIndicator()),
      );
    }
  }
}
