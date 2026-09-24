import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/repositories/brand_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/get_products_usecase.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/usecases/promo_usecases.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_controller.dart';

/// متحكم مخصص لإدارة نموذج إنشاء وتعديل الإعلانات الترويجية وفق معايير Clean Architecture
class PromoFormController extends GetxController {
  final PromoEntity? initialPromo;
  final AddPromoUseCase addPromoUseCase;
  final UpdatePromoUseCase updatePromoUseCase;
  final UploadPromoImageUseCase uploadPromoImageUseCase;
  final PromosController? promosController;
  final GetProductsUseCase? getProductsUseCase;

  PromoFormController({
    this.initialPromo,
    required this.addPromoUseCase,
    required this.updatePromoUseCase,
    required this.uploadPromoImageUseCase,
    this.promosController,
    this.getProductsUseCase,
  });

  bool get isEditing => initialPromo != null;

  // Form State — Text Controllers
  final titleArController = TextEditingController();
  final titleEnController = TextEditingController();
  final subtitleArController = TextEditingController();
  final subtitleEnController = TextEditingController();
  final buttonArController = TextEditingController();
  final buttonEnController = TextEditingController();
  final backgroundColorController = TextEditingController();

  // Reactive State
  final backgroundColorHex = '#FFFFFF'.obs;
  final selectedTargetType = 'none'.obs;
  final selectedTargetId = Rxn<String>();
  final isActive = true.obs;
  final selectedImage = Rxn<File>();
  final existingImageUrl = ''.obs;
  final isLoading = false.obs;
  final isBrandsLoading = false.obs;

  // Cache & Reference Lists
  final products = <ProductEntity>[].obs;
  final brands = <BrandEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initFormValues();
    _loadDependencies();

    backgroundColorController.addListener(() {
      backgroundColorHex.value = backgroundColorController.text;
    });
  }

  void _initFormValues() {
    if (initialPromo != null) {
      final promo = initialPromo!;
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
    } else {
      backgroundColorController.text = '#FFFFFF';
      backgroundColorHex.value = '#FFFFFF';
      selectedTargetType.value = 'none';
      selectedTargetId.value = null;
      isActive.value = true;
    }
  }

  Future<void> _loadDependencies() async {
    // مزامنة المنتجات والماركات من المتحكم الرئيسي إن وجد، أو جلبها مباشرة
    if (promosController != null) {
      products.assignAll(promosController!.products);
      brands.assignAll(promosController!.brands);
      isBrandsLoading.value = promosController!.isBrandsLoading.value;
    }

    if (products.isEmpty && getProductsUseCase != null) {
      try {
        final fetched = await getProductsUseCase!.call();
        products.assignAll(fetched);
      } catch (_) {}
    }

    if (brands.isEmpty && Get.isRegistered<BrandRepository>()) {
      isBrandsLoading.value = true;
      try {
        final fetched = await Get.find<BrandRepository>().getBrands();
        brands.assignAll(fetched);
      } catch (_) {
      } finally {
        isBrandsLoading.value = false;
      }
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void setPresetColor(String hex) {
    backgroundColorController.text = hex;
    backgroundColorHex.value = hex;
  }

  Future<void> savePromo() async {
    if (existingImageUrl.value.isEmpty && selectedImage.value == null) {
      Get.snackbar(
        'خطأ',
        'يجب اختيار صورة للإعلان',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    // التحقق من صحة توجيه الإعلان
    if (selectedTargetType.value == 'product' &&
        (selectedTargetId.value == null || selectedTargetId.value!.isEmpty)) {
      Get.snackbar(
        'خطأ',
        'يجب اختيار منتج للإعلان',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (selectedTargetType.value == 'brand' &&
        (selectedTargetId.value == null || selectedTargetId.value!.isEmpty)) {
      Get.snackbar(
        'خطأ',
        'يجب اختيار ماركة للإعلان',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    String finalImageUrl = existingImageUrl.value;
    try {
      if (selectedImage.value != null) {
        finalImageUrl =
            await uploadPromoImageUseCase.call(selectedImage.value!.path);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'خطأ',
        'فشل في رفع الصورة: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    final targetId =
        selectedTargetType.value == 'none' ? null : selectedTargetId.value;

    final promoData = PromoEntity(
      id: initialPromo?.id ?? '',
      title: {
        'ar': titleArController.text.trim(),
        'en': titleEnController.text.trim()
      },
      subtitle: {
        'ar': subtitleArController.text.trim(),
        'en': subtitleEnController.text.trim()
      },
      buttonText: {
        'ar': buttonArController.text.trim(),
        'en': buttonEnController.text.trim()
      },
      imageUrl: finalImageUrl,
      backgroundColor: backgroundColorController.text.isNotEmpty
          ? backgroundColorController.text
          : '#FFFFFF',
      targetType: selectedTargetType.value,
      targetId: targetId,
      isActive: isActive.value,
    );

    try {
      if (isEditing) {
        final updated = await updatePromoUseCase.call(promoData);
        if (promosController != null) {
          final index =
              promosController!.promos.indexWhere((p) => p.id == updated.id);
          if (index != -1) {
            promosController!.promos[index] = updated;
            promosController!.onSearchChanged(promosController!.searchQuery.value);
          }
        }
        Get.back();
        Get.snackbar(
          'نجاح',
          'تم تحديث الإعلان بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      } else {
        final added = await addPromoUseCase.call(promoData);
        if (promosController != null) {
          promosController!.promos.insert(0, added);
          promosController!.onSearchChanged(promosController!.searchQuery.value);
        }
        Get.back();
        Get.snackbar(
          'نجاح',
          'تمت إضافة الإعلان بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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
