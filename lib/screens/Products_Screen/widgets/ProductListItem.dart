
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/models/product.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductCard.dart';

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
                child: ProductCard(
                  isHovered: _isHovered, 
                  product: widget.product,
                  onEdit:widget.onEdit,
                  onDelete:widget.onDelete,
                  ),
              ),
            ),
          ),
        ),
      
    );
  }


}
