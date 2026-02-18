import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/models/product_model.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/product_card.dart';

class ProductListItem extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int index;

  const ProductListItem({
    super.key,
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
  final bool _isHovered = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProductCard(
      isHovered: _isHovered,
      product: widget.product,
      onEdit: widget.onEdit,
      onDelete: widget.onDelete,
    );
  }
}
