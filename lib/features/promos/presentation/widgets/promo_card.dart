import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/color_utils.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

/// لون التطبيق الأساسي في تطبيق المتجر (للمحاكاة فقط، وليس جزءاً من ثيم لوحة التحكم)
const Color kStoreAppPrimaryColor = Color(0xFFD32F2F);

/// بطاقة الإعلان الترويجي كما تظهر داخل تطبيق المتجر
class PromoCard extends StatelessWidget {
  final PromoEntity promo;
  final String locale;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const PromoCard({
    super.key,
    required this.promo,
    this.locale = 'ar',
    this.onTap,
    this.margin,
  });

  String _localized(Map<String, dynamic>? values, String fallback) {
    final value = values?[locale]?.toString().trim() ?? '';
    return value.isNotEmpty ? value : fallback.trim();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = parseHexColor(promo.backgroundColor);

    return PromoBannerView(
      backgroundColor: bgColor,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
      title: _localized(promo.title, promo.displayTitle),
      subtitle: _localized(promo.subtitle, promo.displaySubtitle),
      buttonText: _localized(promo.buttonText, promo.displayButtonText),
      image: promo.imageUrl.isEmpty
          ? null
          : CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              imageUrl: promo.imageUrl,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => ColoredBox(color: bgColor),
              placeholder: (_, _) => ColoredBox(
                color: bgColor,
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white60,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

/// العرض المرئي لبانر الإعلان (الخلفية + الصورة + التدرج + النصوص + الزر)
/// يُستخدم في بطاقة الإعلان وفي المعاينة المباشرة داخل النموذج
class PromoBannerView extends StatelessWidget {
  final Color backgroundColor;
  final Widget? image;
  final String title;
  final String subtitle;
  final String buttonText;

  /// نص بديل باهت يظهر عند فراغ العنوان أو الوصف (للمعاينة أثناء التحرير)
  final String? titleHint;
  final String? subtitleHint;

  /// أيقونة تظهر في المنتصف عند غياب الصورة (للمعاينة أثناء التحرير)
  final IconData? emptyImageIcon;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const PromoBannerView({
    super.key,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.image,
    this.titleHint,
    this.subtitleHint,
    this.emptyImageIcon,
    this.borderRadius,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final showTitle = title.isNotEmpty || titleHint != null;
    final showSubtitle = subtitle.isNotEmpty || subtitleHint != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
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
            if (image != null)
              image!
            else if (emptyImageIcon != null)
              Center(
                child: Icon(
                  emptyImageIcon,
                  size: 36,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),

            // التدرج يضمن وضوح النص فوق الصورة
            if (showTitle)
              DecoratedBox(
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

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showTitle)
                    Text(
                      title.isNotEmpty ? title : titleHint!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: title.isNotEmpty ? 1 : 0.5,
                        ),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (showSubtitle) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle.isNotEmpty ? subtitle : subtitleHint!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: subtitle.isNotEmpty ? .9 : 0.4,
                        ),
                        fontSize: 14,
                      ),
                    ),
                  ],
                  if (buttonText.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: kStoreAppPrimaryColor,
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
    );
  }
}
