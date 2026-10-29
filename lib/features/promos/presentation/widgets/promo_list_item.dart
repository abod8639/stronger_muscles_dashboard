import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/core/utils/color_utils.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_providers.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/promo_status_pill.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

/// عنصر قائمة الإعلانات: معاينة مصغرة + العنوان والحالة والتوجيه + أزرار التعديل والحذف
class PromoListItem extends ConsumerWidget {
  final PromoEntity promo;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PromoListItem({
    super.key,
    required this.promo,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;

    final actions = [
      SoftIconButton(
        icon: Icons.edit_rounded,
        tooltip: 'تعديل',
        onPressed: onEdit,
      ),
      SoftIconButton(
        icon: Icons.delete_outline_rounded,
        tooltip: 'حذف',
        color: colorScheme.error,
        onPressed: onDelete,
      ),
    ];

    return SoftSurface(
      onTap: onEdit,
      borderRadius: AppDesignTokens.radiusCard,
      padding: EdgeInsets.all(
        isMobile ? AppDesignTokens.space10 : AppDesignTokens.space14,
      ),
      child: Row(
        children: [
          _Thumbnail(
            promo: promo,
            width: isMobile ? 104 : 150,
            height: isMobile ? 64 : 76,
          ),
          SizedBox(
            width: isMobile ? AppDesignTokens.space10 : AppDesignTokens.space16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  promo.displayTitle.isNotEmpty
                      ? promo.displayTitle
                      : 'بدون عنوان',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (promo.displaySubtitle.isNotEmpty) ...[
                  const SizedBox(height: AppDesignTokens.space4),
                  Text(
                    promo.displaySubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: AppDesignTokens.space8),
                Wrap(
                  spacing: AppDesignTokens.space6,
                  runSpacing: AppDesignTokens.space4,
                  children: [
                    PromoStatusPill(isActive: promo.isActive),
                    _targetPill(ref),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDesignTokens.space10),
          // على الهاتف تُرصّ الأزرار عمودياً لتوفير عرض للنص
          isMobile
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    actions[0],
                    const SizedBox(height: AppDesignTokens.space8),
                    actions[1],
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    actions[0],
                    const SizedBox(width: AppDesignTokens.space8),
                    actions[1],
                  ],
                ),
        ],
      ),
    );
  }

  Widget _targetPill(WidgetRef ref) {
    final hasTarget = promo.targetId?.isNotEmpty ?? false;
    final (IconData icon, String label) = switch (promo.targetType) {
      'product' => (
        Icons.inventory_2_rounded,
        hasTarget ? 'منتج: ${promo.targetId}' : 'منتج: غير محدد',
      ),
      'brand' => (
        Icons.category_rounded,
        hasTarget
            ? 'ماركة: ${ref.watch(promosControllerProvider).getBrandName(promo.targetId)}'
            : 'ماركة: غير محددة',
      ),
      _ => (Icons.block, 'بدون توجيه'),
    };
    return InfoPill(icon: icon, label: label);
  }
}

class _Thumbnail extends StatelessWidget {
  final PromoEntity promo;
  final double width;
  final double height;

  const _Thumbnail({
    required this.promo,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final placeholderColor = colorScheme.onSurfaceVariant.withValues(
      alpha: 0.5,
    );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: parseHexColor(
          promo.backgroundColor,
          fallback: colorScheme.surfaceContainerHighest,
        ),
        borderRadius: AppDesignTokens.radiusSmall,
        boxShadow: AppDesignTokens.subtleShadow(
          Theme.of(context).brightness == Brightness.dark,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: promo.imageUrl.isNotEmpty
          ? CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              imageUrl: promo.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => Icon(Icons.image, color: placeholderColor),
              errorWidget: (_, _, _) =>
                  Icon(Icons.broken_image, color: placeholderColor),
            )
          : Icon(Icons.campaign_rounded, color: colorScheme.onSurfaceVariant),
    );
  }
}
