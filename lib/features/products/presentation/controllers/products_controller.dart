import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/repositories/category_repository.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/upload_product_image_usecase.dart';
import '../widgets/product_form_sheet.dart';

class ProductsController extends GetxController {
  final GetProductsUseCase _getProductsUseCase;
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final UploadProductImageUseCase _uploadProductImageUseCase;
  final CategoryRepository _categoryRepository;

  ProductsController({
    required GetProductsUseCase getProductsUseCase,
    required AddProductUseCase addProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required UploadProductImageUseCase uploadProductImageUseCase,
    required CategoryRepository categoryRepository,
  })  : _getProductsUseCase = getProductsUseCase,
        _addProductUseCase = addProductUseCase,
        _updateProductUseCase = updateProductUseCase,
        _deleteProductUseCase = deleteProductUseCase,
        _uploadProductImageUseCase = uploadProductImageUseCase,
        _categoryRepository = categoryRepository;

  // --- States ---
  final isLoading = true.obs;
  final isUploadingImage = false.obs;
  final isSaving = false.obs;

  // --- Data Lists ---
  final products = <ProductEntity>[].obs;
  final categories = <CategoryEntity>[].obs;
  final filteredProducts = <ProductEntity>[].obs;
  
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
      ]);
      categories.assignAll(results[0] as List<CategoryEntity>);
      products.assignAll(results[1] as List<ProductEntity>);
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
      print(e);
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductFormSheet(product: product),
    );
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
}
