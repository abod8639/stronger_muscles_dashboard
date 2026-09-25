import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

/// عنصر منتج الطلب بتصميم Neumorphism / Soft UI
/// متناسق مع ألوان وثيم التطبيق للوضعين الداكن والفاتح بحواف ناعمة وظلال ثنائية هادئة.
class OrderItemTile extends StatelessWidget {
  final OrderItemEntity item;

  const OrderItemTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. حاوية صورة المنتج النيومورفية (Neumorphic Product Image Frame)
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.05)!,
                        Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.12)!,
                      ]
                    : [
                        Colors.white,
                        Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.03)!,
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.45)
                      : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
                  offset: const Offset(2, 3),
                  blurRadius: 5,
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.white.withValues(alpha: 0.95),
                  offset: const Offset(-2, -2),
                  blurRadius: 4,
                ),
              ],
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.85),
                width: 1.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      cacheManager: CustomCacheManager.instance,
                      imageUrl: item.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.primary.withValues(alpha: 0.5),
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

          // 2. تفاصيل المنتج (Product Details)
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

                // الكمية وسعر الوحدة
                Text(
                  '${item.quantity} × ${item.unitPrice.toStringAsFixed(2)} ر.س',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // خصائص المنتج (النكهة والحجم)
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
                        _OrderItemAttributeChip(
                          icon: Icons.local_cafe_outlined,
                          label: item.selectedFlavor!,
                          isDark: isDark,
                        ),
                      if (item.selectedSize != null &&
                          item.selectedSize!.isNotEmpty)
                        _OrderItemAttributeChip(
                          icon: Icons.straighten_outlined,
                          label: item.selectedSize!,
                          isDark: isDark,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),

          // 3. شارة الإجمالي الفرعي المجسمة (Neumorphic Subtotal Badge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.01)!,
                        Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.12)!,
                      ]
                    : [
                        Colors.white,
                        Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.03)!,
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.40)
                      : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
                  offset: const Offset(1.5, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.01)
                      : Colors.white.withValues(alpha: 0.95),
                  offset: const Offset(-1.5, -1.5),
                  blurRadius: 3,
                ),
              ],
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.01)
                    : Colors.white.withValues(alpha: 0.85),
                width: 1.0,
              ),
            ),
            child: Text(
              '${item.subtotal.toStringAsFixed(2)} ر.س',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemAttributeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _OrderItemAttributeChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: isDark
            ? Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.15)!
            : Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.60)!,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.01)
              : Colors.white.withValues(alpha: 0.70),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.20),
            offset: const Offset(1, 1.5),
            blurRadius: 2.5,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.01)
                : Colors.white.withValues(alpha: 0.85),
            offset: const Offset(-1, -1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
