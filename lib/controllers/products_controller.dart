import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductFormSheet.dart';
import '../models/index.dart';
import '../repositories/index.dart';
import '../services/api_service.dart';

class ProductsController extends GetxController {
  late final ProductRepository _productRepository;
  late final CategoryRepository _categoryRepository;
  late final ApiService _apiService;

  final isLoading = true.obs;
  final products = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  
  final searchQuery = ''.obs;
  final selectedCategoryId = 'all'.obs;
  final isUploadingImage = false.obs;

  @override
  void onInit() {
    super.onInit();
    _apiService = ApiService();
    _productRepository = ProductRepository(_apiService);
    _categoryRepository = CategoryRepository(_apiService);
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final cats = await _categoryRepository.getCategories();
      categories.assignAll(cats);
      
      final prods = await _productRepository.getProducts();
      products.assignAll(prods);
      
      _applyFiltering();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('خطأ', 'فشل في تحميل البيانات: ${e.toString()}');
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

  void _applyFiltering() {
    List<ProductModel> filtered = products.toList();

    // تصفية حسب القسم
    if (selectedCategoryId.value != 'all') {
      filtered = filtered.where((p) => p.categoryId == selectedCategoryId.value).toList();
    }

    // تصفية حسب البحث
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((p) => 
        p.name.toLowerCase().contains(query) ||
        p.brand?.toLowerCase().contains(query) == true ||
        p.id.contains(query)
      ).toList();
    }

    filteredProducts.assignAll(filtered);
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      isLoading.value = true;
      
      // توليد معرف إذا كان فارغاً (Backend requires ID)
      String productId = product.id;
      if (productId.isEmpty) {
        productId = 'PROD-${DateTime.now().millisecondsSinceEpoch}';
      }

      final productData = product.toJson();
      productData['id'] = productId;

      final newProduct = await _productRepository.addProduct(productData);
      products.insert(0, newProduct);
      _applyFiltering();
      isLoading.value = false;
      Get.back(); // Close modal
      Get.snackbar('نجاح', 'تم إضافة المنتج بنجاح');
    } catch (e) {
      isLoading.value = false;
      print('Error adding product: $e');
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'خطأ في التحقق', 
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 7),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      isLoading.value = true;
      final productData = product.toJson();
      final updatedProduct = await _productRepository.updateProduct(product.id, productData);
      
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = updatedProduct;
        _applyFiltering();
      }
      
      isLoading.value = false;
      Get.back(); // Close modal
      Get.snackbar('نجاح', 'تم تحديث المنتج بنجاح');
    } catch (e) {
      isLoading.value = false;
      print('Error updating product: $e');
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'خطأ في التحقق', 
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 7),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      isLoading.value = true;
      final success = await _productRepository.deleteProduct(id);
      if (success) {
        products.removeWhere((p) => p.id == id);
        _applyFiltering();
        Get.snackbar('نجاح', 'تم حذف المنتج بنجاح');
      } else {
        Get.snackbar('خطأ', 'فشل في حذف المنتج من الخادم');
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('خطأ', 'فشل في حذف المنتج: ${e.toString()}');
    }
  }

  Future<String?> uploadProductImage(String filePath) async {
    try {
      isLoading.value = true;
      final imageUrl = await _apiService.uploadProductImage(filePath);
      isLoading.value = false;
      return imageUrl;
    } catch (e) {
      isLoading.value = false;
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'خطأ',
        'فشل في رفع الصورة: $errorMsg',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return null;
    }
  }

  Future<String?> uploadCategoryImage(String filePath) async {
    try {
      isLoading.value = true;
      final imageUrl = await _apiService.uploadCategoryImage(filePath);
      isLoading.value = false;
      return imageUrl;
    } catch (e) {
      isLoading.value = false;
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'خطأ',
        'فشل في رفع الصورة: $errorMsg',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return null;
    }
  }

    void showProductForm(BuildContext context, {
    ProductModel? product,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductFormSheet( product: product),
    );
  }


}
