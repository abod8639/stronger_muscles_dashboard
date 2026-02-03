
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/models/order_model.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_payment_badge.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/order_list_tile.dart';

  class OrderHeader extends StatelessWidget {
    final OrderModel order;
    const OrderHeader({super.key, required this.order});
  
    @override
    Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    String orderId = getFormattedOrderId(isMobile);

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.2),
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    orderId,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: AppColors.primary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                buildPaymentBadge(order),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 11,
                  color: Colors.white.withOpacity(0.4),
                ),
                const SizedBox(width: 4),
                Text(
                  formatDate(order.orderDate),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        );
    }
    String getFormattedOrderId(bool isMobile) {
  final id = order.id.toString();

  if (isMobile && id.length > 10) {
    return '#${id.substring(id.length - 6)}';
  }
  return '#$id';
}
  }
