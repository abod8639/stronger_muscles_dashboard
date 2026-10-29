import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/build_info_item.dart';

/// قسم معلومات العميل والمنتجات كبطاقتين منفصلتين تملآن المساحة بالتساوي وتستجيبان لحجم الشاشة دون حدوث overflow
Widget buildInfoSection(OrderEntity order, {bool isCompact = false}) {
  final itemCount = order.items.length;

  return Builder(
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;
      final responsive = ResponsiveLayout(context);
      final isMobile = responsive.isMobile || isCompact;

      return Row(
        children: [
          // البطاقة الأولى: معرف العميل
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 10,
                vertical: isMobile ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.35,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.45),
                  width: 1,
                ),
              ),
              child: buildInfoItem(
                icon: Icons.person_outline_rounded,
                label: order.userId.toString(),
                sublabel: 'العميل',
                isCompact: isMobile,
              ),
            ),
          ),

          SizedBox(width: isMobile ? 6 : 8),

          // البطاقة الثانية: عدد المنتجات
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 10,
                vertical: isMobile ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.35,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.45),
                  width: 1,
                ),
              ),
              child: buildInfoItem(
                icon: Icons.shopping_bag_outlined,
                label: '$itemCount',
                sublabel: itemCount == 1 ? 'منتج واحد' : 'منتجات',
                isCompact: isMobile,
              ),
            ),
          ),
        ],
      );
    },
  );
}
