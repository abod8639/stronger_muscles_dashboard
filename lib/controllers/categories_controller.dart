import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/screens/components/confirm_dialog.dart';
import '../data/models/index.dart';
import '../data/services/api_service.dart';
import '../data/repositories/index.dart';

class CategoriesController extends GetxController {
  late final TextEditingController idController;
  late final TextEditingController nameArController;
  late final TextEditingController nameEnController;
  late final TextEditingController imageController;
  late final TextEditingController descArController;
  late final TextEditingController descEnController;
  late final TextEditingController iconController;

  late final CategoryRepository _categoryRepository;
  final RxBool isLoading = true.obs;
  final RxBool isProcessing = false.obs;
  final categories = <CategoryModel>[].obs;
  final filteredCategories = <CategoryModel>[].obs;
  final searchQuery = ''.obs;
  final RxString parentId = ''.obs;
  final RxBool isActive = true.obs;

  @override
  void onInit() {
    idController = TextEditingController();
    nameArController = TextEditingController();
    nameEnController = TextEditingController();
    imageController = TextEditingController();
    descArController = TextEditingController();
    descEnController = TextEditingController();
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
    nameArController.dispose();
    nameEnController.dispose();
    imageController.dispose();
    descArController.dispose();
    descEnController.dispose();
    iconController.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final data = await _categoryRepository.getCategories(tree: true);
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
          return c.name.ar.toLowerCase().contains(query) ||
              c.name.en.toLowerCase().contains(query) ||
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
        'name': category.name.toJson(),
        'image_url': category.imageUrl,
        'description': category.description?.toJson(),
        'sort_order': 0,
        'is_active': isActive.value,
        'parent_id': parentId.value.isEmpty ? null : parentId.value,
      });

      categories.add(newCategory);
      _applySearch();

      Get.snackbar('نجاح', 'تم إضافة التصنيف بنجاح');
      return true;
    } catch (e) {
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
          'name': category.name.toJson(),
          'image_url': category.imageUrl,
          'description': category.description?.toJson(),
          'sort_order': 0,
          'is_active': isActive.value,
          'parent_id': parentId.value.isEmpty ? null : parentId.value,
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
    nameArController.clear();
    nameEnController.clear();
    imageController.clear();
    descArController.clear();
    descEnController.clear();
    iconController.clear();
    parentId.value = '';
    isActive.value = true;
  }

  void prepareFormForEdit(CategoryModel category) {
    idController.text = category.id;
    nameArController.text = category.name.ar;
    nameEnController.text = category.name.en;
    imageController.text = category.imageUrl ?? '';
    descArController.text = category.description?.ar ?? '';
    descEnController.text = category.description?.en ?? '';
    iconController.text = category.icon?.toString() ?? '';
    parentId.value = category.parentId ?? '';
    isActive.value = category.isActive;
  }
}
