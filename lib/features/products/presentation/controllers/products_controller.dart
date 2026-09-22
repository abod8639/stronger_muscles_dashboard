import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/repositories/category_repository.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/upload_product_image_usecase.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/repositories/brand_repository.dart';
import '../widgets/product_form_page.dart';

class ProductsController extends GetxController {
  final GetProductsUseCase _getProductsUseCase;
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final UploadProductImageUseCase _uploadProductImageUseCase;
  final CategoryRepository _categoryRepository;
  final BrandRepository _brandRepository;

  ProductsController({
    required GetProductsUseCase getProductsUseCase,
    required AddProductUseCase addProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required UploadProductImageUseCase uploadProductImageUseCase,
    required CategoryRepository categoryRepository,
    required BrandRepository brandRepository,
  })  : _getProductsUseCase = getProductsUseCase,
        _addProductUseCase = addProductUseCase,
        _updateProductUseCase = updateProductUseCase,
        _deleteProductUseCase = deleteProductUseCase,
        _uploadProductImageUseCase = uploadProductImageUseCase,
        _categoryRepository = categoryRepository,
        _brandRepository = brandRepository;

  // --- States ---
  final isLoading = true.obs;
  final isUploadingImage = false.obs;
  final isSaving = false.obs;

  // --- Data Lists ---
  final products = <ProductEntity>[].obs;
  final categories = <CategoryEntity>[].obs;
  final brands = <BrandEntity>[].obs;
  final filteredProducts = <ProductEntity>[].obs;
  
  // --- Selection & Bulk Actions State ---
  final isSelectionMode = false.obs;
  final selectedProductIds = <String>{}.obs;
  final isBulkOperating = false.obs;

  bool get isAllSelected =>
      filteredProducts.isNotEmpty &&
      selectedProductIds.length >= filteredProducts.length &&
      filteredProducts.every((p) => selectedProductIds.contains(p.id));

  int get selectedCount => selectedProductIds.length;

  // Form specific state
  final productSizes = <ProductSizeEntity>[].obs;
  final productFlavors = <String>[].obs;
  final imageUrls = <String>[].obs;
  final isFeatured = false.obs;
  final isActive = true.obs; // Added isActive
  final isBackgroundWhite = false.obs;
  final selectedSizeIndex = (-1).obs;
  final variants = <ProductVariantEntity>[].obs;

  // --- Filter Values ---
  final searchQuery = ''.obs;
  final selectedCategoryId = 'all'.obs;
  final selectedFlavorId = 'all'.obs;

  final Map<String, TextEditingController> textcontrollers = {
    'name_ar': TextEditingController(),
    'name_en': TextEditingController(),
    'price': TextEditingController(),
    'discount': TextEditingController(),
    'desc_ar': TextEditingController(),
    'desc_en': TextEditingController(),
    'stock': TextEditingController(),
    'brand': TextEditingController(),
    'serving': TextEditingController(),
    'sessions': TextEditingController(),
  };

  // Controllers for each size
  final Map<String, TextEditingController> sizePriceControllers = {};
  final Map<String, TextEditingController> sizeDiscountControllers = {};

  @override
  void onInit() {
    super.onInit();
    fetchData();
    ever(productSizes, (_) => syncSizeControllers());
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final results = await Future.wait([
        _categoryRepository.getCategories(tree: true),
        _getProductsUseCase(),
        _brandRepository.getBrands(),
      ]);
      categories.assignAll(results[0] as List<CategoryEntity>);
      products.assignAll(results[1] as List<ProductEntity>);
      brands.assignAll(results[2] as List<BrandEntity>);
      _applyFiltering();
    } catch (e) {
      _showErrorSnackbar('فشل في تحميل البيانات', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFiltering();
  }

  void setCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
    _applyFiltering();
  }

  void setFlavor(String flavorId) {
    selectedFlavorId.value = flavorId;
    _applyFiltering();
  }

