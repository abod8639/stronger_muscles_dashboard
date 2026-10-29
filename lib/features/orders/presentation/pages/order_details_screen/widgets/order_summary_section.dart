import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/price_text.dart';
import 'package:stronger_muscles_dashboard/core/components/section_card.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/settings/settings_feature.dart';
import 'order_summary_row.dart';

/// بطاقة ملخص الحسابات المالية للطلب
class OrderSummarySection extends ConsumerWidget {
  final OrderEntity order;

  const OrderSummarySection({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final currency = ref.watch(storeCurrencyProvider);
    String price(double amount) => formatPrice(amount, currency);

    return SectionCard(
      title: 'ملخص الطلب',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          OrderSummaryRow(
            label: 'المجموع الفرعي',
            value: price(order.subtotal),
          ),
          OrderSummaryRow(
            label: 'تكلفة الشحن',
            value: price(order.shippingCost),
          ),
          if (order.taxAmount > 0)
            OrderSummaryRow(label: 'الضريبة', value: price(order.taxAmount)),
          if (order.discount > 0)
            OrderSummaryRow(
              label: 'الخصم',
              value: '-${price(order.discount)}',
              color: colorScheme.error,
            ),
          OrderSummaryRow(
            label: 'الإجمالي النهائي',
            value: price(order.totalAmount),
            isTotal: true,
          ),
        ],
      ),
    );
  }
}
