import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

/// بطاقة شبكة عامة: صورة (أو أيقونة بديلة) + عنوان + عنوان فرعي + شارة حالة
/// مع أزرار اختيارية في الزاوية ودعم حالة التحديد
class GenericGridCard<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final Widget? imageWidget;

  /// طريقة ملاءمة الصورة: contain للشعارات، cover للصور الكاملة
  final BoxFit imageFit;

  /// الأيقونة البديلة عند غياب الصورة أو فشل تحميلها
  final IconData icon;
  final Widget? statusWidget;
  final List<Widget>? actions;
  final VoidCallback? onTap;
  final bool selected;
  final T? data;

  const GenericGridCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.imageWidget,
    this.imageFit = BoxFit.cover,
    this.icon = Icons.image_outlined,
    this.statusWidget,
    this.actions,
    this.onTap,
    this.selected = false,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final placeholder = Center(
      child: Icon(
        icon,
        size: 40,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );

    return SoftSurface(
      selected: selected,
      onTap: onTap,
      padding: const EdgeInsets.all(AppDesignTokens.space12),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppDesignTokens.radiusMedium,
                  child: SizedBox.expand(
                    child: (imageUrl?.isNotEmpty ?? false)
                        ? CachedNetworkImage(
                            imageUrl: imageUrl!,
                            cacheManager: CustomCacheManager.instance,
                            fit: imageFit,
                            placeholder: (_, _) => placeholder,
                            errorWidget: (_, _, _) => placeholder,
                          )
                        : imageWidget ?? placeholder,
                  ),
                ),
              ),
              const SizedBox(height: AppDesignTokens.space10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              if (subtitle?.isNotEmpty ?? false) ...[
                const SizedBox(height: AppDesignTokens.space2),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (statusWidget != null) ...[
                const SizedBox(height: AppDesignTokens.space6),
                statusWidget!,
              ],
            ],
          ),
          if (actions?.isNotEmpty ?? false)
            PositionedDirectional(
              top: 0,
              end: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final action in actions!)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: AppDesignTokens.space4,
                      ),
                      child: action,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
