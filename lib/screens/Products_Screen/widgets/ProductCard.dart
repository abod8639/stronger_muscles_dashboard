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
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding.left,
        vertical: responsive.itemSpacing / 2,
      ),
      child: GlassContainer(
        opacity: isHovered ? 0.1 : 0.05,
        blur: isHovered ? 20 : 10,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHovered
              ? AppColors.primary.withOpacity(0.4)
              : Colors.white.withOpacity(0.08),
          width: isHovered ? 1.5 : 1,
        ),
        child: Padding(
          padding: EdgeInsets.all(responsive.isMobile ? 12 : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. الصورة بحجم مرن
              _buildProductImage(responsive),
              
              SizedBox(width: responsive.isMobile ? 12 : 20),

              // 2. تفاصيل المنتج (Expanded لمنع الـ Overflow)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductName(responsive),
                    const SizedBox(height: 4),
                    _buildBrandInfo(),
                    
                    if (product.flavor != null && product.flavor!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _buildFlavorTags(responsive),
                    ],
                    
                    const SizedBox(height: 12),
                    _buildPriceAndStock(responsive),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // 3. أزرار التحكم (بعرض ثابت لمنع الضغط)
              SizedBox(
                width: responsive.isMobile ? 35 : 80,
                child: buildActionButtons(
                  onEdit: onEdit,
                  onDelete: onDelete,
                  isHovered: isHovered,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(dynamic responsive) {
    final double imgSize = responsive.isMobile ? 80 : 100;
    return Container(
      width: imgSize,
      height: imgSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: product.imageUrls.isNotEmpty
            ? CachedNetworkImage(
                cacheManager: CustomCacheManager.instance,
                imageUrl: product.imageUrls.first,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.white54),
                errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported),
              )
            : const Icon(Icons.inventory_2_rounded, color: Colors.white24, size: 30),
      ),
    );
  }

  Widget _buildProductName(dynamic responsive) {
    return Text(
      product.name,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: responsive.isMobile ? 14 : 18,
        color: Colors.white,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBrandInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        (product.brand ?? 'GENERIC').toUpperCase(),
        style: TextStyle(
          color: AppColors.accent,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
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
        ...product.flavor!.take(limit).map(
              (f) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  f.toUpperCase(),
                  style: const TextStyle(fontSize: 8, color: Colors.white70),
                ),
              ),
            ),
        if (product.flavor!.length > limit)
          Text(
            '+${product.flavor!.length - limit}',
            style: const TextStyle(fontSize: 9, color: Colors.white38),
          ),
      ],
    );
  }

  Widget _buildPriceAndStock(dynamic responsive) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // السعر مع FittedBox للحماية
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SAR',
                style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Text(
                product.price.toStringAsFixed(2),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: responsive.isMobile ? 16 : 20,
                ),
              ),
            ],
          ),
        ),
        
        // حالة المخزن
        StockStatusBadge(quantity: product.stockQuantity),
      ],
    );
  }
}