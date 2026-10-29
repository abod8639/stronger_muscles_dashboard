import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/divided_column.dart';
import 'package:stronger_muscles_dashboard/core/components/section_card.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'order_item_tile.dart';

/// بطاقة عرض قائمة المنتجات في الطلب
class OrderProductsSection extends StatelessWidget {
  final List<OrderItemEntity> items;

  const OrderProductsSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'المنتجات (${items.length})',
      icon: Icons.shopping_bag_outlined,
      padding: EdgeInsets.zero,
      child: items.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(AppDesignTokens.space24),
              child: Center(child: Text('لا توجد منتجات في هذا الطلب')),
            )
          : DividedColumn(
              children: [for (final item in items) OrderItemTile(item: item)],
            ),
    );
  }
}
