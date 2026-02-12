import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';
import 'package:stronger_muscles_dashboard/models/order_model.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';

Widget buildOrderItem(OrderItemModel item, bool isDark) {
  return GlassContainer(
    margin: const EdgeInsets.symmetric(vertical: 12 , horizontal: 16),
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [
        // Product Image
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: isDark ? Colors.black26 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: item.imageUrl != null
                ? CachedNetworkImage(
                    cacheManager: CustomCacheManager.instance,
                    imageUrl: item.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.2)),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.white24),
                  )
                : const Icon(Icons.inventory_2_outlined, color: Colors.white24),
          ),
        ),
        const SizedBox(width: 16),
        
        // Product Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              
              // Quantity & Unit Price
              Text(
                'الكمية: ${item.quantity} × ${item.unitPrice.toStringAsFixed(2)} ر.س',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Attributes (Flavor/Size)
              if ((item.selectedFlavor != null && item.selectedFlavor!.isNotEmpty) || 
                  (item.selectedSize != null && item.selectedSize!.isNotEmpty))
                Row(
                  children: [
                    if (item.selectedFlavor != null && item.selectedFlavor!.isNotEmpty)
                      _buildAttributeChip(item.selectedFlavor!, Colors.orangeAccent),
                    if (item.selectedSize != null && item.selectedSize!.isNotEmpty)
                      _buildAttributeChip(item.selectedSize!, Colors.blueAccent),
                  ],
                ),
            ],
          ),
        ),
        
        // Subtotal
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${item.subtotal.toStringAsFixed(2)}\nر.س',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildAttributeChip(String label, Color color) {
  return Container(
    margin: const EdgeInsets.only(right: 6),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
