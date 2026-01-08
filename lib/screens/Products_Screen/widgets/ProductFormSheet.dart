import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/components/image_gallery_editor.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/models/product.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/buildModernTextField.dart';

class ProductFormSheet extends StatefulWidget {
  final ProductModel? product;

  const ProductFormSheet({super.key, 
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
  final ProductsController controller = Get.put(ProductsController());

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
                        (controller.categories.isNotEmpty ? controller.categories.first.id : '');
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
        // إظهار مؤشر التحميل
        Get.snackbar(
          'جاري الرفع',
          'يتم رفع الصورة إلى الخادم...',
          duration: const Duration(seconds: 30),
          snackPosition: SnackPosition.BOTTOM,
        );

        // رفع الصورة إلى الخادم
        final uploadedUrl = await controller.uploadProductImage(image.path);
        
        if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
          setState(() {
            imageUrls.add(uploadedUrl);
          });
          Get.back(); // إغلاق الـ snackbar السابق
          Get.snackbar(
            'نجاح',
            'تم رفع الصورة بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في اختيار الصورة: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: padding.left,
        right: padding.right,
        bottom: MediaQuery.of(context).viewInsets.bottom + padding.bottom,
        top: padding.top,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // مؤشر الجرجرة
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: padding.top),

          // العنوان
          Text(
            widget.product == null ? '✨ إضافة منتج جديد' : '✏️ تعديل المنتج',
            style: TextStyle(
              fontSize: responsive.getTitleFontSize() + 2,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: padding.top),

          // المحتوى
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // معرض الصور
                  ImageGalleryEditor(
                    imageUrls: imageUrls,
                    onAddUrl: _addUrl,
                    onRemove: _removeImage,
                    onPickImage: _pickImage,
                    onReorder:  handleReorder,
                  ),
                  SizedBox(height: padding.top * 1.5),

                  // اسم المنتج
                  buildProductFormSheetModernTextField(
                    nameController,
                    'اسم المنتج',
                    Icons.label_outline,
                  ),
                  SizedBox(height: padding.top),

                  // السعر والعرض
                  Row(
                    children: [
                      Expanded(
                        child: buildProductFormSheetModernTextField(
                          priceController,
                          'السعر',
                          Icons.attach_money,
                          isNumber: true,
                        ),
                      ),
                      SizedBox(width: padding.left),
                      Expanded(
                        child: buildProductFormSheetModernTextField(
                          discountPriceController,
                          'سعر العرض',
                          Icons.discount_outlined,
                          isNumber: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: padding.top),

                  // المخزون والماركة
                  Row(
                    children: [
                      Expanded(
                        child: buildProductFormSheetModernTextField(
                          stockController,
                          'الكمية',
                          Icons.inventory_2_outlined,
                          isNumber: true,
                        ),
                      ),
                      SizedBox(width: padding.left),
                      Expanded(
                        child: buildProductFormSheetModernTextField(
                          brandController,
                          'الماركة',
                          Icons.business_outlined,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: padding.top),

                  // التصنيف
                  buildModernDropdown(),
                  SizedBox(height: padding.top),

                  // الوصف
                  buildProductFormSheetModernTextField(
                    descriptionController,
                    'الوصف',
                    Icons.description_outlined,
                    maxLines: 4,
                  ),
                  SizedBox(height: padding.top * 2),
                ],
              ),
            ),
          ),

          // زر الحفظ
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _submitForm,
                  borderRadius: BorderRadius.circular(14),
                  child: Obx(
                    () => controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withAlpha(200),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              widget.product == null
                                  ? '➕ إضافة المنتج'
                                  : '💾 حفظ التغييرات',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.getBodyFontSize() + 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildModernDropdown() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        initialValue: (selectedCategoryId.isEmpty || !controller.categories.any((c) => c.id == selectedCategoryId))
            ? (controller.categories.isNotEmpty ? controller.categories.first.id : null)
            : selectedCategoryId,
        dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primary.withValues(alpha: 0.7)),
        decoration: InputDecoration(
          labelText: 'التصنيف',
          prefixIcon: Icon(
            Icons.category_outlined,
            color: AppColors.primary.withValues(alpha: 0.7),
            size: responsive.iconSize,
          ),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : AppColors.primary.withValues(alpha: 0.6),
            fontSize: responsive.getBodyFontSize(),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: responsive.defaultPadding.left / 1.5,
            vertical: responsive.defaultPadding.top / 1.5,
          ),
        ),
        items: controller.categories.map((cat) {
          return DropdownMenuItem(
            value: cat.id,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                SizedBox(width: responsive.itemSpacing / 2),
                Text(
                  cat.name,
                  style: TextStyle(
                    fontSize: responsive.getBodyFontSize(),
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (val) => setState(() => selectedCategoryId = val ?? ''),
      ),
    );
  }

void handleReorder(int oldIndex, int newIndex) {
  setState(() {
    // تصحيح الـ index الخاص بـ Flutter
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    // سحب العنصر من مكانه القديم ووضعه في الجديد
    final String item = imageUrls.removeAt(oldIndex);
    imageUrls.insert(newIndex, item);
  });
}

  void _submitForm() {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى ملء الاسم والسعر على الأقل');
      return;
    }

    final data = ProductModel(
      id: widget.product?.id ?? 'PROD-${DateTime.now().millisecondsSinceEpoch}',
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
      controller.addProduct(data);
    } else {
      controller.updateProduct(data);
    }
  }
}
