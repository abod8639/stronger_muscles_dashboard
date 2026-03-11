import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';

class OrderItemTile extends StatelessWidget {
  final OrderItemEntity item;
  final bool isDark;

  const OrderItemTile({super.key, required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[900],
            ),
            child: item.imageUrl != null
                ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                : const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '${item.quantity} x ${item.unitPrice.toStringAsFixed(2)} ر.س',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                if (item.selectedFlavor != null || item.selectedSize != null)
                  Text(
                    '${item.selectedFlavor ?? ""} - ${item.selectedSize ?? ""}',
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
              ],
            ),
          ),
          Text(
            '${item.subtotal.toStringAsFixed(2)} ر.س',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
