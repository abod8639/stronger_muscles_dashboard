import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_form_body.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_form_mixin.dart';

class ProductFormSheet extends StatefulWidget {
  final ProductEntity? product;
  const ProductFormSheet({super.key, this.product});

  @override
  State<ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<ProductFormSheet>
    with ProductFormMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  final ProductsController controller = Get.find<ProductsController>();

  @override
  ProductEntity? get product => widget.product;

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
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColorsExtended.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
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
                  const SizedBox(height: 30),
                  _buildSubmitButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.product == null ? 'إضافة منتج جديد' : 'تعديل البيانات',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: controller.isSaving.value
            ? null
            : () => controller.saveProduct(
                  existingProduct: widget.product,
                  formKey: _formKey,
                  categoryId: _selectedCategoryId ?? '',
                  productImages: controller.imageUrls.toList(),
                ),
        child: controller.isSaving.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'حفظ البيانات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
