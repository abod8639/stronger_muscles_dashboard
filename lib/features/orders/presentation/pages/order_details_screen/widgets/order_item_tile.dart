import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/components/price_text.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/settings/settings_feature.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

/// عنصر منتج داخل الطلب: الصورة، الاسم، الكمية × السعر، الخصائص، والإجمالي الفرعي
class OrderItemTile extends ConsumerWidget {
  final OrderItemEntity item;

  const OrderItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currency = ref.watch(storeCurrencyProvider);
    final isMobile = context.isMobile;
    final imageSize = isMobile ? 56.0 : 64.0;
    final placeholder = Icon(
      Icons.inventory_2_outlined,
      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      size: 24,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? AppDesignTokens.space14
            : AppDesignTokens.space18,
        vertical: AppDesignTokens.space14,
      ),
      child: Row(
        children: [
          SoftSurface(
            compact: true,
            width: imageSize,
            height: imageSize,
            borderRadius: AppDesignTokens.radiusMedium,
            child: ClipRRect(
              borderRadius: AppDesignTokens.radiusMedium,
              child: (item.imageUrl?.isNotEmpty ?? false)
                  ? CachedNetworkImage(
                      cacheManager: CustomCacheManager.instance,
                      imageUrl: item.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => ColoredBox(
                        color: colorScheme.surfaceContainerHighest,
                      ),
                      errorWidget: (_, _, _) => placeholder,
                    )
                  : placeholder,
            ),
          ),
          const SizedBox(width: AppDesignTokens.space14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppDesignTokens.space4),
                Text(
                  '${item.quantity} × ${formatPrice(item.unitPrice, currency)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if ((item.selectedFlavor?.isNotEmpty ?? false) ||
                    (item.selectedSize?.isNotEmpty ?? false)) ...[
                  const SizedBox(height: AppDesignTokens.space6),
                  Wrap(
                    spacing: AppDesignTokens.space6,
                    runSpacing: AppDesignTokens.space4,
                    children: [
                      if (item.selectedFlavor?.isNotEmpty ?? false)
                        InfoPill(
                          icon: Icons.local_cafe_outlined,
                          label: item.selectedFlavor!,
                        ),
                      if (item.selectedSize?.isNotEmpty ?? false)
                        InfoPill(
                          icon: Icons.straighten_outlined,
                          label: item.selectedSize!,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppDesignTokens.space12),
          SoftSurface(
            compact: true,
            borderRadius: AppDesignTokens.radiusMedium,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesignTokens.space12,
              vertical: AppDesignTokens.space8,
            ),
            child: PriceText(
              amount: item.subtotal,
              currency: currency,
              color: colorScheme.primary,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
