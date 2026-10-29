import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/divided_column.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/order_status_ui.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/order_details_controller.dart';
import 'package:stronger_muscles_dashboard/core/components/section_card.dart';
import 'package:stronger_muscles_dashboard/core/components/detail_row.dart';

/// بطاقة معلومات العميل والتواصل
class OrderCustomerSection extends StatelessWidget {
  final OrderEntity order;
  final OrderDetailsController controller;

  const OrderCustomerSection({
    super.key,
    required this.order,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final customerName = order.shippingAddress?.fullName?.isNotEmpty == true
        ? order.shippingAddress!.fullName!
        : (order.userName.isNotEmpty ? order.userName : 'غير محدد');

    final phone = order.shippingAddress?.phone?.isNotEmpty == true
        ? order.shippingAddress!.phone!
        : (order.phoneNumber?.isNotEmpty == true
              ? order.phoneNumber!
              : 'غير محدد');

    final hasPhone = phone != 'غير محدد' && phone.isNotEmpty;
    final hasEmail = order.userEmail.isNotEmpty;

    return SectionCard(
      title: 'معلومات العميل',
      icon: Icons.person_outline_rounded,
      child: DividedColumn(
        children: [
          DetailRow(
            icon: Icons.person_outline,
            label: 'اسم العميل',
            value: customerName,
          ),
          if (hasEmail)
            DetailRow(
              icon: Icons.alternate_email_rounded,
              label: 'البريد الإلكتروني',
              value: order.userEmail,
              trailing: IconButton(
                icon: const Icon(Icons.mail_outline_rounded, size: 18),
                tooltip: 'إرسال بريد',
                visualDensity: VisualDensity.compact,
                onPressed: () => controller.emailCustomer(order.userEmail),
              ),
            ),
          DetailRow(
            icon: Icons.phone_outlined,
            label: 'رقم الهاتف',
            value: phone,
            trailing: hasPhone
                ? IconButton(
                    icon: const Icon(Icons.phone_outlined, size: 18),
                    tooltip: 'اتصال بالعميل',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => controller.callCustomer(phone),
                  )
                : null,
          ),
          DetailRow(
            icon: Icons.credit_card_outlined,
            label: 'طريقة الدفع',
            value: order.paymentMethod.isNotEmpty
                ? order.paymentMethod
                : 'غير محدد',
          ),
          DetailRow(
            icon: Icons.verified_outlined,
            label: 'حالة الدفع',
            value: '',
            trailing: PaymentStatusBadge(status: order.paymentStatus),
          ),
        ],
      ),
    );
  }
}
