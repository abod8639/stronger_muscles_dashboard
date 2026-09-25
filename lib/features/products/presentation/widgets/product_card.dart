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
    final isDark = theme.brightness == Brightness.dark;
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;
    final borderRadius = BorderRadius.circular(20);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding.left,
        vertical: responsive.itemSpacing / 2,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? (isDark
                    ? [
                        Color.lerp(colorScheme.primaryContainer, Colors.white, 0.03)!,
                        Color.lerp(colorScheme.surfaceContainer, colorScheme.primary, 0.12)!,
                      ]
                    : [
                        Color.lerp(colorScheme.primaryContainer, Colors.white, 0.60)!,
                        Color.lerp(colorScheme.primaryContainer, Colors.black, 0.03)!,
                      ])
                : (isDark
                    ? [
                        Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.02)!,
                        Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.09)!,
                      ]
                    : [
                        Colors.white,
                        Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.035)!,
                      ]),
          ),
          boxShadow: [
            // الظل السفلي الغامق للعمق (Drop Shadow)
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.45)
                  : const Color(0xFFA3B1C6).withValues(alpha: 0.40),
              offset: const Offset(3, 4),
              blurRadius: 10,
            ),
            // الظل العلوي الفاتح العاكس للضوء (Highlight Glow)
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.02)
                  : Colors.white.withValues(alpha: 0.95),
              offset: const Offset(-2.5, -2.5),
              blurRadius: 8,
            ),
            if (isSelected)
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: isDark ? 0.20 : 0.22),
                offset: const Offset(0, 2),
                blurRadius: 12,
              ),
          ],
          border: Border.all(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: isDark ? 0.70 : 0.85)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.white.withValues(alpha: 0.85)),
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: isSelectionMode ? onToggleSelect : onEdit,
            onLongPress: onLongPress,
            borderRadius: borderRadius,
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
                  _buildProductImage(responsive, isDark, colorScheme),

                  SizedBox(width: responsive.isMobile ? 16 : 20),

                  // 2. تفاصيل المنتج
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildBrandInfo(theme, isDark),
                            const SizedBox(width: 8),
                            _buildStatusBadge(colorScheme, isDark),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _buildProductName(responsive, theme),

                        if (product.flavors != null &&
                            product.flavors!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _buildFlavorTags(responsive, theme, isDark),
                        ],

                        const SizedBox(height: 12),
                        _buildPriceAndStock(responsive, theme),
                      ],
                    ),
                  ),

                  if (!isSelectionMode)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _buildDesktopActions(isDark, colorScheme),
                    ),
                ],
              ),
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

  Widget _buildStatusBadge(ColorScheme colorScheme, bool isDark) {
    final isActive = product.isActive;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.10)!,
                ]
              : [
                  Colors.white,
                  Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.02)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.30)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
            offset: const Offset(1, 1.5),
            blurRadius: 2.5,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.85),
            offset: const Offset(-1, -1),
            blurRadius: 2,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.white.withValues(alpha: 0.80),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? colorScheme.primary : colorScheme.error,
              boxShadow: [
                BoxShadow(
                  color: (isActive ? colorScheme.primary : colorScheme.error)
                      .withValues(alpha: 0.5),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isActive ? 'نشط' : 'معطل',
            style: TextStyle(
              color: isActive ? colorScheme.primary : colorScheme.error,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(
      dynamic responsive, bool isDark, ColorScheme colorScheme) {
    final double imgSize = responsive.isMobile ? 85 : 105;
    return Container(
      width: imgSize,
      height: imgSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
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
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
            offset: const Offset(2, 2.5),
            blurRadius: 4,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.90),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 3,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.white.withValues(alpha: 0.85),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
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

  Widget _buildBrandInfo(ThemeData theme, bool isDark) {
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.10)!,
                ]
              : [
                  Colors.white,
                  Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.02)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.30)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
            offset: const Offset(1, 1.5),
            blurRadius: 2.5,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.85),
            offset: const Offset(-1, -1),
            blurRadius: 2,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.white.withValues(alpha: 0.75),
          width: 0.8,
        ),
      ),
      child: Text(
        (product.brand ?? 'GENERIC').toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          fontSize: 9,
        ),
      ),
    );
  }

  Widget _buildFlavorTags(dynamic responsive, ThemeData theme, bool isDark) {
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
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
                            Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.08)!,
                          ]
                        : [
                            Colors.white,
                            Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.02)!,
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.25)
                          : const Color(0xFFA3B1C6).withValues(alpha: 0.20),
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                    BoxShadow(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.02)
                          : Colors.white.withValues(alpha: 0.80),
                      offset: const Offset(-1, -1),
                      blurRadius: 1.5,
                    ),
                  ],
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.03)
                        : Colors.white.withValues(alpha: 0.75),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  f.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
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

  Widget _buildDesktopActions(bool isDark, ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNeumorphicActionButton(
          tooltip: 'تعديل',
          icon: Icons.edit_outlined,
          iconColor: colorScheme.primary,
          onTap: onEdit,
          isDark: isDark,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 10),
        _buildNeumorphicActionButton(
          tooltip: 'حذف',
          icon: Icons.delete_outline,
          iconColor: colorScheme.error,
          onTap: onDelete,
          isDark: isDark,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildNeumorphicActionButton({
    required String tooltip,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    required bool isDark,
    required ColorScheme colorScheme,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
                    Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.10)!,
                  ]
                : [
                    Colors.white,
                    Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.03)!,
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.35)
                  : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
              offset: const Offset(1.5, 2),
              blurRadius: 3,
            ),
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.02)
                  : Colors.white.withValues(alpha: 0.90),
              offset: const Offset(-1.5, -1.5),
              blurRadius: 2.5,
            ),
          ],
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : Colors.white.withValues(alpha: 0.85),
            width: 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Center(
              child: Icon(icon, size: 18, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
