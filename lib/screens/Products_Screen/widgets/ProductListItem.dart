
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/status_badge.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/models/product.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/buildActionButtons.dart';

class ProductListItem extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int index;

  const ProductListItem({super.key, 
    required this.product,
    required this.onEdit,
    required this.onDelete,
    this.index = 0,
  });

  @override
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // _slideAnimation = Tween<double>(begin: 100, end: 0).animate(
    //   CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    // );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;

      return FadeTransition(
        opacity: _fadeAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(
              bottom: responsive.itemSpacing,
              left: padding.left,
              right: padding.right,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : Colors.transparent,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: _isHovered ? 12 : 2,
              color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark 
                    ? Colors.white.withValues(alpha: 0.05) 
                    : Colors.black.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: _isHovered
                        ? [
                            AppColors.primary.withValues(alpha: 0.05),
                            AppColors.secondary.withValues(alpha: 0.05),
                          ]
                        : [Colors.transparent, Colors.transparent],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(padding.left),
                  child: Row(
                    children: [
                      // صورة المنتج مع تأثير
                      AnimatedScale(
                        scale: _isHovered ? 1.08 : 1,
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
                                if (widget.product.imageUrls.isNotEmpty)
                                  Image.network(
                                    widget.product.imageUrls.first,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: isDark ? Colors.white38 : Colors.grey.shade400,
                                      ),
                                    ),
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          value: progress.expectedTotalBytes != null
                                              ? progress.cumulativeBytesLoaded /
                                                  progress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  )
                                else
                                  Center(
                                    child: Icon(
                                      Icons.inventory_2_outlined,
                                      color: AppColors.primary,
                                      size: 32,
                                    ),
                                  ),
                                if (_isHovered)
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
                              widget.product.name,
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
                                  widget.product.brand ?? 'بدون ماركة',
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
                                    '${widget.product.price.toStringAsFixed(2)} ر.س',
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
                                  opacity: _isHovered ? 1 : 0.7,
                                  duration: const Duration(milliseconds: 300),
                                  child: StockStatusBadge(
                                    quantity: widget.product.stockQuantity,
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
                        onEdit: widget.onEdit , 
                        onDelete: widget.onDelete, 
                        isHovered: _isHovered,
                       ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      
    );
  }


}
