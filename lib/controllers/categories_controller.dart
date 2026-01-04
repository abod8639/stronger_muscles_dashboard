import 'package:get/get.dart';
import '../models/index.dart';
import '../services/api_service.dart';
import '../repositories/index.dart';
import '../components/index.dart';

class CategoriesController extends GetxController {
  late final CategoryRepository _categoryRepository;

  final isLoading = true.obs;
  final categories = <CategoryModel>[].obs;
  final filteredCategories = <CategoryModel>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final apiService = ApiService();
    _categoryRepository = CategoryRepository(apiService);
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final data = await _categoryRepository.getCategories();
      categories.assignAll(data);
      applySearch();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('خطأ', 'فشل في تحميل التصنيفات: ${e.toString()}');
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    applySearch();
  }

  void applySearch() {
    if (searchQuery.isEmpty) {
      filteredCategories.assignAll(categories);
    } else {
      filteredCategories.assignAll(
        categories.where((c) => 
          c.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          c.id.contains(searchQuery.value)
        ).toList()
      );
    }
  }

  Future<void> addCategory(String id, String name, String? imageUrl) async {
    try {
      isLoading.value = true;
      final newCategory = await _categoryRepository.addCategory({
        'id': id,
        'name': name,
        'image_url': imageUrl ?? '',
        'description': '',
        'sort_order': 0,
        'is_active': 1,
      });
      categories.add(newCategory);
      applySearch();
      isLoading.value = false;
      Get.back(); // Close modal
      Get.snackbar('نجاح', 'تم إضافة التصنيف بنجاح');
    } catch (e) {
      isLoading.value = false;
      print('Error adding category: $e');
      Get.snackbar('خطأ', 'فشل في إضافة التصنيف. يرجى التأكد من البيانات والمحاولة مرة أخرى.');
    }
  }

  Future<void> updateCategory(String id, String name, String? imageUrl) async {
    try {
      isLoading.value = true;
      final updatedCategory = await _categoryRepository.updateCategory(id, {
        'name': name,
        'image_url': imageUrl ?? '',
        'description': '',
        'sort_order': 0,
        'is_active': 1,
      });
      
      final index = categories.indexWhere((c) => c.id == id);
      if (index != -1) {
        categories[index] = updatedCategory;
        applySearch();
      }
      
      isLoading.value = false;
      Get.back(); // Close modal
      Get.snackbar('نجاح', 'تم تحديث التصنيف بنجاح');
    } catch (e) {
      isLoading.value = false;
      print('Error updating category: $e');
      Get.snackbar('خطأ', 'فشل في تحديث التصنيف: ${e.toString()}');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      Get.dialog(
        ConfirmDialog(
          title: 'حذف التصنيف',
          message: 'هل أنت متأكد من رغبتك في حذف هذا التصنيف؟ لا يمكن التراجع عن هذا الإجراء.',
          confirmText: 'حذف',
          onConfirm: () async {
            Get.back(); // Close confirm dialog
            isLoading.value = true;
            final success = await _categoryRepository.deleteCategory(id);
            if (success) {
              categories.removeWhere((c) => c.id == id);
              applySearch();
              Get.snackbar('نجاح', 'تم حذف التصنيف بنجاح');
            } else {
              Get.snackbar('خطأ', 'فشل في حذف التصنيف. قد يكون مرتبطاً بمنتجات.');
            }
            isLoading.value = false;
          },
        ),
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('خطأ', 'فشل في حذف التصنيف: ${e.toString()}');
    }
  }
}
