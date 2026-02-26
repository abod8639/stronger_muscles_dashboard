import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/data/models/product_model.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/product_form_body.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/product_form_mixin.dart';
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
          Obx(
            () => IconButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.saveProduct(
                        existingProduct: widget.product,
                        formKey: _formKey,
                        categoryId: _selectedCategoryId ?? '',
                        productImages: controller.imageUrls.toList(),
                      ),
              icon: const Icon(Icons.save_as_rounded, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // ── الـ Body المشترك ─────────────────────────────────────────────
            Obx(
              () => ProductFormBody(
                controller: controller,
                imageUrls: controller.imageUrls.toList(),
                onAddImageUrl: (url) => controller.imageUrls.add(url),
                onRemoveImage: (i) => controller.imageUrls.removeAt(i),
                onReorderImage: (oldIdx, newIdx) {
                  final item = controller.imageUrls.removeAt(oldIdx);
                  controller.imageUrls.insert(newIdx, item);
                },
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: (id) =>
                    setState(() => _selectedCategoryId = id),
              ),
            ),
            const SizedBox(height: 32),

            // ── زر الحفظ ─────────────────────────────────────────────────────
            _buildSubmitButton(),
            const SizedBox(height: 50),
          ],
        ),
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
        onPressed: controller.isLoading.value
            ? null
            : () => controller.saveProduct(
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
}
