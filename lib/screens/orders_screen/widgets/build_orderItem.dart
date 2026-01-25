  import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/models/order_model.dart';

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