import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/stock_status_badge.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';
import '../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final Function() onEdit;
  final Function() onDelete;
  final bool isHovered;
  final ProductEntity product;

  const ProductCard({
    super.key,
    required this.product,
    required this.isHovered,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding.left,
        vertical: responsive.itemSpacing / 2,
      ),
      child: GlassContainer(
        onTap: onEdit,
        opacity: isHovered ? 0.12 : 0.06,
        blur: isHovered ? 20 : 15,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHovered
              ? AppColors.primary.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.08),
          width: isHovered ? 1.5 : 1,
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(responsive.isMobile ? 12 : 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. الصورة بتصميم محسن
                  _buildProductImage(responsive),

                  SizedBox(width: responsive.isMobile ? 16 : 24),

                  // 2. تفاصيل المنتج
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBrandInfo(),
                        const SizedBox(height: 6),
                        _buildProductName(responsive),

                        if (product.flavors != null &&
                            product.flavors!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _buildFlavorTags(responsive),
                        ],

                        const SizedBox(height: 14),
                        _buildPriceAndStock(responsive),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: _buildDesktopActions(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(dynamic responsive) {
    final double imgSize = responsive.isMobile ? 85 : 110;
    return Container(
      width: imgSize,
      height: imgSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: product.imageUrls.isNotEmpty
            ? CachedNetworkImage(
                cacheManager: CustomCacheManager.instance,
                imageUrl: product.imageUrls.first,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.white.withValues(alpha: 0.05),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.broken_image_rounded,
                  color: Colors.white24,
                ),
              )
            : const Icon(
                Icons.inventory_2_rounded,
                color: Colors.white24,
                size: 35,
              ),
      ),
    );
  }

  Widget _buildProductName(dynamic responsive) {
    return Text(
      product.nameAr,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: responsive.isMobile ? 15 : 18,
        color: Colors.white,
        letterSpacing: 0.3,
      ),
      maxLines: 2, // يسمح بسطرين في حال كان الاسم طويلاً
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBrandInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        (product.brand ?? 'GENERIC').toUpperCase(),
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildFlavorTags(dynamic responsive) {
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
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Text(
                  f.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        if (product.flavors!.length > limit)
          Text(
            '+${product.flavors!.length - limit}',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceAndStock(dynamic responsive) {
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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: responsive.isMobile ? 18 : 22,
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                'SAR',
                style: TextStyle(
                  color: AppColors.primary.withValues(alpha: 0.8),
                  fontSize: 11,
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

  Widget _buildDesktopActions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _circleActionBtn(Icons.edit_rounded, AppColors.primary, onEdit),
        const SizedBox(height: 10),
        _circleActionBtn(
          Icons.delete_outline_rounded,
          Colors.redAccent.withValues(alpha: 0.8),
          onDelete,
        ),
      ],
    );
  }

  Widget _circleActionBtn(
    IconData icon,
    Color bgColor,
    VoidCallback onTap, {
    double size = 38,
    Color iconColor = Colors.white,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            // shape: BoxShape.circle,
            boxShadow: [
              if (bgColor != Colors.transparent &&
                  !bgColor.toString().contains('Opacity'))
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Icon(icon, color: iconColor, size: size * 0.5),
        ),
      ),
    );
  }
}
