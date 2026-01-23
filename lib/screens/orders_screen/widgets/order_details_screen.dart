import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import '../../../models/order_model.dart';
import '../../../config/theme.dart';
import '../../../components/status_badge.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;
  // final UserModel? user;

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
                  buildDetailRow(Icons.person, 'اسم العميل', order.phoneNumber ?? 'غير متوفر (ID: ${order.userId})'),
                  // if(user?.email != null) ...[
                  //     const Divider(),
                  //     buildDetailRow(Icons.email, 'البريد الإلكتروني', order!.),
                  // ],
                  // if(order.phoneNumber != null && order.phoneNumber!.isNotEmpty) ...[
                      const Divider(),
                      buildDetailRow(Icons.phone, 'رقم الهاتف', order.phoneNumber?? "000"),
                  // ],
                  const Divider(),
                  buildDetailRow(Icons.payment, 'طريقة الدفع', order.paymentMethod),
                  const Divider(),
                  buildDetailRow(Icons.check_circle, 'حالة الدفع', '', 
                    trailing: PaymentStatusBadge(status: order.paymentStatus)),
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
                  buildSummaryRow('المجموع الفرعي', '${order.subtotal.toStringAsFixed(2)} ر.س'),
                  buildSummaryRow('تكلفة الشحن', '${order.shippingCost.toStringAsFixed(2)} ر.س'),
                  if (order.discount > 0)
                    buildSummaryRow('الخصم', '-${order.discount.toStringAsFixed(2)} ر.س', color: Colors.green),
                  const Divider(),
                  buildSummaryRow('الإجمالي', '${order.totalAmount.toStringAsFixed(2)} ر.س', 
                    isTotal: true, color: AppColors.primary),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- Notes ---
            if (order.notes != null && order.notes!.isNotEmpty) ...[
              buildSectionTitle('ملاحظات'),
              buildSection(
                child: Text(order.notes!),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget buildSection({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Get.isDarkMode ? Colors.white10 : Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget buildDetailRow(IconData icon, String label, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          if (trailing != null) trailing else Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget buildAddressSection(Map<String, dynamic>? snapshot) {
    if (snapshot == null || snapshot.isEmpty) {
      return const Text('العنوان غير متوفر', style: TextStyle(color: Colors.grey));
    }

    // الحالة 1: العنوان نص مباشر
    if (snapshot.containsKey('address')) {
      final addr = snapshot['address'];
      if (addr is String) {
        return buildAddressInfoRow(Icons.location_on, 'العنوان الكامل', addr);
      }
      if (addr is Map) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAddressInfoRow(Icons.location_city, 'المدينة', addr['city'] ?? addr['City'] ?? 'غير محدد'),
            const SizedBox(height: 12),
            buildAddressInfoRow(Icons.location_on, 'الشارع/العنوان', addr['street'] ?? addr['Street'] ?? 'غير محدد'),
          ],
        );
      }
    }

    // الحالة 2: البحث في أول قيمة متوفرة
    final firstVal = snapshot.values.isNotEmpty ? snapshot.values.first : null;
    if (firstVal is String) {
      return buildAddressInfoRow(Icons.location_on, 'العنوان الكامل', firstVal);
    }
    if (firstVal is Map) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAddressInfoRow(Icons.location_city, 'المدينة', firstVal['city'] ?? firstVal['City'] ?? 'غير محدد'),
          const SizedBox(height: 12),
          buildAddressInfoRow(Icons.location_on, 'الشارع/العنوان', firstVal['street'] ?? firstVal['Street'] ?? 'غير محدد'),
        ],
      );
    }

    return const Text('العنوان غير محدد', style: TextStyle(color: Colors.grey));
  }

  Widget buildAddressInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildOrderItem(OrderItemModel item, bool isDark) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: item.imageUrl != null 
          ? Image.network(item.imageUrl!, errorBuilder: (c, e, s) => Icon(Icons.image))
          : Icon(Icons.image, color: Colors.grey),
      ),
      title: Text(item.productName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text('الكمية: ${item.quantity} × ${item.unitPrice.toStringAsFixed(2)} ر.س'),
      trailing: Text('${item.subtotal.toStringAsFixed(2)} ر.س', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget buildSummaryRow(String label, String value, {bool isTotal = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          )),
          Text(value, style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: color,
          )),
        ],
      ),
    );
  }
  
}
