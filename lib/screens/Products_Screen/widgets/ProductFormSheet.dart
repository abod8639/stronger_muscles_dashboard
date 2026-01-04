import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/components/image_gallery_editor.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/models/product.dart';

class ProductFormSheet extends StatefulWidget {
  final ProductsController controller;
  final ProductModel? product;

  const ProductFormSheet({
    required this.controller,
    this.product,
  });

  @override
  State<ProductFormSheet> createState() => ProductFormSheetState();
}

class ProductFormSheetState extends State<ProductFormSheet> {
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController discountPriceController;
  late final TextEditingController stockController;
  late final TextEditingController descriptionController;
  late final TextEditingController brandController;
  late String selectedCategoryId;
  late List<String> imageUrls;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name ?? '');
    priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    discountPriceController = TextEditingController(text: widget.product?.discountPrice?.toString() ?? '');
    stockController = TextEditingController(text: widget.product?.stockQuantity.toString() ?? '');
    descriptionController = TextEditingController(text: widget.product?.description ?? '');
    brandController = TextEditingController(text: widget.product?.brand ?? '');
    selectedCategoryId = widget.product?.categoryId ?? 
                        (widget.controller.categories.isNotEmpty ? widget.controller.categories.first.id : '');
    imageUrls = List<String>.from(widget.product?.imageUrls ?? []);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    brandController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          imageUrls.add('https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/400/400');
        });
        Get.snackbar('نجاح', 'تم اختيار الصورة (تمت محاكاة الرفع)');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في اختيار الصورة: $e');
    }
  }

  void _addUrl(String url) {
    setState(() {
      imageUrls.add(url);
    });
  }

  void _removeImage(int index) {
    setState(() {
      imageUrls.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.product == null ? 'إضافة منتج جديد' : 'تعديل المنتج',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ImageGalleryEditor(
                    imageUrls: imageUrls,
                    onAddUrl: _addUrl,
                    onRemove: _removeImage,
                    onPickImage: _pickImage,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(nameController, 'اسم المنتج', Icons.label_outline),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(priceController, 'السعر', Icons.attach_money, isNumber: true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField(discountPriceController, 'سعر العرض', Icons.discount_outlined, isNumber: true)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(stockController, 'الكمية', Icons.inventory_2_outlined, isNumber: true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField(brandController, 'الماركة', Icons.business_outlined)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // اختيار التصنيف
                  DropdownButtonFormField<String>(
                    value: selectedCategoryId.isEmpty ? null : selectedCategoryId,
                    decoration: InputDecoration(
                      labelText: 'التصنيف',
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: widget.controller.categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.name),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedCategoryId = val ?? ''),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(descriptionController, 'الوصف', Icons.description_outlined, maxLines: 4),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Obx(() => widget.controller.isLoading.value 
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(widget.product == null ? 'إضافة المنتج' : 'حفظ التغييرات')
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _submitForm() {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar('تنبیه', 'يرجى ملء الاسم والسعر على الأقل');
      return;
    }

    final data = ProductModel(
      id: widget.product?.id ?? '',
      name: nameController.text,
      price: double.tryParse(priceController.text) ?? 0.0,
      discountPrice: double.tryParse(discountPriceController.text),
      imageUrls: imageUrls,
      description: descriptionController.text,
      categoryId: selectedCategoryId,
      stockQuantity: int.tryParse(stockController.text) ?? 0,
      brand: brandController.text,
      isActive: widget.product?.isActive ?? true,
    );

    if (widget.product == null) {
      widget.controller.addProduct(data);
    } else {
      widget.controller.updateProduct(data);
    }
  }
}
