import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/components/stock_status_badge.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';
import 'package:stronger_muscles_dashboard/models/product_model.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/buildActionButtons.dart';

class ProductCard extends StatelessWidget {
  final Function() onEdit;
  final Function() onDelete;
  final bool isHovered;
  final ProductModel product;

  const ProductCard({
    super.key,
    required this.product,
    required this.isHovered,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding.left,
        vertical: responsive.itemSpacing / 2,
      ),
      child: GlassContainer(
        opacity: isHovered ? 0.08 : 0.04,
        blur: isHovered ? 25 : 15,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHovered
              ? AppColors.primary.withOpacity(0.4)
              : Colors.white.withOpacity(0.08),
          width: isHovered ? 1.5 : 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isHovered
                ? AppColors.primary.withOpacity(0.12)
                : Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.01),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(responsive.isMobile ? 12 : 16),
          child: Row(
            children: [
              // Product Image with Enhanced Design
              _buildProductImage(responsive),
              SizedBox(width: responsive.itemSpacing * 1.5),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductName(responsive),
                    SizedBox(height: 6),
                    _buildBrandInfo(responsive),
                    if (product.flavor != null &&
                        product.flavor!.isNotEmpty) ...[
                      SizedBox(height: 12),
                      _buildFlavorTags(responsive),
                    ],
                    SizedBox(height: 16),
                    _buildPriceAndStock(responsive, padding),
                  ],
                ),
              ),
              SizedBox(width: responsive.itemSpacing),

              // Action Buttons
              buildActionButtons(
                onEdit: onEdit,
                onDelete: onDelete,
                isHovered: isHovered,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(dynamic responsive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: responsive.isMobile ? 85 : 110,
      height: responsive.isMobile ? 85 : 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHovered
              ? AppColors.primary.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          if (isHovered)
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            if (product.imageUrls.isNotEmpty)
              CachedNetworkImage(
                cacheManager: CustomCacheManager.instance,
                imageUrl: product.imageUrls.first,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (_, __) => Container(
                  color: Colors.white.withOpacity(0.05),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.white.withOpacity(0.05),
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      color: Colors.white24,
                      size: 32,
                    ),
                  ),
                ),
              )
            else
              Container(
                color: Colors.white.withOpacity(0.05),
                child: Center(
                  child: Icon(
                    Icons.inventory_2_rounded,
                    color: AppColors.primary.withOpacity(0.5),
                    size: 40,
                  ),
                ),
              ),
            if (isHovered)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.primary.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductName(dynamic responsive) {
    return Text(
      product.name,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: responsive.getTitleFontSize() + 1,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBrandInfo(dynamic responsive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, size: 14, color: AppColors.accent),
          SizedBox(width: 6),
          Text(
            (product.brand ?? 'GENERIC').toUpperCase(),
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlavorTags(dynamic responsive) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...product.flavor!
            .take(3)
            .map(
              (f) => GlassContainer(
                // width: 50,
                opacity: 0.1,
                blur: 5,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 2,
                  ),
                  child: Text(
                    f.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.primaryglow,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
        if (product.flavor!.length > 3)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${product.flavor!.length - 2}',
              style: TextStyle(
                fontSize: 9,
                color: AppColors.textMuted,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceAndStock(dynamic responsive, EdgeInsets padding) {
    return Row(
      children: [
        // Price Badge
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SAR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                product.price.toStringAsFixed(2),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: responsive.getBodyFontSize() + 4,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),

        // Stock Status Badge
        StockStatusBadge(quantity: product.stockQuantity),
      ],
    );
  }
}
