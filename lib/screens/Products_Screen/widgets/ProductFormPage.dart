import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/components/image_gallery_editor.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/models/product_model.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/FlavorMultiSelect.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/availability_switch.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/buildModernDropdown.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/buildModernTextField.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/product_size_selector.dart';

class ProductFormPage extends StatefulWidget {
  final ProductModel? product;
  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
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
    priceController = TextEditingController(text: widget.product?.price.toString());
    discountPriceController = TextEditingController(text: widget.product?.discountPrice?.toString());
    stockController = TextEditingController(text: widget.product?.stockQuantity.toString());
    descriptionController = TextEditingController(text: widget.product?.description);
    brandController = TextEditingController(text: widget.product?.brand);
    servingSizeController = TextEditingController(text: widget.product?.servingSize);
    numberOfSessionsController = TextEditingController(text: widget.product?.servingsPerContainer.toString());

    imageUrls = List<String>.from(widget.product?.imageUrls ?? []);
    selectedCategoryId = widget.product?.categoryId ?? 
        (controller.categories.isNotEmpty ? controller.categories.first.id : null);

    controller.productFlavors.assignAll(widget.product?.flavor ?? []);
    controller.productSizes.assignAll(widget.product?.size ?? []);
    controller.isFeatured.value = widget.product?.isActive ?? true;
  }

  @override
  void dispose() {
    for (var c in [nameController, priceController, discountPriceController, stockController, descriptionController, brandController, servingSizeController, numberOfSessionsController]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final responsive = context.responsive;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'إضافة منتج' : 'تعديل المنتج'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.check_circle_outline, size: 28, color: AppColors.primary),
            tooltip: 'حفظ',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // قسم الصور كـ Card مستقل
              _buildCardSection(
                title: 'صور المنتج',
                child: ImageGalleryEditor(
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
                ),
              ),

              const SizedBox(height: 16),

              // قسم المعلومات الأساسية
              _buildCardSection(
                title: 'المعلومات الأساسية',
                child: Column(
                  children: [
                    buildProductFormSheetModernTextField(nameController, 'اسم المنتج', Icons.label),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: buildProductFormSheetModernTextField(priceController, 'السعر', Icons.attach_money, isNumber: true)),
                        const SizedBox(width: 12),
                        Expanded(child: buildProductFormSheetModernTextField(discountPriceController, 'سعر العرض', Icons.discount, isNumber: true)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // قسم التصنيف والخيارات
              _buildCardSection(
                title: 'التصنيف والخيارات',
                child: Column(
                  children: [
                    CustomModernDropdown<String>(
                      value: selectedCategoryId,
                      items: controller.categories.map((cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name))).toList(),
                      onChanged: (val) => setState(() => selectedCategoryId = val),
                    ),
                    const SizedBox(height: 16),
                    Obx(() => ProductFlavorSelector(
                      selectedFlavors: controller.productFlavors.toList(),
                      onSelectionChanged: (newList) => controller.productFlavors.assignAll(newList),
                    )),
                    const SizedBox(height: 16),
                    Obx(() => ProductSizeSelector(
                      selectedSizes: controller.productSizes.toList(),
                      onSelectionChanged: (newList) => controller.productSizes.assignAll(newList),
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // قسم المخزون والماركة
              _buildCardSection(

                title: 'المخزون والتفاصيل الفنية',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: buildProductFormSheetModernTextField(stockController, 'الكمية', Icons.inventory, isNumber: true)),
                        const SizedBox(width: 12),
                        Expanded(child: buildProductFormSheetModernTextField(brandController, 'الماركة', Icons.business)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: buildProductFormSheetModernTextField(servingSizeController, 'حجم الحصة', Icons.scale)),
                        const SizedBox(width: 12),
                        Expanded(child: buildProductFormSheetModernTextField(numberOfSessionsController, 'عدد الحصص', Icons.format_list_numbered, isNumber: true)),
                      ],
                    ),
                    const SizedBox(height: 16),
                     AvailabilitySwitch(
                      title: "Featured",
                      onChanged: (value) {
                        controller.isFeatured.value = value;
                      },
                      isAvailable: controller.isFeatured,
                    ),
                    const SizedBox(height: 16),
                     AvailabilitySwitch(
                      onChanged: (value) {
                        controller.isBackgroundWhite.value = value;
                      },
                      title: "Background White",
                      isAvailable: controller.isBackgroundWhite,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // قسم الوصف
              _buildCardSection(
                title: 'وصف المنتج',
                child: buildProductFormSheetModernTextField(descriptionController, 'اكتب وصفاً جذاباً للمنتج...', Icons.notes, maxLines: 5),
              ),

              const SizedBox(height: 32),

              // زر الحفظ النهائي
              _buildBigSubmitButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- دوال مساعدة لتنظيم الواجهة ---

  Widget _buildCardSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildBigSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: _submitForm,
        child: Obx(() => controller.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('حفظ البيانات ونشر المنتج', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
      ),
    );
  }

  // نفس دوال Logic السابقة (ImagePick, SubmitForm)
  Future<void> _handleImagePick() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
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
      Get.snackbar('خطأ', 'يرجى اختيار قسم للمنتج', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (imageUrls.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إضافة صورة واحدة على الأقل للمنتج', snackPosition: SnackPosition.BOTTOM);
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