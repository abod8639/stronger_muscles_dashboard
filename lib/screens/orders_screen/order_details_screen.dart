import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_address_section.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_detail_row.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_orderItem.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_section.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_summary_row.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/builds_section_title.dart';
import '../../models/order_model.dart';
import '../../config/theme.dart';
import '../../components/status_badge.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateFormat = intl.DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الطلب #${order.id}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Order Status & Date ---
            buildSection(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'وقت الطلب',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        dateFormat.format(order.orderDate),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  OrderStatusBadge(status: order.status),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- Customer Info ---
            buildSectionTitle('معلومات العميل'),
            buildSection(
              child: Column(
                children: [
                  buildDetailRow(
                    Icons.person,
                    'اسم العميل',
                    order.phoneNumber ?? 'غير متوفر (ID: ${order.userId})',
                  ),
                  // if(user?.email != null) ...[
                  //     const Divider(),
                  //     buildDetailRow(Icons.email, 'البريد الإلكتروني', order!.),
                  // ],
                  // if(order.phoneNumber != null && order.phoneNumber!.isNotEmpty) ...[
                  const Divider(),
                  buildDetailRow(
                    Icons.phone,
                    'رقم الهاتف',
                    order.phoneNumber ?? "000",
                  ),
                  // ],
                  const Divider(),
                  buildDetailRow(
                    Icons.payment,
                    'طريقة الدفع',
                    order.paymentMethod,
                  ),
                  const Divider(),
                  buildDetailRow(
                    Icons.check_circle,
                    'حالة الدفع',
                    '',
                    trailing: PaymentStatusBadge(status: order.paymentStatus),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- Shipping Address ---
            buildSectionTitle('عنوان الشحن'),
            buildSection(
              child: buildAddressSection(order.shippingAddressSnapshot),
            ),

            const SizedBox(height: 16),

            // --- Order Items ---
            buildSectionTitle('المنتجات'),
            buildSection(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  if (order.items != null && order.items!.isNotEmpty)
                    ...order.items!.map((item) => buildOrderItem(item, isDark))
                  else
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('لا توجد منتجات معروضة'),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- Order Summary ---
            buildSectionTitle('ملخص الطلب'),
            buildSection(
              child: Column(
                children: [
                  buildSummaryRow(
                    'المجموع الفرعي',
                    '${order.subtotal.toStringAsFixed(2)} ر.س',
                  ),
                  buildSummaryRow(
                    'تكلفة الشحن',
                    '${order.shippingCost.toStringAsFixed(2)} ر.س',
                  ),
                  if (order.discount > 0)
                    buildSummaryRow(
                      'الخصم',
                      '-${order.discount.toStringAsFixed(2)} ر.س',
                      color: Colors.green,
                    ),
                  const Divider(),
                  buildSummaryRow(
                    'الإجمالي',
                    '${order.totalAmount.toStringAsFixed(2)} ر.س',
                    isTotal: true,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- Notes ---
            if (order.notes != null && order.notes!.isNotEmpty) ...[
              buildSectionTitle('ملاحظات'),
              buildSection(child: Text(order.notes!)),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
