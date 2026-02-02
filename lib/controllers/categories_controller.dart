import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import '../models/index.dart';
import '../services/api_service.dart';
import '../repositories/index.dart';
import '../screens/components/index.dart';

class CategoriesController extends GetxController {
  late final TextEditingController idController;
  late final TextEditingController nameController;
  late final TextEditingController imageController;
  late final TextEditingController descriptionController;
  late final TextEditingController iconController;

  late final CategoryRepository _categoryRepository;
  final RxBool isLoading = true.obs;
  final RxBool isProcessing = false.obs;
  final categories = <CategoryModel>[].obs;
  final filteredCategories = <CategoryModel>[].obs;
  final searchQuery = ''.obs;
  final RxBool isActive = true.obs;

  @override
  void onInit() {
    idController = TextEditingController();
    nameController = TextEditingController();
    imageController = TextEditingController();
    descriptionController = TextEditingController();
    iconController = TextEditingController();

    super.onInit();
    final apiService = Get.put(ApiService());
    _categoryRepository = CategoryRepository(apiService);

    debounce(
      searchQuery,
      (_) => _applySearch(),
      time: const Duration(milliseconds: 300),
    );

    fetchCategories();
  }

  @override
  void onClose() {
    idController.dispose();
    nameController.dispose();
    imageController.dispose();
    descriptionController.dispose();
    iconController.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final data = await _categoryRepository.getCategories();
      categories.assignAll(data);
      _applySearch();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل التصنيفات: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void _applySearch() {
    if (searchQuery.isEmpty) {
      filteredCategories.assignAll(categories);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredCategories.assignAll(
        categories.where((c) {
          return c.name.toLowerCase().contains(query) ||
              c.id.toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  Future<bool> addCategory(CategoryModel category) async {
    try {
      isLoading.value = true;
      final newCategory = await _categoryRepository.addCategory({
        'id': category.id,
        'name': category.name,
        'image_url': category.imageUrl,
        'description': category.description,
        'sort_order': 0,
        'is_active': isActive.value,
        // 'icon': category.icon,
      });

      categories.add(newCategory);
      _applySearch();

      Get.snackbar(
        'نجاح',
        'تم إضافة التصنيف بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      print('Error adding category: $e');
      Get.snackbar('خطأ', 'فشل في إضافة التصنيف: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateCategory(CategoryModel category) async {
    try {
      isLoading.value = true;
      final updatedCategory = await _categoryRepository.updateCategory(
        category.id,
        {
          'name': category.name,
          'image_url': category.imageUrl,
          'description': category.description,
          'sort_order': 0,
          'is_active': isActive.value,
          // 'icon': category.icon,
        },
      );

      final index = categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        categories[index] = updatedCategory;
        _applySearch();
      }

      Get.snackbar('نجاح', 'تم تحديث التصنيف بنجاح');
      return true;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحديث التصنيف: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(String id) async {
    Get.dialog(
      ConfirmDialog(
        title: 'حذف التصنيف',
        message:
            'هل أنت متأكد من رغبتك في حذف هذا التصنيف؟ لا يمكن التراجع عن هذا الإجراء.',
        confirmText: 'حذف',
        confirmColor: AppColors.error,
        onConfirm: () async {
          Get.back();
          _performDelete(id);
        },
      ),
    );
  }

  Future<void> _performDelete(String id) async {
    try {
      isProcessing.value = true;
      final success = await _categoryRepository.deleteCategory(id);
      if (success) {
        categories.removeWhere((c) => c.id == id);
        _applySearch();
        Get.snackbar('نجاح', 'تم حذف التصنيف بنجاح');
      } else {
        Get.snackbar('تحذير', 'لا يمكن حذف التصنيف، قد يكون مرتبطاً بمنتجات.');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع أثناء الحذف');
    } finally {
      isProcessing.value = false;
    }
  }

  void clearForm() {
    idController.clear();
    nameController.clear();
    imageController.clear();
    descriptionController.clear();
    iconController.clear();
    isActive.value = true;
  }

  void prepareFormForEdit(CategoryModel category) {
    idController.text = category.id;
    nameController.text = category.name;
    imageController.text = category.imageUrl ?? '';
    descriptionController.text = category.description ?? '';
    iconController.text = category.icon ?? '';
    isActive.value = category.isActive;
  }
}