  void _applyFiltering() {
    Iterable<ProductEntity> filtered = products;
    if (selectedCategoryId.value != 'all') {
      filtered = filtered.where((p) => p.categoryId == selectedCategoryId.value);
    }
    if (selectedFlavorId.value != 'all') {
      filtered = filtered.where((p) => p.flavors?.contains(selectedFlavorId.value) ?? false);
    }
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((p) =>
          p.nameAr.toLowerCase().contains(query) ||
          p.nameEn.toLowerCase().contains(query) ||
          (p.brand?.toLowerCase().contains(query) ?? false) ||
          p.id.contains(query));
    }
    filteredProducts.assignAll(filtered.toList());
  }

  void syncSizeControllers() {
    for (var size in productSizes) {
      if (!sizePriceControllers.containsKey(size.size)) {
        sizePriceControllers[size.size] = TextEditingController(text: size.price.toString());
      }
      if (!sizeDiscountControllers.containsKey(size.size)) {
        sizeDiscountControllers[size.size] = TextEditingController(text: size.discountPrice?.toString() ?? '');
      }
    }
  }

  void clearSizeControllers() {
    sizePriceControllers.forEach((key, controller) => controller.dispose());
    sizePriceControllers.clear();
    sizeDiscountControllers.forEach((key, controller) => controller.dispose());
    sizeDiscountControllers.clear();
  }

  void selectSize(int index) {
    selectedSizeIndex.value = index;
    if (index >= 0 && index < productSizes.length) {
      final size = productSizes[index];
      textcontrollers['price']?.text = size.price.toString();
      textcontrollers['discount']?.text = size.discountPrice?.toString() ?? '';
    }
  }

  void addVariant() {
    final newVariant = ProductVariantEntity(
      id: 'VAR-${DateTime.now().millisecondsSinceEpoch}',
      sku: '',
      price: double.tryParse(textcontrollers['price']?.text ?? '0') ?? 0.0,
      discountPrice: double.tryParse(textcontrollers['discount']?.text ?? ''),
      effectivePrice: double.tryParse(textcontrollers['price']?.text ?? '0') ?? 0.0,
      stockQuantity: int.tryParse(textcontrollers['stock']?.text ?? '0') ?? 0,
      attributes: {},
      isActive: true,
    );
    variants.add(newVariant);
  }

  void removeVariant(int index) {
    if (index >= 0 && index < variants.length) variants.removeAt(index);
  }

  void updateVariant(int index, ProductVariantEntity updated) {
    if (index >= 0 && index < variants.length) variants[index] = updated;
  }

  Future<void> saveProduct({
    required GlobalKey<FormState> formKey,
    required String categoryId,
    required List<String> productImages,
    ProductEntity? existingProduct,
  }) async {
    if (!formKey.currentState!.validate()) return;
    if (productImages.isEmpty) {
      _showWarning('تنبيه', 'يجب إضافة صورة واحدة على الأقل');
      return;
    }
    if (categoryId.isEmpty || categoryId == 'all') {
      _showWarning('تنبيه', 'يرجى اختيار القسم');
      return;
    }

    try {
      isSaving.value = true;
      final updatedSizes = productSizes.map((ps) {
        final price = double.tryParse(sizePriceControllers[ps.size]?.text ?? '0') ?? 0.0;
        final discount = double.tryParse(sizeDiscountControllers[ps.size]?.text ?? '');
        return ProductSizeEntity(size: ps.size, price: price, discountPrice: discount);
      }).toList();

      double mainPrice = double.tryParse(textcontrollers['price']!.text) ?? 0.0;
      double? discountPrice = double.tryParse(textcontrollers['discount']!.text);

      // If main price is 0 but we have sizes, use the first size price as default
      if (mainPrice == 0 && updatedSizes.isNotEmpty) {
        mainPrice = updatedSizes.first.price;
        discountPrice = updatedSizes.first.discountPrice;
      }

      final String generatedId = existingProduct?.id ?? 'PROD-${DateTime.now().millisecondsSinceEpoch}';
      
      debugPrint('--- Generating Product with ID: $generatedId ---');

      final productData = {
        'id': generatedId,
        'name': {'ar': textcontrollers['name_ar']!.text.trim(), 'en': textcontrollers['name_en']!.text.trim()},
        'description': {'ar': textcontrollers['desc_ar']!.text.trim(), 'en': textcontrollers['desc_en']!.text.trim()},
        'price': mainPrice,
        'discount_price': discountPrice,
        'image_urls': productImages,
        'category_id': categoryId,
        'stock_quantity': int.tryParse(textcontrollers['stock']!.text) ?? 0,
        'brand': textcontrollers['brand']!.text.trim(),
        'is_active': isActive.value,
        'featured': isFeatured.value,
        'is_background_white': isBackgroundWhite.value,
        'serving_size': textcontrollers['serving']!.text.trim(),
        'servings_per_container': int.tryParse(textcontrollers['sessions']!.text) ?? 0,
        'flavors': productFlavors.toList(),
        'product_sizes': updatedSizes.map((s) => {'size': s.size, 'price': s.price, 'discount_price': s.discountPrice}).toList(),
        'product_variants': variants.map((v) => {
          'id': v.id,
          'sku': v.sku,
          'price': v.price,
          'discount_price': v.discountPrice,
          'effective_price': v.effectivePrice,
          'stock_quantity': v.stockQuantity,
          'attributes': v.attributes,
          'is_active': v.isActive,
        }).toList(),
      };

      debugPrint('Saving Product Payload: ${productData.toString()}');

      if (existingProduct == null) {
        final newProduct = await _addProductUseCase(productData);
        products.insert(0, newProduct);
        _showSuccess('تم بنجاح', 'تم إضافة المنتج بنجاح');

      } else {
        final updatedProduct = await _updateProductUseCase(existingProduct.id, productData);
        final index = products.indexWhere((p) => p.id == existingProduct.id);
        if (index != -1) products[index] = updatedProduct;
        _showSuccess('تم بنجاح', 'تم تحديث المنتج بنجاح');
      }
      _applyFiltering();
      Get.back();
    } catch (e) {
      _showErrorSnackbar('خطأ في الحفظ', e.toString());
      debugPrint(e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  void confirmDelete(String id, String productName) {
    Get.defaultDialog(
      title: 'تأكيد الحذف',
      middleText: 'هل أنت متأكد أنك تريد حذف المنتج "$productName"؟',
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        _executeDelete(id);
      },
    );
  }

  Future<void> _executeDelete(String id) async {
    try {
      isLoading.value = true;
      final success = await _deleteProductUseCase(id);
      if (success) {
        products.removeWhere((p) => p.id == id);
        _applyFiltering();
        _showSuccess('نجاح', 'تم حذف المنتج بنجاح');
      }
    } catch (e) {
      _showErrorSnackbar('خطأ في الحذف', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // --- Selection Methods ---
  void toggleSelectionMode([bool? enable]) {
    if (enable != null) {
      isSelectionMode.value = enable;
    } else {
      isSelectionMode.value = !isSelectionMode.value;
    }
    if (!isSelectionMode.value) {
      selectedProductIds.clear();
    }
  }

  void toggleProductSelection(String id) {
    if (selectedProductIds.contains(id)) {
      selectedProductIds.remove(id);
    } else {
      selectedProductIds.add(id);
      if (!isSelectionMode.value) {
        isSelectionMode.value = true;
      }
    }
  }

  bool isProductSelected(String id) => selectedProductIds.contains(id);

  void selectAll() {
    selectedProductIds.addAll(filteredProducts.map((p) => p.id));
    if (!isSelectionMode.value) isSelectionMode.value = true;
  }

  void deselectAll() {
    selectedProductIds.clear();
  }

  void toggleSelectAll() {
    if (isAllSelected) {
      deselectAll();
    } else {
      selectAll();
    }
  }

  // --- Bulk Action Methods ---
  void confirmBulkDelete() {
    final count = selectedCount;
    if (count == 0) return;

    Get.defaultDialog(
      title: 'تأكيد الحذف الجماعي',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: 'هل أنت متأكد من حذف $count منتج(ات) محدد بشكل نهائي؟ لا يمكن التراجع عن هذا الإجراء.',
      textConfirm: 'حذف المحدد',
      textCancel: 'إلغاء',
      buttonColor: Colors.redAccent,
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.white70,
      onConfirm: () {
        Get.back();
        _executeBulkDelete();
      },
    );
  }

  Future<void> _executeBulkDelete() async {
    final idsToDelete = selectedProductIds.toList();
    if (idsToDelete.isEmpty) return;

    try {
      isBulkOperating.value = true;
      int successCount = 0;
      int failCount = 0;

      for (final id in idsToDelete) {
        try {
          final success = await _deleteProductUseCase(id);
          if (success) {
            products.removeWhere((p) => p.id == id);
            selectedProductIds.remove(id);
            successCount++;
          } else {
            failCount++;
          }
        } catch (_) {
          failCount++;
        }
      }

      _applyFiltering();

      if (selectedProductIds.isEmpty) {
        isSelectionMode.value = false;
      }

      if (failCount == 0) {
        _showSuccess('تم بنجاح', 'تم حذف $successCount منتج(ات) بنجاح');
      } else {
        _showWarning('اكتملت العملية مع بعض التنبيهات', 'تم حذف $successCount وفشل حذف $failCount منتج');
      }
    } catch (e) {
      _showErrorSnackbar('خطأ في الحذف الجماعي', e.toString());
    } finally {
      isBulkOperating.value = false;
    }
  }

  Future<void> bulkToggleStatus({required bool activate}) async {
    final idsToUpdate = selectedProductIds.toList();
    if (idsToUpdate.isEmpty) return;

    final actionName = activate ? 'تفعيل' : 'تعطيل';

    try {
      isBulkOperating.value = true;
      int successCount = 0;
      int failCount = 0;

      for (final id in idsToUpdate) {
        try {
          final updatedProduct = await _updateProductUseCase(id, {'is_active': activate});
          final index = products.indexWhere((p) => p.id == id);
          if (index != -1) {
            products[index] = updatedProduct;
          }
          successCount++;
        } catch (_) {
          failCount++;
        }
      }

      _applyFiltering();

      if (failCount == 0) {
        _showSuccess('تم بنجاح', 'تم $actionName $successCount منتج(ات) بنجاح');
      } else {
        _showWarning('اكتملت العملية جزئياً', 'تم $actionName $successCount وفشل $failCount منتج');
      }
    } catch (e) {
      _showErrorSnackbar('خطأ في الـ $actionName الجماعي', e.toString());
    } finally {
      isBulkOperating.value = false;
    }
  }

  Future<void> bulkChangeCategory(String newCategoryId) async {
    final idsToUpdate = selectedProductIds.toList();
    if (idsToUpdate.isEmpty) return;

    try {
      isBulkOperating.value = true;
      int successCount = 0;
      int failCount = 0;

      for (final id in idsToUpdate) {
        try {
          final updatedProduct = await _updateProductUseCase(id, {'category_id': newCategoryId});
          final index = products.indexWhere((p) => p.id == id);
          if (index != -1) {
            products[index] = updatedProduct;
          }
          successCount++;
        } catch (_) {
          failCount++;
        }
      }

      _applyFiltering();
      Get.back(); // Close modal/dialog

      if (failCount == 0) {
        _showSuccess('تم بنجاح', 'تم نقل $successCount منتج(ات) إلى القسم بنجاح');
      } else {
        _showWarning('اكتمل النقل جزئياً', 'تم نقل $successCount وفشل نقل $failCount منتج');
      }
    } catch (e) {
      _showErrorSnackbar('خطأ في نقل المنتجات', e.toString());
    } finally {
      isBulkOperating.value = false;
    }
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      isUploadingImage.value = true;
      return await _uploadProductImageUseCase(filePath);
    } catch (e) {
      _showErrorSnackbar('خطأ في الرفع', e.toString());
      return null;
    } finally {
      isUploadingImage.value = false;
    }
  }

  void showProductForm(BuildContext context, {ProductEntity? product}) {
    Get.to(() => ProductFormPage(product: product));
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title, message.replaceAll('Exception: ', ''),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  void _showWarning(String title, String msg) => Get.snackbar(
    title, msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.orange,
    colorText: Colors.white,
  );

  void _showSuccess(String title, String msg) => Get.snackbar(
    title, msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );

  @override
  void onClose() {
    for (var c in textcontrollers.values) {
      c.dispose();
    }
    for (var c in sizePriceControllers.values) {
      c.dispose();
    }
    for (var c in sizeDiscountControllers.values) {
      c.dispose();
    }
    super.onClose();
  }
}
