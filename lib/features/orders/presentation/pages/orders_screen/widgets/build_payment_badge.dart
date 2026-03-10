import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/models/order_model.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';

Widget buildPaymentBadge(OrderModel order) {
  final isPaid = order.paymentStatus == PaymentStatus.paid;
  final color = isPaid ? Colors.greenAccent : Colors.orangeAccent;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPaid ? Icons.check_circle_rounded : Icons.schedule_rounded,
          size: 10,
          color: color,
        ),
        const SizedBox(width: 3),
        Text(
          isPaid ? 'مدفوع' : 'معلق',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );
}
