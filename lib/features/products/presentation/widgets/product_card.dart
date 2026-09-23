import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/stock_status_badge.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

class ProductCard extends StatelessWidget {
  final Function() onEdit;
  final Function() onDelete;
  final bool isHovered;
  final ProductEntity product;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onToggleSelect;
  final VoidCallback? onLongPress;

  const ProductCard({
    super.key,
    required this.product,
    required this.isHovered,
    required this.onEdit,
    required this.onDelete,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onToggleSelect,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;

    final cardBgColor = isSelected
        ? colorScheme.primaryContainer.withValues(alpha: 0.35)
        : (isHovered
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainerLow);

    final borderColor = isSelected
        ? colorScheme.primary
        : (isHovered
            ? colorScheme.outline
            : colorScheme.outlineVariant.withValues(alpha: 0.6));

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding.left,
        vertical: responsive.itemSpacing / 2,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        color: cardBgColor,
        elevation: isSelected ? 1 : 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: borderColor,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: InkWell(
          onTap: isSelectionMode ? onToggleSelect : onEdit,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(responsive.isMobile ? 12 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // خانة الاختيار عند تفعيل وضع التحديد
                if (isSelectionMode) ...[
                  _buildSelectionCheckbox(colorScheme),
                  SizedBox(width: responsive.isMobile ? 10 : 16),
                ],

                // 1. صورة المنتج
                _buildProductImage(responsive, colorScheme),

                SizedBox(width: responsive.isMobile ? 16 : 20),

                // 2. تفاصيل المنتج
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildBrandInfo(theme),
                          const SizedBox(width: 8),
                          _buildStatusBadge(colorScheme),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _buildProductName(responsive, theme),

                      if (product.flavors != null &&
                          product.flavors!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _buildFlavorTags(responsive, theme),
                      ],

                      const SizedBox(height: 12),
                      _buildPriceAndStock(responsive, theme),
                    ],
                  ),
                ),

                if (!isSelectionMode)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: _buildDesktopActions(colorScheme),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCheckbox(ColorScheme colorScheme) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Checkbox(
        value: isSelected,
        onChanged: (_) => onToggleSelect?.call(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ColorScheme colorScheme) {
    final isActive = product.isActive;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primaryContainer
            : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'نشط' : 'معطل',
        style: TextStyle(
          color: isActive
              ? colorScheme.onPrimaryContainer
              : colorScheme.onErrorContainer,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductImage(dynamic responsive, ColorScheme colorScheme) {
    final double imgSize = responsive.isMobile ? 85 : 105;
    return Container(
      width: imgSize,
      height: imgSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.surfaceContainerHighest,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  size: 28,
                ),
              )
            : Icon(
                Icons.inventory_2_rounded,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                size: 32,
              ),
      ),
    );
  }

  Widget _buildProductName(dynamic responsive, ThemeData theme) {
    return Text(
      product.nameAr,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
        fontSize: responsive.isMobile ? 15 : 17,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBrandInfo(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        (product.brand ?? 'GENERIC').toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          fontSize: 9,
        ),
      ),
    );
  }

  Widget _buildFlavorTags(dynamic responsive, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final int limit = responsive.isMobile ? 1 : 3;
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...product.flavors!
            .take(limit)
            .map(
              (f) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  f.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        if (product.flavors!.length > limit)
          Text(
            '+${product.flavors!.length - limit}',
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceAndStock(dynamic responsive, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Wrap(
      spacing: 16,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              product.price.toStringAsFixed(2),
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                fontSize: responsive.isMobile ? 18 : 22,
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                'SAR',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        StockStatusBadge(quantity: product.stockQuantity),
      ],
    );
  }

  Widget _buildDesktopActions(ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filledTonal(
          icon: const Icon(Icons.edit_outlined, size: 18),
          tooltip: 'تعديل',
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
          ),
          onPressed: onEdit,
        ),
        const SizedBox(height: 8),
        IconButton.filledTonal(
          icon: const Icon(Icons.delete_outline, size: 18),
          tooltip: 'حذف',
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.errorContainer,
            foregroundColor: colorScheme.onErrorContainer,
          ),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
