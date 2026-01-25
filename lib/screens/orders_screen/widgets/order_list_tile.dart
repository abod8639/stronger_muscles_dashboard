import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/components/status_badge.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';
import '../../../config/theme.dart';
import '../../../models/index.dart';

class OrderListTile extends StatefulWidget {
  final OrderModel order;
  final VoidCallback? onTap;
  final int index;

  const OrderListTile({
    super.key,
    required this.order,
    this.onTap,
    required this.index,
  });

  @override
  State<OrderListTile> createState() => OrderListTileState();
}

class OrderListTileState extends State<OrderListTile>
    with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassContainer(
        opacity: 0.07,
        blur: 12,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildOrderImage(),
                const SizedBox(width: 16),
                Expanded(child: _buildOrderDetails()),
                _buildTrailingAction(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widgets فرعية لتحسين قراءة الكود ---
  Widget _buildOrderImage() {
  final items = widget.order.items ?? [];
  final itemCount = items.length;
  // سنعرض كحد أقصى 3 صور متراكمة للحفاظ على نظافة التصميم
  final displayCount = itemCount > 3 ? 3 : itemCount;

  return SizedBox(
    width: 100, // زيادة العرض قليلاً لاستيعاب الإزاحة
    height: 60,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        // توليد الصور المتراكمة
        ...List.generate(displayCount, (index) {
          //index 0 هي الصورة الأبعد، وآخر index هي الصورة الأمامية
          final itemIndex = (displayCount - 1) - index;
          final imageUrl = items[itemIndex].imageUrl;
          
          return Positioned(
            left: index * 8.0, // إزاحة كل صورة عن التي خلفها
            top: index * 2.0,  // إزاحة بسيطة للأسفل لتعزيز البعد الثالث
            child: _buildSingleStackImage(
              imageUrl, 
              isLast: index == displayCount - 1,
              additionalCount: itemCount > 3 && index == displayCount - 1 ? itemCount - 3 : 0,
            ),
          );
        }),
      ],
    ),
  );
}

  Widget _buildSingleStackImage(String? imageUrl, {required bool isLast, int additionalCount = 0}) {
  return Container(
    width: 88,
    height: 88,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 4,
          offset: const Offset(2, 2),
        ),
      ],
      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageUrl != null
              ? CachedNetworkImage(
                  cacheManager: CustomCacheManager.instance,
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: Colors.white10),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.inventory_2_outlined, size: 20, color: Colors.grey),
                  ),
                )
              : Container(
                  color: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.inventory_2_outlined, size: 20, color: Colors.grey),
                ),
          
          // إضافة طبقة تعتيم وعدد المنتجات الإضافية على آخر صورة فقط
          if (isLast && additionalCount > 0)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Text(
                  '+$additionalCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

  Widget _buildOrderDetails() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // الصف الأول: رقم الطلب والحالة
      Row(
        children: [
          Expanded( // يسمح للنص بأخذ المساحة المتاحة فقط ولا يتجاوز الـ Badge
            child: Text(
              'ORDER #${widget.order.id.toString().padLeft(4, '0')}',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
              overflow: TextOverflow.ellipsis, // يضع نقاط (...) إذا طال النص
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8), // مسافة أمان
          OrderStatusBadge(status: widget.order.status),
        ],
      ),
      const SizedBox(height: 6),
      
      // الصف الثاني: السعر والتاريخ
      Row(
        children: [
          Text(
            '${widget.order.totalAmount.toStringAsFixed(2)} SAR',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 8),
          Expanded( // نستخدم Expanded هنا مع TextAlign لضمان عدم حدوث overflow في التاريخ
            child: Text(
              _formatDate(widget.order.orderDate),
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5), 
                fontSize: 10
              ),
            ),
          ),
        ],
      ),
      
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Divider(color: Colors.white10, height: 1),
      ),
      
      // معلومات العميل والعنوان
      _buildInfoRow(
        icon: Icons.person_outline,
        text: 'Customer: ${widget.order.userId}'),
      const SizedBox(height: 4),
      _buildInfoRow(
        icon: Icons.location_on_outlined,
        text: _extractAddress(widget.order.shippingAddressSnapshot )),
      const SizedBox(height: 4),
      _buildInfoRow(
        icon: Icons.shopping_cart_outlined,
        text: widget.order.items!.length.toString() ),
    ],
  );
}

  Widget _buildTrailingAction() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.white38),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primary.withOpacity(0.7)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // --- Logic Helpers ---

  String _extractAddress(Map<String, dynamic>? snapshot) {
    if (snapshot == null || snapshot.isEmpty) return 'العنوان غير متوفر';
    final addr = snapshot['address'] ?? snapshot;
    if (addr is String) return addr;
    final city = addr['city'] ?? addr['City'] ?? '';
    final street = addr['street'] ?? addr['Street'] ?? '';
    return [city, street].where((s) => s.toString().isNotEmpty).join(', ');
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'اليوم';
    if (diff.inDays == 1) return 'أمس';
    return '${date.day}/${date.month}/${date.year}';
  }
}
