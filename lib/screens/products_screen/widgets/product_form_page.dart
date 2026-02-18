import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/screens/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/flavor_multi_select.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/availability_switch.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/category_tree_selector.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/product_size_selector.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/product_form_mixin.dart';
import '../../components/image_gallery_editor.dart';
import '../../../controllers/products_controller.dart';
import '../../../models/product_model.dart';
import '../../../config/theme.dart';

class ProductFormPage extends StatefulWidget {
  final ProductModel? product;
  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage>
    with ProductFormMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  final ProductsController controller = Get.find<ProductsController>();

  @override
  ProductModel? get product => widget.product;

  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    initializeProductFields();
    controller.imageUrls.assignAll(getInitialImageUrls());
    _selectedCategoryId = getInitialCategoryId();
  }

  @override
  void dispose() {
    disposeProductControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'إضافة منتج جديد' : 'تعديل البيانات',
        ),
        actions: [
          IconButton(
            onPressed: () => controller.saveProduct(
              existingProduct: widget.product,
              formKey: _formKey,
              categoryId: _selectedCategoryId ?? '',
              productImages: controller.imageUrls.toList(),
            ),
            icon: const Icon(Icons.save_as_rounded, color: AppColors.primary),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          // استخدام ListView بدلاً من SingleChild لسهولة التحكم
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            _buildImageSection(),
            const SizedBox(height: 20),
            _buildBasicInfoSection(),
            const SizedBox(height: 20),
            _buildCategorySection(),
            const SizedBox(height: 20),
            _buildInventorySection(),
            const SizedBox(height: 20),
            _buildDescriptionSection(),
            const SizedBox(height: 32),
            _buildSubmitButton(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // --- UI Sections ---

  Widget _buildImageSection() {
    return _buildCardWrapper(
      title: 'معرض الصور',
      icon: Icons.image_outlined,
      child: Obx(
        () => ImageGalleryEditor(
          imageUrls: controller.imageUrls.toList(),
          onAddUrl: (url) => controller.imageUrls.add(url),
          onRemove: (index) => controller.imageUrls.removeAt(index),
          onPickImage: _handleImagePick,
          onReorder: (oldIdx, newIdx) {
            if (newIdx > oldIdx) newIdx -= 1;
            final item = controller.imageUrls.removeAt(oldIdx);
            controller.imageUrls.insert(newIdx, item);
          },
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildCardWrapper(
      title: 'التسعير والمعلومات',
      icon: Icons.monetization_on_outlined,
            child: Column(
        children: [
          buildModernTextField(
            controller.textcontrollers['name_ar']!,
            'اسم المنتج (AR)',
            Icons.drive_file_rename_outline,
          ),
          const SizedBox(height: 12),
          buildModernTextField(
            controller.textcontrollers['name_en']!,
            'Product Name (EN)',
            Icons.translate,
          ),
          const SizedBox(height: 16),
          Obx(() {
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
          }),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return _buildCardWrapper(
      title: 'التصنيف والخصائص',
      icon: Icons.category_outlined,
      child: Column(
        children: [
          Obx(() => CategoryTreeSelector(
            categories: controller.categories.toList(),
            selectedId: _selectedCategoryId,
            onSelected: (id) => setState(() => _selectedCategoryId = id),
          )),
          const SizedBox(height: 20),
          Obx(
            () => ProductFlavorSelector(
              selectedFlavors: controller.productFlavors.toList(),
              onSelectionChanged: (list) =>
                  controller.productFlavors.assignAll(list),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => ProductSizeSelector(
              selectedSizes: controller.productSizes.toList(),
              selectedIndex: controller.selectedSizeIndex.value,
              onSelectSize: (index) => controller.selectSize(index),
              defaultPrice: double.tryParse(
                      controller.textcontrollers['price']?.text ?? '0') ??
                  0.0,
              onSelectionChanged: (list) =>
                  controller.productSizes.assignAll(list),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySection() {
    return _buildCardWrapper(
      title: 'المخزون والبيانات الفنية',
      icon: Icons.inventory_2_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: buildModernTextField(
                  controller.textcontrollers['stock']!,
                  'الكمية المتاحة',
                  Icons.numbers,
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
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: buildModernTextField(
                  controller.textcontrollers['serving']!,
                  'حجم الحصة',
                  Icons.fitness_center,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildModernTextField(
                  controller.textcontrollers['sessions']!,
                  'إجمالي الحصص',
                  Icons.reorder,
                  isNumber: true,
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          AvailabilitySwitch(
            title: "منتج مميز (Featured)",
            isAvailable: controller.isFeatured,
            onChanged: (val) => controller.isFeatured.value = val,
          ),

          AvailabilitySwitch(
            title: "خلفية بيضاء (White Background)",
            isAvailable: controller.isBackgroundWhite,
            onChanged: (val) => controller.isBackgroundWhite.value = val,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return _buildCardWrapper(
      title: 'الوصف التفصيلي',
      icon: Icons.description_outlined,
      child:      Column(
        children: [
          buildModernTextField(
            controller.textcontrollers['desc_ar']!,
            'الوصف (AR)',
            Icons.text_snippet_outlined,
            maxLines: 4,
          ),
          const SizedBox(height: 12),
          buildModernTextField(
            controller.textcontrollers['desc_en']!,
            'Description (EN)',
            Icons.translate,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  // --- Helpers & Logic ---

  Widget _buildCardWrapper({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.primary.withAlpha(200),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            // child: Divider(thickness: 0.5),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: () => controller.isLoading.value
            ? null
            : controller.saveProduct(
                existingProduct: widget.product,
                formKey: _formKey,
                categoryId: _selectedCategoryId ?? '',
                productImages: controller.imageUrls.toList(),
              ),
        child: controller.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'حفظ ونشر التعديلات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _handleImagePick() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      final url = await controller.uploadImage(image.path);
      if (url != null) controller.imageUrls.add(url);
    }
  }
}
