import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/components/image_gallery_editor.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/models/product_model.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/FlavorMultiSelect.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/availability_switch.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/buildModernDropdown.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/buildModernTextField.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/product_size_selector.dart';

class ProductFormSheet extends StatefulWidget {
  final ProductModel? product;
  const ProductFormSheet({super.key, this.product});

  @override
  State<ProductFormSheet> createState() => ProductFormSheetState();
}

class ProductFormSheetState extends State<ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final ProductsController controller = Get.find<ProductsController>();

  // Controllers
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController discountPriceController;
  late final TextEditingController stockController;
  late final TextEditingController descriptionController;
  late final TextEditingController brandController;
  late final TextEditingController servingSizeController;
  late final TextEditingController numberOfSessionsController;

  String? selectedCategoryId;
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    nameController = TextEditingController(text: widget.product?.name);
    priceController = TextEditingController(
      text: widget.product?.price.toString(),
    );
    discountPriceController = TextEditingController(
      text: widget.product?.discountPrice?.toString(),
    );
    stockController = TextEditingController(
      text: widget.product?.stockQuantity.toString(),
    );
    descriptionController = TextEditingController(
      text: widget.product?.description,
    );
    brandController = TextEditingController(text: widget.product?.brand);
    servingSizeController = TextEditingController(
      text: widget.product?.servingSize,
    );
    numberOfSessionsController = TextEditingController(
      text: widget.product?.servingsPerContainer.toString(),
    );

    imageUrls = List<String>.from(widget.product?.imageUrls ?? []);
    selectedCategoryId =
        widget.product?.categoryId ??
        (controller.categories.isNotEmpty
            ? controller.categories.first.id
            : null);

    // تحديث قيم GetX
    controller.productFlavors.assignAll(widget.product?.flavor ?? []);
    controller.productSizes.assignAll(widget.product?.size ?? []);
    controller.isFeatured.value = widget.product?.isActive ?? true;
    controller.isBackgroundWhite.value =
        widget.product?.isBackgroundWhite ?? false;
  }

  @override
  void dispose() {
    for (var c in [
      nameController,
      priceController,
      discountPriceController,
      stockController,
      descriptionController,
      brandController,
      servingSizeController,
      numberOfSessionsController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: AppColorsExtended.darkBg.withAlpha(200),
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
                      _buildPricingSection(responsive),
                      const SizedBox(height: 16),
                      _buildStockAndBrandSection(responsive),
                      const SizedBox(height: 16),
                      _buildNutritionalSection(responsive),
      
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
      
                      const SizedBox(height: 16),
                      _buildSelectorsSection(),
                      const SizedBox(height: 16),
                      _buildDescriptionSection(controller),
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
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildHeader(var responsive) {
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

  Widget _buildBasicInfoSection(var responsive) {
    return buildProductFormSheetModernTextField(
      nameController,
      'اسم المنتج الكامل',
      Icons.shopping_bag_outlined,
    );
  }

  Widget _buildPricingSection(var responsive) {
    return Row(
      children: [
        Expanded(
          child: buildProductFormSheetModernTextField(
            priceController,
            'السعر الأساسي',
            Icons.payments_outlined,
            isNumber: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildProductFormSheetModernTextField(
            discountPriceController,
            'سعر الخصم',
            Icons.sell_outlined,
            isNumber: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStockAndBrandSection(var responsive) {
    return Row(
      children: [
        Expanded(
          child: buildProductFormSheetModernTextField(
            stockController,
            'الكمية متوفرة',
            Icons.inventory_2_outlined,
            isNumber: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildProductFormSheetModernTextField(
            brandController,
            'العلامة التجارية',
            Icons.verified_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalSection(var responsive) {
    return Row(
      children: [
        Expanded(
          child: buildProductFormSheetModernTextField(
            servingSizeController,
            'حجم الحصة (جرام)',
            Icons.scale_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildProductFormSheetModernTextField(
            numberOfSessionsController,
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
          () => ProductFlavorSelector(
            selectedFlavors: controller.productFlavors.toList(),
            onSelectionChanged: (newList) =>
                controller.productFlavors.assignAll(newList),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => ProductSizeSelector(
            selectedSizes: controller.productSizes.toList(),
            onSelectionChanged: (newList) =>
                controller.productSizes.assignAll(newList),
          ),
        ),
        const SizedBox(height: 16),
        CustomModernDropdown<String>(
          
          value: selectedCategoryId,
          items: controller.categories
              .map(
                (cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name)),
              )
              .toList(),
          onChanged: (val) => setState(() => selectedCategoryId = val),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(ProductsController controller) {
    return buildProductFormSheetModernTextField(
      descriptionController,
      'وصف المنتج بالتفصيل...',
      Icons.description_outlined,
      maxLines: 8,
    );
  }

  Widget _buildSubmitButton(var responsive) {
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
          onPressed: _submitForm,
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

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategoryId == null || selectedCategoryId!.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار قسم للمنتج',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (imageUrls.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى إضافة صورة واحدة على الأقل للمنتج',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final productData = ProductModel(
      id: widget.product?.id ?? 'PROD-${DateTime.now().millisecondsSinceEpoch}',
      name: nameController.text,
      price: double.tryParse(priceController.text) ?? 0.0,
      discountPrice: double.tryParse(discountPriceController.text),
      imageUrls: imageUrls,
      description: descriptionController.text,
      categoryId: selectedCategoryId ?? '',
      stockQuantity: int.tryParse(stockController.text) ?? 0,
      brand: brandController.text,
      isActive: controller.isFeatured.value,
      servingSize: servingSizeController.text,
      servingsPerContainer: int.tryParse(numberOfSessionsController.text) ?? 0,
      flavor: controller.productFlavors.toList(),
      size: controller.productSizes.toList(),
      weight: controller.productWeight.value,
      isBackgroundWhite: controller.isBackgroundWhite.value,
    );

    debugPrint(productData.toString());
    widget.product == null
        ? controller.addProduct(productData)
        : controller.updateProduct(productData);
  }
}
