import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'order_card_section.dart';
import 'order_summary_row.dart';

/// بطاقة ملخص الحسابات المالية للطلب
class OrderSummarySection extends StatelessWidget {
  final OrderEntity order;

  const OrderSummarySection({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OrderCardSection(
      title: 'ملخص الطلب',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          OrderSummaryRow(
            label: 'المجموع الفرعي',
            value: '${order.subtotal.toStringAsFixed(2)} ر.س',
          ),
          OrderSummaryRow(
            label: 'تكلفة الشحن',
            value: '${order.shippingCost.toStringAsFixed(2)} ر.س',
          ),
          if (order.discount > 0)
            OrderSummaryRow(
              label: 'الخصم',
              value: '-${order.discount.toStringAsFixed(2)} ر.س',
              color: colorScheme.error,
            ),
          const SizedBox(height: 4),
          OrderSummaryRow(
            label: 'الإجمالي النهائي',
            value: '${order.totalAmount.toStringAsFixed(2)} ر.س',
            isTotal: true,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
