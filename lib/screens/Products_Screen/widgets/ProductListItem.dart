
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/models/product_model.dart';
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
  // late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );


    // _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      // CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    // );

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
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: FadeTransition(
        opacity: _controller,
        child: SlideTransition(
          position: _controller.drive(
            Tween<Offset>(
              begin: const Offset(0.2, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
          ),
          child: ProductCard(
            isHovered: _isHovered,
            product: widget.product,
            onEdit: widget.onEdit,
            onDelete: widget.onDelete,
          ),
        ),
      ),
    );
  }
}


