import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductListItem.dart';
import '../../models/index.dart';
import '../../controllers/products_controller.dart';
import '../../config/theme.dart';
import '../../components/index.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المنتجات'),
        actions: [
          IconButton(
            onPressed: () => _showProductForm(context, controller),
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'إضافة منتج جديد',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج بالاسم، الماركة، أو الكود...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // اختيار القسم
          SizedBox(
            height: 50,
            child: Obx(() => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.categories.length + 1,
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final category = isAll ? null : controller.categories[index - 1];
                final id = isAll ? 'all' : category!.id;
                final name = isAll ? 'الكل' : category!.name;
                final isSelected = controller.selectedCategoryId.value == id;

                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: FilterChip(
                    label: Text(name),
                    selected: isSelected,
                    onSelected: (selected) => controller.setCategory(id),
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : null,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                );
              },
            )),
          ),
          const SizedBox(height: 8),

          // قائمة المنتجات
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        controller.searchQuery.isEmpty && controller.selectedCategoryId.value == 'all'
                            ? 'لا يوجد منتجات حالياً'
                            : 'لم يتم العثور على نتائج للبحث',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  return ProductListItem(
                    product: product,
                    onEdit: () => _showProductForm(context, controller, product: product),
                    onDelete: () => controller.deleteProduct(product.id),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showProductForm(BuildContext context, ProductsController controller, {ProductModel? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProductFormSheet(
        controller: controller,
        product: product,
      ),
    );
  }
}

class _ProductFormSheet extends StatefulWidget {
  final ProductsController controller;
  final ProductModel? product;

  const _ProductFormSheet({
    required this.controller,
    this.product,
  });

  @override
  State<_ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<_ProductFormSheet> {
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
