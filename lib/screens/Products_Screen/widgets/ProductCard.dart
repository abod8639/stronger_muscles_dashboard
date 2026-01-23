import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/status_badge.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/models/product.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.all(padding.left),
      padding: EdgeInsets.all(responsive.isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHovered
              ? AppColors.primary.withValues(alpha: 0.4)
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          width: isHovered ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isHovered
                ? AppColors.primary.withValues(alpha: 0.2)
                : (isDark ? Colors.black26 : Colors.grey.shade200),
            blurRadius: isHovered ? 20 : 10,
            offset: Offset(0, isHovered ? 8 : 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image with Enhanced Design
          _buildProductImage(responsive, isDark),
          SizedBox(width: responsive.itemSpacing * 1.5),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductName(responsive, isDark),
                SizedBox(height: responsive.itemSpacing / 3),
                _buildBrandInfo(responsive, isDark),
                if (product.flavor != null && product.flavor!.isNotEmpty) ...[
                  SizedBox(height: responsive.itemSpacing / 2),
                  _buildFlavorTags(responsive),
                ],
                SizedBox(height: responsive.itemSpacing),
                _buildPriceAndStock(responsive, padding, isDark),
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
    );
  }

  Widget _buildProductImage(dynamic responsive, bool isDark) {
    return AnimatedScale(
      scale: isHovered ? 1.05 : 1,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: responsive.isMobile ? 80 : 100,
        height: responsive.isMobile ? 80 : 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.info.withValues(alpha: 0.15),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: isHovered ? 16 : 12,
              offset: Offset(0, isHovered ? 6 : 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              if (product.imageUrls.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: product.imageUrls.first,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (_, __) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Center(
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      color: isDark ? Colors.white38 : Colors.grey.shade400,
                      size: 32,
                    ),
                  ),
                )
              else
                Center(
                  child: Icon(
                    Icons.inventory_2_rounded,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
              if (isHovered)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.primary.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductName(dynamic responsive, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Text(
            product.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: responsive.getTitleFontSize(),
              color: isDark ? Colors.white : AppColors.textDark,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBrandInfo(dynamic responsive, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey.shade800
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.business_rounded,
            size: responsive.iconSize - 2,
            color: AppColors.primary.withValues(alpha: 0.8),
          ),
          SizedBox(width: responsive.itemSpacing / 2),
          Text(
            product.brand ?? 'بدون ماركة',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey.shade700,
              fontSize: responsive.getBodyFontSize() - 1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlavorTags(dynamic responsive) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ...product.flavor!.take(3).map((f) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.15),
                AppColors.info.withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                f,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )),
        if (product.flavor!.length > 3)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${product.flavor!.length - 3}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceAndStock(dynamic responsive, EdgeInsets padding, bool isDark) {
    return Row(
      children: [
        // Price Badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: padding.left / 1.5,
            vertical: padding.top / 3,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.15),
                AppColors.info.withValues(alpha: 0.25),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.attach_money_outlined,
                size: responsive.iconSize - 2,
                color: AppColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                product.price.toStringAsFixed(2),
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.getBodyFontSize() + 1,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),

        // Stock Status Badge
        AnimatedOpacity(
          opacity: isHovered ? 1 : 0.8,
          duration: const Duration(milliseconds: 300),
          child: AnimatedScale(
            scale: isHovered ? 1.05 : 1,
            duration: const Duration(milliseconds: 300),
            child: StockStatusBadge(
              quantity: product.stockQuantity,
            ),
          ),
        ),
      ],
    );
  }
}