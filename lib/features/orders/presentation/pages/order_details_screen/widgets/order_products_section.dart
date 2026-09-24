import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'order_card_section.dart';
import 'order_item_tile.dart';

/// بطاقة عرض قائمة المنتجات في الطلب
class OrderProductsSection extends StatelessWidget {
  final List<OrderItemEntity> items;

  const OrderProductsSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OrderCardSection(
      title: 'المنتجات (${items.length})',
      icon: Icons.shopping_bag_outlined,
      padding: EdgeInsets.zero,
      child: items.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text('لا توجد منتجات في هذا الطلب'),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
              itemBuilder: (context, index) => OrderItemTile(
                item: items[index],
              ),
            ),
    );
  }
}
