import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/image_gallery_editor.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';

/// قسم إدارة صورة الإعلان الرئيسية
class PromoImageSection extends StatelessWidget {
  final PromoFormController controller;

  const PromoImageSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final imageUrls = <String>[];
      if (controller.selectedImage.value != null) {
        imageUrls.add(controller.selectedImage.value!.path);
      } else if (controller.existingImageUrl.value.isNotEmpty) {
        imageUrls.add(controller.existingImageUrl.value);
      }

      return ImageGalleryEditor(
        imageUrls: imageUrls,
        onAddUrl: (url) {
          controller.existingImageUrl.value = url;
          controller.selectedImage.value = null;
        },
        onRemove: (index) {
          controller.existingImageUrl.value = '';
          controller.selectedImage.value = null;
        },
        onPickImage: () => controller.pickImage(),
        onReorder: (oldIndex, newIndex) {},
      );
    });
  }
}
