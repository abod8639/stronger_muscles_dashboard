import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/models/order_model.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_info_item.dart';

Widget buildInfoSection(OrderModel order) {
  final itemCount = order.items?.length ?? 0;

  return Builder(
    builder: (context) {
      final responsive = ResponsiveLayout(context);
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: responsive.isDesktop ? 8 : 4,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Expanded(
              child: buildInfoItem(
                icon: Icons.person_outline_rounded,
                label: order.userId.toString(),
                sublabel: 'عميل',
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: Colors.white.withOpacity(0.1),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildInfoItem(
                icon: Icons.shopping_bag_outlined,
                label: '$itemCount',
                sublabel: itemCount == 1 ? 'منتج' : 'منتجات',
              ),
            ),
          ],
        ),
      );
    },
  );
}
