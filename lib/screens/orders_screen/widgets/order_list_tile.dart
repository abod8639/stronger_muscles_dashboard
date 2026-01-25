import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/components/status_badge.dart';
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
      return GlassContainer(
        opacity: 0.07,
        blur: 12,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(
              12,
            ), // تقليل البادينج قليلاً لتوفير مساحة
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // لمحاذاة الصور مع أعلى النص
              children: [
                _buildOrderImage(),
                const SizedBox(width: 12),
                Expanded(child: _buildOrderDetails()),
                const SizedBox(width: 8),
                _buildTrailingAction(),
              ],
            ),
          ),
        ),
      );
    }
  

  Widget _buildOrderImage() {
    final items = widget.order.items ?? [];
    final itemCount = items.length;
    final displayCount = itemCount > 3 ? 3 : itemCount;

    return SizedBox(
      width: 70, // تصغير العرض الإجمالي للكومة
      height: 50, // تصغير الارتفاع
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(displayCount, (index) {
          final itemIndex = (displayCount - 1) - index;
          return Positioned(
            left: index * 10.0,
            child: _buildSingleStackImage(
              items[itemIndex].imageUrl,
              isLast: index == displayCount - 1,
              additionalCount: itemCount > 3 && index == displayCount - 1
                  ? itemCount - 3
                  : 0,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSingleStackImage(
    String? imageUrl, {
    required bool isLast,
    int additionalCount = 0,
  }) {
    return Container(
      width: 50, // تصغير حجم الصورة الواحدة من 88 إلى 50
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.inventory_2, size: 18),
                  )
                : const Icon(Icons.inventory_2, size: 18),
            if (isLast && additionalCount > 0)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Text(
                    '+$additionalCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
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
            Expanded(
              // يسمح للنص بأخذ المساحة المتاحة فقط ولا يتجاوز الـ Badge
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
            Expanded(
              // نستخدم Expanded هنا مع TextAlign لضمان عدم حدوث overflow في التاريخ
              child: Text(
                _formatDate(widget.order.orderDate),
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
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
          text: 'Customer: ${widget.order.userId}',
        ),
        const SizedBox(height: 4),
        _buildInfoRow(
          icon: Icons.location_on_outlined,
          text: _extractAddress(widget.order.shippingAddressSnapshot),
        ),
        const SizedBox(height: 4),
        _buildInfoRow(
          icon: Icons.shopping_cart_outlined,
          text: widget.order.items!.length.toString(),
        ),
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
      child: const Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: Colors.white38,
      ),
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
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
            ),
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
