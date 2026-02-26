import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/data/models/product_model.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/product_form_body.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/product_form_mixin.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

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

  String? _selectedCategoryId;
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    initializeProductFields();
    _imageUrls = getInitialImageUrls();
    _selectedCategoryId = getInitialCategoryId();
  }

  @override
  void dispose() {
    disposeProductControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

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
                      ProductFormBody(
                        controller: controller,
                        imageUrls: _imageUrls,
                        onAddImageUrl: (url) =>
                            setState(() => _imageUrls.add(url)),
                        onRemoveImage: (i) =>
                            setState(() => _imageUrls.removeAt(i)),
                        onReorderImage: (oldIdx, newIdx) => setState(
                          () => _imageUrls.insert(
                            newIdx,
                            _imageUrls.removeAt(oldIdx),
                          ),
                        ),
                        selectedCategoryId: _selectedCategoryId,
                        onCategorySelected: (id) =>
                            setState(() => _selectedCategoryId = id),
                      ),
                      const SizedBox(height: 100),
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

  // ── Drag handle ────────────────────────────────────────────────────────────

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

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(ResponsiveLayout responsive) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
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

  // ── Submit button ──────────────────────────────────────────────────────────

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
            categoryId: _selectedCategoryId ?? '',
            productImages: _imageUrls,
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
}
