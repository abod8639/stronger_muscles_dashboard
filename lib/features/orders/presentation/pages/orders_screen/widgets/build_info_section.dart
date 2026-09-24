import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/build_info_item.dart';

/// قسم معلومات العميل والمنتجات المتوافق مع Material Design 3
Widget buildInfoSection(OrderEntity order) {
  final itemCount = order.items.length;

  return Builder(
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.35,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.45),
                width: 1,
              ),
            ),
            child: buildInfoItem(
              icon: Icons.person_outline_rounded,
              label: order.userId.toString(),
              sublabel: 'العميل',
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.35,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.45),
                width: 1,
              ),
            ),

            child: buildInfoItem(
              icon: Icons.shopping_bag_outlined,
              label: '$itemCount',
              sublabel: itemCount == 1 ? 'منتج واحد' : 'منتجات',
            ),
          ),
        ],
      );
    },
  );
}
