import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/price_text.dart';
import 'package:stronger_muscles_dashboard/features/settings/settings_feature.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/components/stock_status_badge.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

/// بطاقة المنتج في قائمة المنتجات (تدعم وضع التحديد المتعدد)
class ProductCard extends ConsumerWidget {
  final ProductEntity product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onToggleSelect;
  final VoidCallback? onLongPress;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onToggleSelect,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;

    return SoftSurface(
      selected: isSelected,
      onTap: isSelectionMode ? onToggleSelect : onEdit,
      onLongPress: onLongPress,
      padding: EdgeInsets.all(
        isMobile ? AppDesignTokens.space12 : AppDesignTokens.space16,
      ),
      child: Row(
        children: [
          if (isSelectionMode) ...[
            Checkbox(
              value: isSelected,
              onChanged: (_) => onToggleSelect?.call(),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: AppDesignTokens.space4),
          ],
          _ProductImage(product: product, size: isMobile ? 80 : 105),
          SizedBox(
            width: isMobile ? AppDesignTokens.space12 : AppDesignTokens.space20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppDesignTokens.space6,
                  runSpacing: AppDesignTokens.space4,
                  children: [
                    InfoPill(
                      label: (product.brand ?? 'GENERIC').toUpperCase(),
                      color: colorScheme.primary,
                    ),
                    InfoPill(
                      label: product.isActive ? 'نشط' : 'معطل',
                      icon: product.isActive
                          ? Icons.check_circle_rounded
                          : Icons.pause_circle_rounded,
                      color: product.isActive
                          ? AppColors.success
                          : colorScheme.error,
                    ),
                  ],
                ),
                const SizedBox(height: AppDesignTokens.space6),
                Text(
                  product.nameAr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontSize: isMobile ? 15 : 17,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (product.flavors?.isNotEmpty ?? false) ...[
                  const SizedBox(height: AppDesignTokens.space8),
                  _FlavorTags(
                    flavors: product.flavors!,
                    limit: isMobile ? 1 : 3,
                  ),
                ],
                const SizedBox(height: AppDesignTokens.space12),
                Wrap(
                  spacing: AppDesignTokens.space16,
                  runSpacing: AppDesignTokens.space8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    PriceText(
                      amount: product.price,
                      currency: ref.watch(storeCurrencyProvider),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: isMobile ? 18 : 22,
                      ),
                    ),
                    StockStatusBadge(quantity: product.stockQuantity),
                  ],
                ),
              ],
            ),
          ),
          if (!isSelectionMode) ...[
            const SizedBox(width: AppDesignTokens.space12),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SoftIconButton(
                  icon: Icons.edit_outlined,
                  tooltip: 'تعديل',
                  color: colorScheme.primary,
                  onPressed: onEdit,
                ),
                const SizedBox(height: AppDesignTokens.space10),
                SoftIconButton(
                  icon: Icons.delete_outline,
                  tooltip: 'حذف',
                  color: colorScheme.error,
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final ProductEntity product;
  final double size;

  const _ProductImage({required this.product, required this.size});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final placeholderColor = colorScheme.onSurfaceVariant.withValues(
      alpha: 0.5,
    );

    return SoftSurface(
      compact: true,
      width: size,
      height: size,
      borderRadius: AppDesignTokens.radiusCard,
      child: ClipRRect(
        borderRadius: AppDesignTokens.radiusCard,
        child: product.imageUrls.isNotEmpty
            ? CachedNetworkImage(
                cacheManager: CustomCacheManager.instance,
                imageUrl: product.imageUrls.first,
                fit: BoxFit.cover,
                placeholder: (_, _) => Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                errorWidget: (_, _, _) => Icon(
                  Icons.broken_image_rounded,
                  color: placeholderColor,
                  size: 28,
                ),
              )
            : Icon(
                Icons.inventory_2_rounded,
                color: placeholderColor,
                size: 32,
              ),
      ),
    );
  }
}

class _FlavorTags extends StatelessWidget {
  final List<String> flavors;
  final int limit;

  const _FlavorTags({required this.flavors, required this.limit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppDesignTokens.space6,
      runSpacing: AppDesignTokens.space4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final flavor in flavors.take(limit))
          InfoPill(label: flavor.toUpperCase()),
        if (flavors.length > limit)
          Text(
            '+${flavors.length - limit}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
      ],
    );
  }
}
