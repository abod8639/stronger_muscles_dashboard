import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';

/// المصدر الوحيد لعرض حالات الطلب (التسمية، اللون، الأيقونة)
/// يُستخدم في الشارات، التصفية، حوار تغيير الحالة، الإشعارات، والفاتورة
extension OrderStatusUi on OrderStatus {
  String get label => switch (this) {
    OrderStatus.pending => 'قيد الانتظار',
    OrderStatus.processing => 'قيد المعالجة',
    OrderStatus.shipped => 'تم الشحن',
    OrderStatus.delivered => 'تم التوصيل',
    OrderStatus.cancelled => 'ملغي',
  };

  Color get color => switch (this) {
    OrderStatus.pending || OrderStatus.processing => AppColors.warning,
    OrderStatus.shipped => AppColors.info,
    OrderStatus.delivered => AppColors.success,
    OrderStatus.cancelled => AppColors.error,
  };

  IconData get icon => switch (this) {
    OrderStatus.pending => Icons.schedule_rounded,
    OrderStatus.processing => Icons.autorenew_rounded,
    OrderStatus.shipped => Icons.local_shipping_rounded,
    OrderStatus.delivered => Icons.check_circle_rounded,
    OrderStatus.cancelled => Icons.cancel_rounded,
  };
}

/// المصدر الوحيد لعرض حالات الدفع
extension PaymentStatusUi on PaymentStatus {
  String get label => switch (this) {
    PaymentStatus.pending => 'معلق',
    PaymentStatus.paid => 'مدفوع',
    PaymentStatus.failed => 'فشل الدفع',
    PaymentStatus.refunded => 'مسترد',
  };

  Color get color => switch (this) {
    PaymentStatus.pending => AppColors.warning,
    PaymentStatus.paid => AppColors.success,
    PaymentStatus.failed => AppColors.error,
    PaymentStatus.refunded => AppColors.info,
  };

  IconData get icon => switch (this) {
    PaymentStatus.pending => Icons.schedule_rounded,
    PaymentStatus.paid => Icons.check_circle_rounded,
    PaymentStatus.failed => Icons.error_rounded,
    PaymentStatus.refunded => Icons.undo_rounded,
  };
}

/// شارة حالة الطلب
class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) =>
      InfoPill(label: status.label, icon: status.icon, color: status.color);
}

/// شارة حالة الدفع
class PaymentStatusBadge extends StatelessWidget {
  final PaymentStatus status;

  const PaymentStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) =>
      InfoPill(label: status.label, icon: status.icon, color: status.color);
}
