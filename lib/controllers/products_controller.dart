import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/models/flavors_model.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductFormSheet.dart';
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
  final searchQuery = ''.obs;
  final selectedCategoryId = 'all'.obs;
  final selectedFlavorId = 'all'.obs;
  final isAvailable = false.obs;

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
      filtered = filtered.where((p) => p.categoryId == selectedCategoryId.value);
    }

    // 2. التصفية حسب النكهة
    if (selectedFlavorId.value != 'all') {
      filtered = filtered.where((p) => p.flavor?.contains(selectedFlavorId.value) ?? false);
    }

    // 3. التصفية حسب البحث (الاسم، الماركة، أو الكود)
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((p) =>
          p.name.toLowerCase().contains(query) ||
          (p.brand?.toLowerCase().contains(query) ?? false) ||
          p.id.contains(query));
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
      final updatedProduct = await _productRepository.updateProduct(product.id, product.toJson());

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

  Future<void> deleteProduct(String id) async {
    try {
      isLoading.value = true;
      final success = await _productRepository.deleteProduct(id);
      if (success) {
        products.removeWhere((p) => p.id == id);
        _applyFiltering();
        Get.snackbar('نجاح', 'تم حذف المنتج');
      }
    } catch (e) {
      _showErrorSnackbar('خطأ في الحذف', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // --- Media Upload ---

  Future<String?> uploadImage(String filePath, {bool isCategory = false}) async {
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
}