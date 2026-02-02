import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/models/flavors_model.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/ProductFormSheet.dart';
import '../models/index.dart';
import '../repositories/index.dart';
import '../services/api_service.dart';

class ProductsController extends GetxController {
  
  late final ProductRepository _productRepository;
  late final CategoryRepository _categoryRepository;
  RxList<String> productFlavors = <String>[].obs;
  late final ApiService _apiService;
  RxBool isFeatured = false.obs;


  // --- States ---
  final isLoading = true.obs;
  final isUploadingImage = false.obs;

  // --- Data Lists ---
  final products = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final flavors = <FlavorsModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final productSizes = <String>[].obs;

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
    'name': TextEditingController(),
    'price': TextEditingController(),
    'discount': TextEditingController(),
    'desc': TextEditingController(),
    'stock': TextEditingController(),
    'brand': TextEditingController(),
    'serving': TextEditingController(),
    'sessions': TextEditingController(),
  };


  @override
  void onInit() {
    super.onInit();
    _apiService = ApiService();
    _productRepository = ProductRepository(_apiService);
    _categoryRepository = CategoryRepository(_apiService);
    // _flavorRepository = FlavorRepository(_apiService); // تأكد من وجود FlavorRepository
    fetchData();
  }

  /// جلب كافة البيانات الأساسية من السيرفر
  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      // جلب البيانات بالتوازي لتقليل وقت الانتظار
      final results = await Future.wait([
        _categoryRepository.getCategories(),
        _productRepository.getProducts(),
        // _flavorRepository.getFlavors(), // جلب النكهات
      ]);

      categories.assignAll(results[0] as List<CategoryModel>);
      products.assignAll(results[1] as List<ProductModel>);
      // flavors.assignAll(results[2] as List<FlavorsModel>);

      _applyFiltering();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      _showErrorSnackbar('فشل في تحميل البيانات', e.toString());
    }
  }

  // --- Logic الفلترة ---

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

    // 1. التصفية حسب القسم
    if (selectedCategoryId.value != 'all') {
      filtered = filtered.where(
        (p) => p.categoryId == selectedCategoryId.value,
      );
    }

    // 2. التصفية حسب النكهة
    if (selectedFlavorId.value != 'all') {
      filtered = filtered.where(
        (p) => p.flavor?.contains(selectedFlavorId.value) ?? false,
      );
    }

    // 3. التصفية حسب البحث (الاسم، الماركة، أو الكود)
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where(
        (p) =>
            p.name.toLowerCase().contains(query) ||
            (p.brand?.toLowerCase().contains(query) ?? false) ||
            p.id.contains(query),
      );
    }

    filteredProducts.assignAll(filtered.toList());
  }

  // --- CRUD Operations ---

  Future<void> addProduct(ProductModel product) async {
    try {
      isLoading.value = true;

      // إنشاء ID تلقائي إذا لم يوجد
      final String productId = product.id.isEmpty
          ? 'PROD-${DateTime.now().millisecondsSinceEpoch}'
          : product.id;

      final productData = product.toJson();
      productData['id'] = productId;

      final newProduct = await _productRepository.addProduct(productData);
      products.insert(0, newProduct);

      _applyFiltering();
      Get.back(); // إغلاق النموذج
      Get.snackbar('نجاح', 'تم إضافة ${newProduct.name} بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في الإضافة', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      isLoading.value = true;
      final updatedProduct = await _productRepository.updateProduct(
        product.id,
        product.toJson(),
      );

      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = updatedProduct;
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
      // backgroundColor: Colors.white,
      // titleStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      // confirmTextColor: Colors.white,
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
      final success = await _productRepository.deleteProduct(id);
      if (success) {
        products.removeWhere((p) => p.id == id);
        _applyFiltering();
        Get.snackbar(
          'نجاح',
          'تم حذف المنتج بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
        );
      }
    } catch (e) {
      _showErrorSnackbar('خطأ في الحذف', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // --- Media Upload ---

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

  // --- Helpers ---

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

      final productData = ProductModel(
        id: existingProduct?.id ??
            'PROD-${DateTime.now().millisecondsSinceEpoch}',
        name: textcontrollers['name']!.text.trim(),
        price: double.tryParse(textcontrollers['price']!.text) ?? 0.0,
        discountPrice: double.tryParse(textcontrollers['discount']!.text),
        imageUrls: productImages,
        description: textcontrollers['desc']!.text.trim(),
        categoryId: categoryId,
        stockQuantity: int.tryParse(textcontrollers['stock']!.text) ?? 0,
        brand: textcontrollers['brand']!.text.trim(),
        isActive: isFeatured.value,
        isBackgroundWhite: isBackgroundWhite.value,
        servingSize: textcontrollers['serving']!.text,
        servingsPerContainer:
            int.tryParse(textcontrollers['sessions']!.text) ?? 0,
        flavor: productFlavors.toList(),
        size: productSizes.toList(),
        weight: productWeight.value,
      );

      if (existingProduct == null) {
        await addProduct(productData);
      } else {
        await updateProduct(productData);
      }

      Get.back(); 
      debugPrint("======== success ========");
      debugPrint(productData.toJson().toString());
      _showSuccess('تم بنجاح', 'تم حفظ بيانات المنتج بنجاح');
    } catch (e) {
      debugPrint("======== error ========");
      debugPrint(e.toString());
      _showError('خطأ', 'حدث خطأ أثناء حفظ المنتج: $e');
    } finally {
      debugPrint("======== finally ========");
      // debugPrint(productData.toJson().toString());
      isSaving.value = false;
    }
  }

  // دوال مساعدة للرسائل (Helpers)
  void _showWarning(String title, String msg) => Get.snackbar(title, msg, 
      snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);

  void _showError(String title, String msg) => Get.snackbar(title, msg, 
      snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);

  void _showSuccess(String title, String msg) => Get.snackbar(title, msg, 
      snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
}



