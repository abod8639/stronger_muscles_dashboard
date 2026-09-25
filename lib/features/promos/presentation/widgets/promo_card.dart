import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

/// بطاقة الإعلان الترويجي التي تحاكي بنسبة 100% شكل الإعلان داخل تطبيق المتجر
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

  /// لون التطبيق الأساسي في تطبيق الجوال (AppColors.primary)
  static const Color appPrimaryColor = Color(0xFFD32F2F);

  Color _parsePromoColor() {
    try {
      String hex = promo.backgroundColor.replaceAll('#', '').trim();
      if (hex.startsWith('0x') || hex.startsWith('0X')) {
        hex = hex.substring(2);
      }
      if (hex.length == 6) {
        return Color(int.parse('0xFF$hex'));
      } else if (hex.length == 8) {
        return Color(int.parse('0x$hex'));
      }
    } catch (_) {}
    return const Color(0xFF1E1E22);
  }

  String _getLocalizedTitle() {
    if (promo.title != null) {
      if (promo.title!.containsKey(locale) &&
          promo.title![locale]?.toString().trim().isNotEmpty == true) {
        return promo.title![locale].toString();
      }
    }
    return promo.displayTitle;
  }

  String _getLocalizedSubtitle() {
    if (promo.subtitle != null) {
      if (promo.subtitle!.containsKey(locale) &&
          promo.subtitle![locale]?.toString().trim().isNotEmpty == true) {
        return promo.subtitle![locale].toString();
      }
    }
    return promo.displaySubtitle;
  }

  String _getLocalizedButtonText() {
    if (promo.buttonText != null) {
      if (promo.buttonText!.containsKey(locale) &&
          promo.buttonText![locale]?.toString().trim().isNotEmpty == true) {
        return promo.buttonText![locale].toString().trim();
      }
    }
    final text = promo.displayButtonText.trim();
    if (text.isNotEmpty) return text;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _parsePromoColor();
    final title = _getLocalizedTitle();
    final subtitle = _getLocalizedSubtitle();
    final buttonText = _getLocalizedButtonText();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(16),
          color: bgColor,
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
            // صورة الإعلان المأخوذة من الكاش أو الرابط
            if (promo.imageUrl.isNotEmpty)
              CachedNetworkImage(
                cacheManager: CustomCacheManager.instance,
                imageUrl: promo.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) =>
                    Container(color: bgColor),
                placeholder: (context, url) => Container(
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
              )
            else
              Container(color: bgColor),

            // التدرج اللوني فوق الصورة في حال وجود عنوان
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

            // محتوى الإعلان (النصوص وزر التوجيه)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (title.isNotEmpty)
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .9),
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
    );
  }
}
