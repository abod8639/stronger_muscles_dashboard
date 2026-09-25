import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

/// معاينة مباشرة وتفاعلية للإعلان داخل شاشة النموذج تحاكي ظهوره في تطبيق المتجر بنسبة 100%
class PromoLivePreview extends StatefulWidget {
  final PromoFormController controller;

  const PromoLivePreview({super.key, required this.controller});

  @override
  State<PromoLivePreview> createState() => _PromoLivePreviewState();
}

class _PromoLivePreviewState extends State<PromoLivePreview> {
  String _previewLocale = 'ar';

  static const Color appPrimaryColor = Color(0xFFD32F2F);

  Color _parseColor(String hex) {
    try {
      final cleanHex = hex.replaceAll('#', '').trim();
      if (cleanHex.length == 6) {
        return Color(int.parse('FF$cleanHex', radix: 16));
      } else if (cleanHex.length == 8) {
        return Color(int.parse(cleanHex, radix: 16));
      }
    } catch (_) {}
    return const Color(0xFF1E1E22);
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Obx(() {
      final bgColor = _parseColor(controller.backgroundColorHex.value);

      final isArabic = _previewLocale == 'ar';
      final title = isArabic
          ? (controller.titleArController.text.isNotEmpty
              ? controller.titleArController.text
              : controller.titleEnController.text)
          : (controller.titleEnController.text.isNotEmpty
              ? controller.titleEnController.text
              : controller.titleArController.text);

      final subtitle = isArabic
          ? (controller.subtitleArController.text.isNotEmpty
              ? controller.subtitleArController.text
              : controller.subtitleEnController.text)
          : (controller.subtitleEnController.text.isNotEmpty
              ? controller.subtitleEnController.text
              : controller.subtitleArController.text);

      final buttonText = isArabic
          ? (controller.buttonArController.text.isNotEmpty
              ? controller.buttonArController.text
              : (controller.buttonEnController.text.isNotEmpty
                  ? controller.buttonEnController.text
                  : 'تسوق الآن'))
          : (controller.buttonEnController.text.isNotEmpty
              ? controller.buttonEnController.text
              : (controller.buttonArController.text.isNotEmpty
                  ? controller.buttonArController.text
                  : 'Shop Now'));

      final hasTarget = controller.selectedTargetId.value != null &&
          controller.selectedTargetId.value!.isNotEmpty;

      final hasLocalImage = controller.selectedImage.value != null;
      final hasRemoteImage = controller.existingImageUrl.value.isNotEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // مفتاح تبديل لغة المعاينة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.isActive.value
                          ? Colors.green
                          : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    controller.isActive.value
                        ? 'الإعلان نشط بالتطبيق'
                        : 'الإعلان متوقف (غير نشط)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: controller.isActive.value
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPill('ar', 'عربي'),
                    _buildPill('en', 'EN'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // كارد المحاكاة المباشر لمواصفات تطبيق المتجر
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // صورة الخلفية
                if (hasLocalImage)
                  Image.file(
                    controller.selectedImage.value!,
                    fit: BoxFit.cover,
                  )
                else if (hasRemoteImage)
                  CachedNetworkImage(
                    cacheManager: CustomCacheManager.instance,
                    imageUrl: controller.existingImageUrl.value,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => Container(color: bgColor),
                    placeholder: (_, _) => Container(
                      color: bgColor,
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    color: bgColor,
                    child: Center(
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 36,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ),

                // تدرج لوني لضمان وضوح النصوص
                if (title.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: .8),
                          Colors.black.withValues(alpha: .2),
                        ],
                        begin: AlignmentDirectional.centerStart,
                        end: AlignmentDirectional.centerEnd,
                      ),
                    ),
                  ),

                // نصوص الإعلان وزر الإجراء
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title.isNotEmpty ? title : 'عنوان الإعلان الترويجي',
                        style: TextStyle(
                          color: title.isNotEmpty
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle.isNotEmpty
                            ? subtitle
                            : 'وصف جذاب يوضح تفاصيل العرض الترويجي',
                        style: TextStyle(
                          color: subtitle.isNotEmpty
                              ? Colors.white.withValues(alpha: .9)
                              : Colors.white.withValues(alpha: 0.4),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (hasTarget || buttonText.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: appPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPill(String locale, String label) {
    final isSelected = _previewLocale == locale;
    return GestureDetector(
      onTap: () {
        setState(() => _previewLocale = locale);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? appPrimaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
