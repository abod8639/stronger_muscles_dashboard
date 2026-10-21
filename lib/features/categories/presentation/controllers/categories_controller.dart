import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/repositories/category_repository.dart';
import '../../domain/entities/category_entity.dart';
import 'categories_providers.dart';

/// إدارة حالة التصنيفات عبر [AsyncNotifier] في Riverpod
class CategoriesNotifier extends AsyncNotifier<List<CategoryEntity>> {
  CancelToken? _cancelToken;

  @override
  FutureOr<List<CategoryEntity>> build() {
    // إدارة الإلغاء عبر ref.onDispose لمنع تسريب الموارد
    ref.onDispose(() {
      _cancelToken?.cancel('تم إلغاء طلبات التصنيفات بسبب تفريغ الـ Notifier');
      _cancelToken = null;
    });

    return _fetchCategories(tree: true, forceRefresh: false);
  }

  Future<List<CategoryEntity>> _fetchCategories({
    bool tree = true,
    bool forceRefresh = false,
  }) async {
    _cancelToken?.cancel('طلب جديد للتصنيفات');
    _cancelToken = CancelToken();

    final getCategories = ref.read(getCategoriesUseCaseProvider);
    final result = await getCategories(
      tree: tree,
      forceRefresh: forceRefresh,
      cancelToken: _cancelToken,
    );

    return result.fold(
      (failure) => throw failure,
      (categories) {
        // مزامنة مع GetX controller bridge إن وجد
        if (Get.isRegistered<CategoriesController>()) {
          Get.find<CategoriesController>().categories.assignAll(categories);
        }
        return categories;
      },
    );
  }

  /// إعادة تحميل التصنيفات مع إجبار تحديث الـ Cache
  Future<void> refreshCategories({bool forceRefresh = true}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _fetchCategories(tree: true, forceRefresh: forceRefresh),
    );
  }

  /// إضافة تصنيف جديد وتحديث الحالة محلياً
  Future<bool> addCategory(Map<String, dynamic> categoryData) async {
    final addUseCase = ref.read(addCategoryUseCaseProvider);
    final previousState = state;

    final result = await addUseCase(categoryData);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (newCategory) {
        final currentList = previousState.value ?? [];
        final updatedList = [newCategory, ...currentList];
        state = AsyncValue.data(updatedList);
        if (Get.isRegistered<CategoriesController>()) {
          Get.find<CategoriesController>().categories.assignAll(updatedList);
        }
        return true;
      },
    );
  }

  /// تحديث تصنيف موجود
  Future<bool> updateCategory(
    String id,
    Map<String, dynamic> categoryData,
  ) async {
    final updateUseCase = ref.read(updateCategoryUseCaseProvider);
    final previousState = state;

    final result = await updateUseCase(id, categoryData);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (updatedCategory) {
        final currentList = List<CategoryEntity>.from(previousState.value ?? []);
        final index = currentList.indexWhere((c) => c.id == id);
        if (index != -1) {
          currentList[index] = updatedCategory;
          state = AsyncValue.data(currentList);
          if (Get.isRegistered<CategoriesController>()) {
            Get.find<CategoriesController>().categories.assignAll(currentList);
          }
        }
        return true;
      },
    );
  }

  /// حذف تصنيف
  Future<bool> deleteCategory(String id) async {
    final deleteUseCase = ref.read(deleteCategoryUseCaseProvider);
    final previousState = state;

    final result = await deleteUseCase(id);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        final currentList = List<CategoryEntity>.from(previousState.value ?? []);
        currentList.removeWhere((c) => c.id == id);
        state = AsyncValue.data(currentList);
        if (Get.isRegistered<CategoriesController>()) {
          Get.find<CategoriesController>().categories.assignAll(currentList);
        }
        return true;
      },
    );
  }

  /// تنظيف الخطأ واستعادة الحالة السابقة
  void clearError() {
    if (state.hasError) {
      state = AsyncValue.data(state.value ?? []);
    }
  }
}

/// جسر توافقية (Compatibility Bridge) لـ GetX لضمان عمل نماذج الإدخال القديمة بسلاسة
class CategoriesController extends GetxController {
  final idController = TextEditingController();
  final nameArController = TextEditingController();
  final nameEnController = TextEditingController();
  final imageController = TextEditingController();
  final descArController = TextEditingController();
  final descEnController = TextEditingController();
  final iconController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString parentId = ''.obs;
  final RxBool isActive = true.obs;
  final categories = <CategoryEntity>[].obs;

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

  Map<String, dynamic> buildFormData() {
    return {
      'id': idController.text.trim(),
      'name': {
        'ar': nameArController.text.trim(),
        'en': nameEnController.text.trim(),
      },
      'image_url': imageController.text.trim(),
      'description': {
        'ar': descArController.text.trim(),
        'en': descEnController.text.trim(),
      },
      'sort_order': 0,
      'is_active': isActive.value,
      'parent_id': parentId.value.isEmpty ? null : parentId.value,
    };
  }

  Future<bool> saveCategory({String? existingId}) async {
    bool isSuccess = false;
    try {
      isLoading.value = true;
      final categoryData = buildFormData();

      if (Get.isRegistered<CategoryRepository>()) {
        final repo = Get.find<CategoryRepository>();
        if (existingId == null) {
          final res = await repo.addCategory(categoryData);
          isSuccess = res.fold(
            (l) {
              Get.snackbar('خطأ', l.toMessage());
              return false;
            },
            (r) {
              categories.add(r);
              Get.snackbar('نجاح', 'تم حفظ التصنيف بنجاح');
              return true;
            },
          );
        } else {
          final res = await repo.updateCategory(existingId, categoryData);
          isSuccess = res.fold(
            (l) {
              Get.snackbar('خطأ', l.toMessage());
              return false;
            },
            (r) {
              final idx = categories.indexWhere((c) => c.id == existingId);
              if (idx != -1) categories[idx] = r;
              Get.snackbar('نجاح', 'تم حفظ التصنيف بنجاح');
              return true;
            },
          );
        }
      } else {
        isSuccess = true;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حفظ التصنيف: $e');
      isSuccess = false;
    } finally {
      isLoading.value = false;
    }
    return isSuccess;
  }
}
