import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/core/utils/color_utils.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/promo_card.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/promo_locale_toggle.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/promo_status_pill.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

/// معاينة مباشرة للإعلان أثناء التحرير، بنفس عرض [PromoBannerView] المستخدم في تطبيق المتجر
class PromoLivePreview extends StatefulWidget {
  final PromoFormController controller;

  const PromoLivePreview({super.key, required this.controller});

  @override
  State<PromoLivePreview> createState() => _PromoLivePreviewState();
}

class _PromoLivePreviewState extends State<PromoLivePreview> {
  String _previewLocale = 'ar';

  /// النص باللغة المختارة، أو باللغة الأخرى إن كان فارغاً
  String _pick(TextEditingController ar, TextEditingController en) {
    final (primary, secondary) = _previewLocale == 'ar' ? (ar, en) : (en, ar);
    final text = primary.text.trim();
    return text.isNotEmpty ? text : secondary.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final bgColor = parseHexColor(controller.backgroundColorHex);

        final Widget? image;
        if (controller.selectedImage != null) {
          image = Image.file(controller.selectedImage!, fit: BoxFit.cover);
        } else if (controller.existingImageUrl.isNotEmpty) {
          image = CachedNetworkImage(
            cacheManager: CustomCacheManager.instance,
            imageUrl: controller.existingImageUrl,
            fit: BoxFit.cover,
            errorWidget: (_, _, _) => ColoredBox(color: bgColor),
            placeholder: (_, _) => ColoredBox(color: bgColor),
          );
        } else {
          image = null;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PromoStatusPill(isActive: controller.isActive),
                PromoLocaleToggle(
                  locale: _previewLocale,
                  onChanged: (locale) =>
                      setState(() => _previewLocale = locale),
                ),
              ],
            ),
            const SizedBox(height: AppDesignTokens.space10),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: PromoBannerView(
                backgroundColor: bgColor,
                borderRadius: AppDesignTokens.radiusCard,
                image: image,
                emptyImageIcon: Icons.add_photo_alternate_outlined,
                title: _pick(
                  controller.titleArController,
                  controller.titleEnController,
                ),
                titleHint: 'عنوان الإعلان الترويجي',
                subtitle: _pick(
                  controller.subtitleArController,
                  controller.subtitleEnController,
                ),
                subtitleHint: 'وصف جذاب يوضح تفاصيل العرض الترويجي',
                buttonText: _pick(
                  controller.buttonArController,
                  controller.buttonEnController,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
