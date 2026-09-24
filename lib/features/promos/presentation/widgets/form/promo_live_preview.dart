import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';

/// معاينة مباشرة وتفاعلية للإعلان تحاكي ظهوره في تطبيق المتجر
class PromoLivePreview extends StatelessWidget {
  final PromoFormController controller;

  const PromoLivePreview({super.key, required this.controller});

  Color _parseColor(String hex) {
    try {
      final cleanHex = hex.replaceAll('#', '');
      if (cleanHex.length == 6) {
        return Color(int.parse('FF$cleanHex', radix: 16));
      }
    } catch (_) {}
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      final bgColor = _parseColor(controller.backgroundColorHex.value);
      final isDarkBg =
          ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark;
      final textColor = isDarkBg ? Colors.white : Colors.black87;
      final subtextColor = isDarkBg ? Colors.white70 : Colors.black54;

      final title = controller.titleArController.text.isNotEmpty
          ? controller.titleArController.text
          : (controller.titleEnController.text.isNotEmpty
              ? controller.titleEnController.text
              : 'عنوان الإعلان الترويجي');

      final subtitle = controller.subtitleArController.text.isNotEmpty
          ? controller.subtitleArController.text
          : (controller.subtitleEnController.text.isNotEmpty
              ? controller.subtitleEnController.text
              : 'وصف جذاب يوضح تفاصيل العرض');

      final buttonText = controller.buttonArController.text.isNotEmpty
          ? controller.buttonArController.text
          : (controller.buttonEnController.text.isNotEmpty
              ? controller.buttonEnController.text
              : 'تسوق الآن');

      final hasLocalImage = controller.selectedImage.value != null;
      final hasRemoteImage = controller.existingImageUrl.value.isNotEmpty;

      return Container(
        height: 175,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              left: -20,
              bottom: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDarkBg ? Colors.white : Colors.black)
                      .withValues(alpha: 0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: subtextColor,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDarkBg ? Colors.white : Colors.black87,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            buttonText,
                            style: TextStyle(
                              color: isDarkBg ? Colors.black87 : Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 135,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: (isDarkBg ? Colors.white : Colors.black)
                            .withValues(alpha: 0.06),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: hasLocalImage
                          ? Image.file(
                              controller.selectedImage.value!,
                              fit: BoxFit.cover,
                            )
                          : (hasRemoteImage
                              ? CachedNetworkImage(
                                  imageUrl: controller.existingImageUrl.value,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, _, _) => Icon(
                                    Icons.campaign_outlined,
                                    size: 40,
                                    color: subtextColor,
                                  ),
                                  placeholder: (_, _) => Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 28,
                                        color: subtextColor,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'اختر صورة',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: subtextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: controller.isActive.value
                      ? Colors.green.shade700
                      : Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  controller.isActive.value ? 'نشط' : 'غير نشط',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
