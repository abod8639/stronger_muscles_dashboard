import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/repositories/category_repository.dart';

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
  final categories = <CategoryEntity>[].obs;
  final filteredCategories = <CategoryEntity>[].obs;
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
    final apiService = Get.find<ApiService>();
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
          return c.nameAr.toLowerCase().contains(query) ||
              c.nameEn.toLowerCase().contains(query) ||
              c.id.toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  Future<bool> saveCategory({String? existingId}) async {
    try {
      isLoading.value = true;
      final categoryData = {
        'id': idController.text.trim(),
        'name': {'ar': nameArController.text.trim(), 'en': nameEnController.text.trim()},
        'image_url': imageController.text.trim(),
        'description': {'ar': descArController.text.trim(), 'en': descEnController.text.trim()},
        'sort_order': 0,
        'is_active': isActive.value,
        'parent_id': parentId.value.isEmpty ? null : parentId.value,
      };

      if (existingId == null) {
        final newCategory = await _categoryRepository.addCategory(categoryData);
        categories.add(newCategory);
      } else {
        final updatedCategory = await _categoryRepository.updateCategory(existingId, categoryData);
        final index = categories.indexWhere((c) => c.id == existingId);
        if (index != -1) {
          categories[index] = updatedCategory;
        }
      }
      
      _applySearch();
      Get.snackbar('نجاح', 'تم حفظ التصنيف بنجاح');
      return true;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حفظ التصنيف: $e');
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

  void prepareFormForEdit(CategoryEntity category) {
    idController.text = category.id;
    nameArController.text = category.nameAr;
    nameEnController.text = category.nameEn;
    imageController.text = category.imageUrl ?? '';
    descArController.text = category.descriptionAr ?? '';
    descEnController.text = category.descriptionEn ?? '';
    iconController.text = category.icon?.toString() ?? '';
    parentId.value = category.parentId ?? '';
    isActive.value = category.isActive;
  }
}
