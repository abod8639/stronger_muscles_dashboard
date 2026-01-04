import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/order.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  Color _getStatusColor() {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.pending;
      case OrderStatus.processing:
        return AppColors.processing;
      case OrderStatus.shipped:
        return AppColors.shipped;
      case OrderStatus.delivered:
        return AppColors.delivered;
      case OrderStatus.cancelled:
        return AppColors.cancelled;
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case OrderStatus.pending:
        return 'قيد الانتظار';
      case OrderStatus.processing:
        return 'قيد المعالجة';
      case OrderStatus.shipped:
        return 'تم الشحن';
      case OrderStatus.delivered:
        return 'تم التوصيل';
      case OrderStatus.cancelled:
        return 'ملغى';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        _getStatusLabel(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class PaymentStatusBadge extends StatelessWidget {
  final PaymentStatus status;

  const PaymentStatusBadge({super.key, required this.status});

  Color _getPaymentStatusColor() {
    switch (status) {
      case PaymentStatus.pending:
        return AppColors.warning;
      case PaymentStatus.paid:
        return AppColors.success;
      case PaymentStatus.failed:
        return AppColors.danger;
      case PaymentStatus.refunded:
        return AppColors.info;
    }
  }

  String _getPaymentStatusLabel() {
    switch (status) {
      case PaymentStatus.pending:
        return 'قيد الانتظار';
      case PaymentStatus.paid:
        return 'مدفوع';
      case PaymentStatus.failed:
        return 'فشل';
      case PaymentStatus.refunded:
        return 'مسترد';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPaymentStatusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        _getPaymentStatusLabel(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class StockStatusBadge extends StatelessWidget {
  final int quantity;

  const StockStatusBadge({super.key, required this.quantity});

  Color _getStockColor() {
    if (quantity <= 0) {
      return AppColors.outOfStock;
    } else if (quantity <= 10) {
      return AppColors.lowStock;
    } else {
      return AppColors.inStock;
    }
  }

  String _getStockLabel() {
    if (quantity <= 0) {
      return 'انتهى المخزون';
    } else if (quantity <= 10) {
      return 'مخزون منخفض';
    } else {
      return 'متوفر';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStockColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        _getStockLabel(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
