import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/image_gallery_editor.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';

/// قسم إدارة صورة الإعلان الرئيسية
class PromoImageSection extends StatelessWidget {
  final PromoFormController controller;

  const PromoImageSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final imageUrls = <String>[];
        if (controller.selectedImage != null) {
          imageUrls.add(controller.selectedImage!.path);
        } else if (controller.existingImageUrl.isNotEmpty) {
          imageUrls.add(controller.existingImageUrl);
        }

        return ImageGalleryEditor(
          imageUrls: imageUrls,
          onAddUrl: (url) {
            controller.existingImageUrl = url;
            controller.selectedImage = null;
          },
          onRemove: (index) {
            controller.existingImageUrl = '';
            controller.selectedImage = null;
          },
          onPickImage: () => controller.pickImage(),
          onReorder: (oldIndex, newIndex) {},
        );
      },
    );
  }
}
