import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/repositories/category_repository.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/get_products_usecase.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/usecases/promo_usecases.dart';
import 'package:image_picker/image_picker.dart';

class PromosController extends GetxController {
  final GetPromosUseCase getPromosUseCase;
  final AddPromoUseCase addPromoUseCase;
  final UpdatePromoUseCase updatePromoUseCase;
  final DeletePromoUseCase deletePromoUseCase;
  final GetProductsUseCase getProductsUseCase;

  PromosController({
    required this.getPromosUseCase,
    required this.addPromoUseCase,
    required this.updatePromoUseCase,
    required this.deletePromoUseCase,
    required this.getProductsUseCase,
  });

  final promos = <PromoEntity>[].obs;
  final filteredPromos = <PromoEntity>[].obs;
  final products = <ProductEntity>[].obs;
  final categories = <CategoryEntity>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;

  // Form state — text fields
  final titleArController = TextEditingController();
  final titleEnController = TextEditingController();
  final subtitleArController = TextEditingController();
  final subtitleEnController = TextEditingController();
  final buttonArController = TextEditingController();
  final buttonEnController = TextEditingController();
  final backgroundColorController = TextEditingController();
  final backgroundColorHex = '#FFFFFF'.obs;


  // Form state — target
  /// 'none' | 'product' | 'category'
  final selectedTargetType = 'none'.obs;
  final selectedTargetId = Rxn<String>();

  // Form state — other
  final isActive = true.obs;
  final selectedImage = Rxn<File>();
  final existingImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPromos();
    fetchProducts();
    fetchCategories();
    
    // Listen to color hex changes for UI preview
    backgroundColorController.addListener(() {
      backgroundColorHex.value = backgroundColorController.text;
    });
  }

  Future<void> fetchPromos() async {
    isLoading.value = true;
    try {
      final data = await getPromosUseCase.call();
      promos.value = data;
      _applyFilters();
    } catch (e) {
      Get.snackbar(
        'خطأ', e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProducts() async {
    try {
      final data = await getProductsUseCase.call();
      products.assignAll(data);
    } catch (_) {}
  }

  Future<void> fetchCategories() async {
    try {
      // We can use categories from anywhere if we had GetCategoriesUseCase,
      // but if not registered we might skip.
      // For now let's see if we can get them.
      if (Get.isRegistered<CategoryRepository>()) {
         final data = await Get.find<CategoryRepository>().getCategories();
         categories.assignAll(data);
      }
    } catch (_) {}
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    if (searchQuery.value.isEmpty) {
      filteredPromos.value = promos;
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredPromos.value = promos.where((promo) {
        final matchesTitle = promo.displayTitle.toLowerCase().contains(query);
        final matchesSubtitle = promo.displaySubtitle.toLowerCase().contains(query);
        return matchesTitle || matchesSubtitle;
      }).toList();
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void clearForm() {
    titleArController.clear();
    titleEnController.clear();
    subtitleArController.clear();
    subtitleEnController.clear();
    buttonArController.clear();
    buttonEnController.clear();
    backgroundColorController.text = '#FFFFFF';
    backgroundColorHex.value = '#FFFFFF';
    selectedTargetType.value = 'none';
    selectedTargetId.value = null;
    isActive.value = true;
    selectedImage.value = null;
    existingImageUrl.value = '';
  }

  void populateForm(PromoEntity promo) {
    titleArController.text = promo.title?['ar']?.toString() ?? '';
    titleEnController.text = promo.title?['en']?.toString() ?? '';
    subtitleArController.text = promo.subtitle?['ar']?.toString() ?? '';
    subtitleEnController.text = promo.subtitle?['en']?.toString() ?? '';
    buttonArController.text = promo.buttonText?['ar']?.toString() ?? '';
    buttonEnController.text = promo.buttonText?['en']?.toString() ?? '';
    backgroundColorController.text = promo.backgroundColor;
    backgroundColorHex.value = promo.backgroundColor;

    selectedTargetType.value = promo.targetType;
    selectedTargetId.value = promo.targetId;
    isActive.value = promo.isActive;
    existingImageUrl.value = promo.imageUrl;
    selectedImage.value = null;
  }

  Future<void> savePromo({PromoEntity? existingPromo}) async {
    if (existingImageUrl.value.isEmpty && selectedImage.value == null) {
      Get.snackbar(
        'خطأ', 'يجب اختيار صورة للإعلان',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Validate target selection
    if (selectedTargetType.value == 'product' && (selectedTargetId.value == null || selectedTargetId.value!.isEmpty)) {
      Get.snackbar(
        'خطأ', 'يجب اختيار منتج للإعلان',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    if (selectedTargetType.value == 'category' && (selectedTargetId.value == null || selectedTargetId.value!.isEmpty)) {
      Get.snackbar(
        'خطأ', 'يجب اختيار فئة للإعلان',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // TODO: Handle actual image upload if a new file is selected.
    String finalImageUrl = existingImageUrl.value;
    if (selectedImage.value != null) {
      finalImageUrl = selectedImage.value!.path;
    }

    final targetId = selectedTargetType.value == 'none' ? null : selectedTargetId.value;

    final newPromo = PromoEntity(
      id: existingPromo?.id ?? '',
      title: {'ar': titleArController.text.trim(), 'en': titleEnController.text.trim()},
      subtitle: {'ar': subtitleArController.text.trim(), 'en': subtitleEnController.text.trim()},
      buttonText: {'ar': buttonArController.text.trim(), 'en': buttonEnController.text.trim()},
      imageUrl: finalImageUrl,
      backgroundColor: backgroundColorController.text.isNotEmpty ? backgroundColorController.text : '#FFFFFF',
      targetType: selectedTargetType.value,
      targetId: targetId,
      isActive: isActive.value,
    );

    isLoading.value = true;

    try {
      if (existingPromo != null) {
        final updated = await updatePromoUseCase.call(newPromo);
        final index = promos.indexWhere((p) => p.id == updated.id);
        if (index != -1) {
          promos[index] = updated;
          _applyFilters();
        }
        Get.back();
        Get.snackbar(
          'نجاح', 'تم تحديث الإعلان بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        final added = await addPromoUseCase.call(newPromo);
        promos.insert(0, added);
        _applyFilters();
        Get.back();
        Get.snackbar(
          'نجاح', 'تمت إضافة الإعلان بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ', e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void confirmDelete(String id, String title) {
    Get.defaultDialog(
      title: 'تأكيد الحذف',
      middleText: 'هل أنت متأكد أنك تريد حذف الإعلان "$title"؟',
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        _deletePromo(id);
      },
    );
  }

  Future<void> _deletePromo(String id) async {
    try {
      await deletePromoUseCase.call(id);
      promos.removeWhere((p) => p.id == id);
      _applyFilters();
      Get.snackbar(
        'نجاح', 'تم حذف الإعلان بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ', e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    titleArController.dispose();
    titleEnController.dispose();
    subtitleArController.dispose();
    subtitleEnController.dispose();
    buttonArController.dispose();
    buttonEnController.dispose();
    backgroundColorController.dispose();
    super.onClose();
  }
}
