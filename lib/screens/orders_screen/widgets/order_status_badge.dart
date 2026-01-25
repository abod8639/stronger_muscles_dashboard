
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/models/order_model.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  const OrderStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color = _getStatusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        _getStatusLabel(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case OrderStatus.pending: return const Color(0xFFF59E0B);
      case OrderStatus.processing: return const Color(0xFF6366F1);
      case OrderStatus.shipped: return const Color(0xFF8B5CF6);
      case OrderStatus.delivered: return const Color(0xFF10B981);
      case OrderStatus.cancelled: return const Color(0xFFEF4444);
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case OrderStatus.pending: return 'معلقة';
      case OrderStatus.processing: return 'معالجة';
      case OrderStatus.shipped: return 'مرسلة';
      case OrderStatus.delivered: return 'مُسلّمة';
      case OrderStatus.cancelled: return 'ملغاة';
    }
  }
}