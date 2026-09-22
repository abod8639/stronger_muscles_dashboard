import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

Widget buildOrderItem(OrderItemEntity item, bool isDark) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        cacheManager: CustomCacheManager.instance,
                        imageUrl: item.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.primary.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.inventory_2_outlined,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                          size: 24,
                        ),
                      )
                    : Icon(
                        Icons.inventory_2_outlined,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                        size: 24,
                      ),
              ),
            ),
            const SizedBox(width: 14),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Quantity & Unit Price
                  Text(
                    '${item.quantity} × ${item.unitPrice.toStringAsFixed(2)} ر.س',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  // Flavor & Size attributes
                  if ((item.selectedFlavor != null &&
                          item.selectedFlavor!.isNotEmpty) ||
                      (item.selectedSize != null &&
                          item.selectedSize!.isNotEmpty)) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (item.selectedFlavor != null &&
                            item.selectedFlavor!.isNotEmpty)
                          _buildM3Tag(
                            context,
                            icon: Icons.local_cafe_outlined,
                            label: item.selectedFlavor!,
                          ),
                        if (item.selectedSize != null &&
                            item.selectedSize!.isNotEmpty)
                          _buildM3Tag(
                            context,
                            icon: Icons.straighten_outlined,
                            label: item.selectedSize!,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Subtotal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                '${item.subtotal.toStringAsFixed(2)} ر.س',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildM3Tag(
  BuildContext context, {
  required IconData icon,
  required String label,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 11,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
