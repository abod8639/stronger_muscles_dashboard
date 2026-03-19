import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/repositories/brand_repository.dart';
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
  final UploadPromoImageUseCase uploadPromoImageUseCase;

  PromosController({
    required this.getPromosUseCase,
    required this.addPromoUseCase,
    required this.updatePromoUseCase,
    required this.deletePromoUseCase,
    required this.getProductsUseCase,
    required this.uploadPromoImageUseCase,
  });

  final promos = <PromoEntity>[].obs;
  final filteredPromos = <PromoEntity>[].obs;
  final products = <ProductEntity>[].obs;
  final brands = <BrandEntity>[].obs;
  final isLoading = true.obs;
  final isBrandsLoading = false.obs;
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
    fetchBrands();
    
    // Listen to color hex changes for UI preview
    backgroundColorController.addListener(() {
      backgroundColorHex.value = backgroundColorController.text;
    });
  }

  String getBrandName(String? id) {
    if (id == null || id.isEmpty) return 'غير محدد';
    final brand = brands.firstWhereOrNull((b) => b.id == id);
    return brand?.displayName ?? 'ماركة #$id';
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

  Future<void> fetchBrands() async {
    isBrandsLoading.value = true;
    try {
      print('🔍 [PromosController] Fetching brands...');
      if (Get.isRegistered<BrandRepository>()) {
         final data = await Get.find<BrandRepository>().getBrands();
         print('✅ [PromosController] Fetched ${data.length} brands');
         brands.assignAll(data);
      } else {
        print('⚠️ [PromosController] BrandRepository is not registered!');
      }
    } catch (e) {
      print('❌ [PromosController] Error fetching brands: $e');
    } finally {
      isBrandsLoading.value = false;
    }
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
    selectedTargetId.value = promo.targetId ?? '';
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
    if (selectedTargetType.value == 'brand' && (selectedTargetId.value == null || selectedTargetId.value!.isEmpty)) {
      Get.snackbar(
        'خطأ', 'يجب اختيار ماركة للإعلان',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    String finalImageUrl = existingImageUrl.value;
    try {
      if (selectedImage.value != null) {
        finalImageUrl = await uploadPromoImageUseCase.call(selectedImage.value!.path);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'خطأ', 'فشل في رفع الصورة: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
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

    // isLoading.value is already true from before the image upload

    try {
      if (existingPromo != null) {
        final updated = await updatePromoUseCase.call(newPromo);
        final index = promos.indexWhere((p) => p.id == updated.id);
        if (index != -1) {
          promos[index] = updated;
          _applyFilters();
        }
        print(promos);
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
