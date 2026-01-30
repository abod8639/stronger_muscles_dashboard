import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/FlavorMultiSelect.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/availability_switch.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/buildModernDropdown.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/buildModernTextField.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/product_size_selector.dart';
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

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ProductsController controller = Get.find<ProductsController>();

  // تجميع الـ Controllers في Map لسهولة الإدارة أو تعريفها بوضوح
  late final Map<String, TextEditingController> _controllers;

  // استخدام RxList للصور لتقليل استخدام setState
  final RxList<String> _imageUrls = <String>[].obs;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _controllers = {
      'name': TextEditingController(text: widget.product?.name),
      'price': TextEditingController(text: widget.product?.price.toString()),
      'discount': TextEditingController(
        text: widget.product?.discountPrice?.toString() ?? '',
      ),
      'stock': TextEditingController(
        text: widget.product?.stockQuantity.toString(),
      ),
      'desc': TextEditingController(text: widget.product?.description),
      'brand': TextEditingController(text: widget.product?.brand),
      'serving': TextEditingController(text: widget.product?.servingSize),
      'sessions': TextEditingController(
        text: widget.product?.servingsPerContainer.toString(),
      ),
    };

    if (widget.product != null) {
      _imageUrls.assignAll(widget.product!.imageUrls);
      _selectedCategoryId = widget.product!.categoryId;
      controller.productFlavors.assignAll(widget.product!.flavor ?? []);
      controller.productSizes.assignAll(widget.product!.size ?? []);
      controller.isFeatured.value = widget.product!.isActive;
      controller.isBackgroundWhite.value =
          widget.product!.isBackgroundWhite ?? false;
    } else {
      _selectedCategoryId = controller.categories.isNotEmpty
          ? controller.categories.first.id
          : null;
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, c) => c.dispose());
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
          imageUrls: _imageUrls.toList(),
          onAddUrl: (url) => _imageUrls.add(url),
          onRemove: (index) => _imageUrls.removeAt(index),
          onPickImage: _handleImagePick,
          onReorder: (oldIdx, newIdx) {
            if (newIdx > oldIdx) newIdx -= 1;
            final item = _imageUrls.removeAt(oldIdx);
            _imageUrls.insert(newIdx, item);
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
          buildProductFormSheetModernTextField(
            _controllers['name']!,
            'اسم المنتج بالكامل',
            Icons.drive_file_rename_outline,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: buildProductFormSheetModernTextField(
                  _controllers['price']!,
                  'السعر الأساسي',
                  Icons.payments_outlined,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildProductFormSheetModernTextField(
                  _controllers['discount']!,
                  'سعر الخصم',
                  Icons.sell_outlined,
                  isNumber: true,
                ),
              ),
            ],
          ),
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
          CustomModernDropdown<String>(
            value: _selectedCategoryId,
            items: controller.categories
                .map(
                  (cat) =>
                      DropdownMenuItem(value: cat.id, child: Text(cat.name)),
                )
                .toList(),
            onChanged: (val) => setState(() => _selectedCategoryId = val),
          ),
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
                child: buildProductFormSheetModernTextField(
                  _controllers['stock']!,
                  'الكمية المتاحة',
                  Icons.numbers,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildProductFormSheetModernTextField(
                  _controllers['brand']!,
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
                child: buildProductFormSheetModernTextField(
                  _controllers['serving']!,
                  'حجم الحصة',
                  Icons.fitness_center,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildProductFormSheetModernTextField(
                  _controllers['sessions']!,
                  'إجمالي الحصص',
                  Icons.reorder,
                  isNumber: true,
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Obx(
            () => AvailabilitySwitch(
              title: "منتج مميز (Featured)",
              isAvailable: controller.isFeatured,
              onChanged: (val) => controller.isFeatured.value = val,
            ),
          ),
          Obx(
            () => AvailabilitySwitch(
              title: "خلفية بيضاء (White Background)",
              isAvailable: controller.isBackgroundWhite,
              onChanged: (val) => controller.isBackgroundWhite.value = val,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return _buildCardWrapper(
      title: 'الوصف التفصيلي',
      icon: Icons.description_outlined,
      child: buildProductFormSheetModernTextField(
        _controllers['desc']!,
        'أدخل مواصفات المنتج وفوائده...',
        Icons.text_snippet_outlined,
        maxLines: 4,
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
            color: Colors.black.withOpacity(0.03),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(thickness: 0.5),
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
        onPressed:()=> controller.isLoading.value ? null :
         controller.saveProduct(
          existingProduct: widget.product,
          formKey: _formKey,
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
      if (url != null) _imageUrls.add(url);
    }
  }




}
