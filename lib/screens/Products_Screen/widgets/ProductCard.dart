
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

    return Padding(
      padding: EdgeInsets.all(padding.left),
      child: Row(
        children: [
          // صورة المنتج مع تأثير
          AnimatedScale(
            scale: isHovered ? 1.08 : 1,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: responsive.isMobile ? 70 : 90,
              height: responsive.isMobile ? 70 : 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.secondary.withValues(alpha: 0.1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    if (product.imageUrls.isNotEmpty)
                      CachedNetworkImage (
                        imageUrl: product.imageUrls.first,
                        fit: BoxFit.cover,
                       errorWidget:  (_, __, ___) => Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: isDark ? Colors.white38 : Colors.grey.shade400,
                          ),
                        ),
                        // loadingBuilder: (context, child, progress) {
                        //   if (progress == null) return child;
                        //   return Center(
                        //     child: CircularProgressIndicator(
                        //       strokeWidth: 2,
                        //       value: progress.expectedTotalBytes != null
                        //           ? progress.cumulativeBytesLoaded /
                        //               progress.expectedTotalBytes!
                        //           : null,
                        //     ),
                        //   );
                        // },
                      )
                    else
                      Center(
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                    if (isHovered)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: responsive.itemSpacing * 1.5),
    
          // معلومات المنتج
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الاسم
                Text(
                  product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.getTitleFontSize(),
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.itemSpacing / 4),
    
                // الماركة
                Row(
                  children: [
                    Icon(
                      Icons.business,
                      size: responsive.iconSize - 4,
                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                    SizedBox(width: responsive.itemSpacing / 2),
                    Text(
                      product.brand ?? 'بدون ماركة',
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                        fontSize: responsive.getBodyFontSize() - 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.itemSpacing),
    
                // السعر والمخزون
                Row(
                  children: [
                    // السعر
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: padding.left / 2,
                        vertical: padding.top / 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.15),
                            AppColors.secondary.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${product.price.toStringAsFixed(2)} ر.س',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.getBodyFontSize(),
                        ),
                      ),
                    ),
                    const Spacer(),
    
                    // حالة المخزون
                    AnimatedOpacity(
                      opacity: isHovered ? 1 : 0.7,
                      duration: const Duration(milliseconds: 300),
                      child: StockStatusBadge(
                        quantity: product.stockQuantity,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: responsive.itemSpacing),
    
          // أزرار التحكم
          buildActionButtons(
            onEdit: () => onEdit()  ,
            onDelete: () => onDelete() , 
            isHovered: isHovered,
           ),
        ],
      ),
    );
  }
}
