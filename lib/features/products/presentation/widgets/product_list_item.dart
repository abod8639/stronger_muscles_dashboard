import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_card.dart';

class ProductListItem extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int index;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onToggleSelect;
  final VoidCallback? onLongPress;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
    this.index = 0,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onToggleSelect,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ProductCard(
      isHovered: false,
      product: product,
      onEdit: onEdit,
      onDelete: onDelete,
      isSelectionMode: isSelectionMode,
      isSelected: isSelected,
      onToggleSelect: onToggleSelect,
      onLongPress: onLongPress,
    );
  }
}
