import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';
import 'package:stronger_muscles_dashboard/data/models/flavors_model.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/models/category_model.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/repositories/category_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/data/models/product_model.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/get_products_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/add_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/update_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_form_sheet.dart';

class ProductsController extends GetxController {
  final GetProductsUseCase getProductsUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  late final CategoryRepository _categoryRepository;
  late final ApiService _apiService;
  RxList<String> productFlavors = <String>[].obs;
  RxBool isFeatured = false.obs;

  ProductsController({
    required this.getProductsUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  });

  // --- States ---
  final isLoading = true.obs;
  final isUploadingImage = false.obs;

  // --- Data Lists ---
  final products = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final flavors = <FlavorsModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final productSizes = <ProductSize>[].obs;

  // --- Filter Values ---
  final productWeight = 0.0.obs;
  final searchQuery = ''.obs;
  final selectedCategoryId = 'all'.obs;
  final selectedFlavorId = 'all'.obs;
  final isAvailable = false.obs;
  final isBackgroundWhite = false.obs;

  RxBool isSaving = false.obs;
  RxList<String> imageUrls = <String>[].obs;

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

  final variants = <ProductVariantModel>[].obs;

  // Controllers for each size
  final Map<String, TextEditingController> sizePriceControllers = {};
  final Map<String, TextEditingController> sizeDiscountControllers = {};

  final selectedSizeIndex = (-1).obs;

  void addVariant() {
    final newVariant = ProductVariantModel(
      id: 'VAR-${DateTime.now().millisecondsSinceEpoch}',
      sku: '',
      price: double.tryParse(textcontrollers['price']?.text ?? '0') ?? 0,
      discountPrice: double.tryParse(textcontrollers['discount']?.text ?? ''),
      effectivePrice:
          double.tryParse(textcontrollers['price']?.text ?? '0') ?? 0,
      stockQuantity: int.tryParse(textcontrollers['stock']?.text ?? '0') ?? 0,
      attributes: {},
      isActive: true,
    );
    variants.add(newVariant);
  }

  void removeVariant(int index) {
    if (index >= 0 && index < variants.length) {
      variants.removeAt(index);
    }
  }

  void updateVariant(int index, ProductVariantModel updated) {
    if (index >= 0 && index < variants.length) {
      variants[index] = updated;
    }
  }

