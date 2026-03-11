import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/usecases/promo_usecases.dart';
import 'package:image_picker/image_picker.dart';

class PromosController extends GetxController {
  final GetPromosUseCase getPromosUseCase;
  final AddPromoUseCase addPromoUseCase;
  final UpdatePromoUseCase updatePromoUseCase;
  final DeletePromoUseCase deletePromoUseCase;

  PromosController({
    required this.getPromosUseCase,
    required this.addPromoUseCase,
    required this.updatePromoUseCase,
    required this.deletePromoUseCase,
  });

  final promos = <PromoEntity>[].obs;
  final filteredPromos = <PromoEntity>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;

  // Form state
  final titleArController = TextEditingController();
  final titleEnController = TextEditingController();
  final subtitleArController = TextEditingController();
  final subtitleEnController = TextEditingController();
  final buttonArController = TextEditingController();
  final buttonEnController = TextEditingController();
  final targetUrlController = TextEditingController();
  final backgroundColorController = TextEditingController();
  final isActive = true.obs;
  final selectedImage = Rxn<File>();
  final existingImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPromos();
  }

  Future<void> fetchPromos() async {
    isLoading.value = true;
    try {
      final data = await getPromosUseCase.call();
      promos.value = data;
      _applyFilters();
    } catch (e) {
      Get.snackbar('خطأ', e.toString().replaceAll('Exception: ', ''), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
    } finally {
      isLoading.value = false;
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
    targetUrlController.clear();
    backgroundColorController.text = '#FFFFFF';
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
    targetUrlController.text = promo.targetUrl ?? '';
    backgroundColorController.text = promo.backgroundColor;
    isActive.value = promo.isActive;
    existingImageUrl.value = promo.imageUrl;
    selectedImage.value = null; // Clear picked image
  }


  Future<void> savePromo({PromoEntity? existingPromo}) async {
    if (existingImageUrl.value.isEmpty && selectedImage.value == null) {
      Get.snackbar('خطأ', 'يجب اختيار صورة للإعلان', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
      return;
    }

    // TODO: Handle actual image upload if a new file is selected.
    String finalImageUrl = existingImageUrl.value;
    if (selectedImage.value != null) {
        // finalImageUrl = await _uploadImage(selectedImage.value!); // Uncomment when upload logic is set
        finalImageUrl = selectedImage.value!.path; // Temporary local path just to prevent crash
    }

    final newPromo = PromoEntity(
      id: existingPromo?.id ?? '', // empty for new
      title: {'ar': titleArController.text, 'en': titleEnController.text},
      subtitle: {'ar': subtitleArController.text, 'en': subtitleEnController.text},
      buttonText: {'ar': buttonArController.text, 'en': buttonEnController.text},
      imageUrl: finalImageUrl,
      backgroundColor: backgroundColorController.text.isNotEmpty ? backgroundColorController.text : '#FFFFFF',
      targetUrl: targetUrlController.text,
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
        Get.snackbar('نجاح', 'تم تحديث الإعلان بنجاح', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green.withOpacity(0.8), colorText: Colors.white);
      } else {
        final added = await addPromoUseCase.call(newPromo);
        promos.insert(0, added);
        _applyFilters();
        Get.back();
        Get.snackbar('نجاح', 'تمت إضافة الإعلان بنجاح', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green.withOpacity(0.8), colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('خطأ', e.toString().replaceAll('Exception: ', ''), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
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
      Get.snackbar('نجاح', 'تم حذف الإعلان بنجاح', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green.withOpacity(0.8), colorText: Colors.white);
    } catch (e) {
      Get.snackbar('خطأ', e.toString().replaceAll('Exception: ', ''), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
    }
  }
}