  void syncSizeControllers() {
    for (var size in productSizes) {
      if (!sizePriceControllers.containsKey(size.size)) {
        sizePriceControllers[size.size] = TextEditingController(
          text: size.price.toString(),
        );
      }
      if (!sizeDiscountControllers.containsKey(size.size)) {
        sizeDiscountControllers[size.size] = TextEditingController(
          text: size.discountPrice?.toString() ?? '',
        );
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

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    fetchData();

    ever(productSizes, (_) => syncSizeControllers());
  }

  void _initializeDependencies() {
    _apiService = Get.find<ApiService>();
    _categoryRepository = Get.find<CategoryRepository>();
  }

  Future<void> fetchData({bool forceRefresh = false}) async {
    try {
      isLoading.value = true;

      final results = await Future.wait([
        _categoryRepository.getCategories(tree: true, forceRefresh: forceRefresh),
        getProductsUseCase(forceRefresh: forceRefresh),
      ]);

      categories.assignAll(results[0] as List<CategoryModel>);
      products.assignAll(results[1] as List<ProductModel>);

      _applyFiltering();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      _showErrorSnackbar('فشل في تحميل البيانات', e.toString());
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

  void setAvailability(bool isFeatured) {
    isAvailable.value = isFeatured;
    _applyFiltering();
  }

  void _applyFiltering() {
    Iterable<ProductModel> filtered = products;

    if (selectedCategoryId.value != 'all') {
      filtered = filtered.where(
        (p) => p.effectiveCategoryId == selectedCategoryId.value,
      );
    }

    if (selectedFlavorId.value != 'all') {
      filtered = filtered.where(
        (p) => p.flavor?.contains(selectedFlavorId.value) ?? false,
      );
    }

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where(
        (p) =>
            p.name.ar.toLowerCase().contains(query) ||
            p.name.en.toLowerCase().contains(query) ||
            (p.brand?.toLowerCase().contains(query) ?? false) ||
            p.id.contains(query),
      );
    }

    filteredProducts.assignAll(filtered.toList());
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      isLoading.value = true;
      final newProduct = await addProductUseCase(product);
      products.insert(0, newProduct as ProductModel);

      _applyFiltering();
      Get.back();
      Get.snackbar('نجاح', 'تم إضافة ${newProduct.name.ar} بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في الإضافة', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      isLoading.value = true;
      final updatedProduct = await updateProductUseCase(product);

      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = updatedProduct as ProductModel;
        _applyFiltering();
      }

      Get.back();
      Get.snackbar('نجاح', 'تم تحديث البيانات بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في التحديث', e.toString());
    } finally {
      isLoading.value = false;
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
      final success = await deleteProductUseCase(id);
      if (success) {
        products.removeWhere((p) => p.id == id);
        _applyFiltering();
        Get.snackbar(
          'نجاح',
          'تم حذف المنتج بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
        );
      }
    } catch (e) {
      _showErrorSnackbar('خطأ في الحذف', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> uploadImage(
    String filePath, {
    bool isCategory = false,
  }) async {
    try {
      isUploadingImage.value = true;
      final imageUrl = isCategory
          ? await _apiService.uploadCategoryImage(filePath)
          : await _apiService.uploadProductImage(filePath);
      return imageUrl;
    } catch (e) {
      _showErrorSnackbar('خطأ في الرفع', e.toString());
      return null;
    } finally {
      isUploadingImage.value = false;
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message.replaceAll('Exception: ', ''),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  void showProductForm(BuildContext context, {ProductModel? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductFormSheet(product: product),
    );
  }

  Future<void> saveProduct({
    required GlobalKey<FormState> formKey,
    required String categoryId,
    required List<String> productImages,
    ProductModel? existingProduct,
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
        final price =
            double.tryParse(sizePriceControllers[ps.size]?.text ?? '0') ?? 0;
        final discount = double.tryParse(
          sizeDiscountControllers[ps.size]?.text ?? '',
        );
        return ps.copyWith(price: price, discountPrice: discount);
      }).toList();

      final productData = ProductModel(
        id:
            existingProduct?.id ??
            'PROD-${DateTime.now().millisecondsSinceEpoch}',
        name: TranslatableString(
          ar: textcontrollers['name_ar']!.text.trim(),
          en: textcontrollers['name_en']!.text.trim(),
        ),
        price: double.tryParse(textcontrollers['price']!.text) ?? 0,
        discountPrice: double.tryParse(textcontrollers['discount']!.text),
        imageUrls: productImages
            .map(
              (url) => ProductImage(thumbnail: url, medium: url, original: url),
            )
            .toList(),
        description: TranslatableString(
          ar: textcontrollers['desc_ar']!.text.trim(),
          en: textcontrollers['desc_en']!.text.trim(),
        ),
        categoryId: categoryId,
        stockQuantity: int.tryParse(textcontrollers['stock']!.text) ?? 0,
        brand: textcontrollers['brand']!.text.trim(),
        isActive: isFeatured.value,
        isBackgroundWhite: isBackgroundWhite.value,
        servingSize: textcontrollers['serving']!.text,
        servingsPerContainer:
            int.tryParse(textcontrollers['sessions']!.text) ?? 0,
        flavor: productFlavors.toList(),
        productSizes: updatedSizes,
        size: updatedSizes.map((e) => e.size).toList(),
        variants: variants.toList(),
      );

      if (existingProduct == null) {
        await addProduct(productData);
      } else {
        await updateProduct(productData);
      }

      _showSuccess('تم بنجاح', 'تم حفظ بيانات المنتج بنجاح');
    } catch (e) {
      _showError('خطأ', 'حدث خطأ أثناء حفظ المنتج: $e');
    } finally {
      isSaving.value = false;
    }
  }

  void _showWarning(String title, String msg) => Get.snackbar(
    title,
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.orange,
    colorText: Colors.white,
  );

  void _showError(String title, String msg) => Get.snackbar(
    title,
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );

  void _showSuccess(String title, String msg) => Get.snackbar(
    title,
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
}
