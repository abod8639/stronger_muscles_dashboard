import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';
import '../config/theme.dart';
import '../models/index.dart';

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
  // استخدام الـ Getter الآمن الذي أضفناه للموديل
  final imageUrl = widget.order.firstItemImageUrl;
  final itemCount = widget.order.items?.length ?? 0;

  return Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: imageUrl != null
              ? CachedNetworkImage(
                  cacheManager: CustomCacheManager.instance,
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (_, __, ___) => const Icon(Icons.inventory_2_outlined, color: Colors.grey),
                )
              : const Icon(Icons.inventory_2_outlined, color: Colors.grey),
        ),
      ),
      // إضافة شارة (Badge) إذا كان هناك أكثر من منتج
      if (itemCount > 1)
        Positioned(
          bottom: -5,
          right: -5,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              '+${itemCount - 1}',
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ),
        ),
    ],
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
      _buildInfoRow(Icons.person_outline, 'Customer: ${widget.order.userId}'),
      const SizedBox(height: 4),
      _buildInfoRow(Icons.location_on_outlined, _extractAddress(widget.order.shippingAddressSnapshot )),
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

  Widget _buildInfoRow(IconData icon, String text) {
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

// كلاس البادج المطور مع ألوان متوافقة مع DashboardController
class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  const OrderStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color = _getStatusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        _getStatusLabel(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case OrderStatus.pending: return const Color(0xFFF59E0B);
      case OrderStatus.processing: return const Color(0xFF6366F1);
      case OrderStatus.shipped: return const Color(0xFF8B5CF6);
      case OrderStatus.delivered: return const Color(0xFF10B981);
      case OrderStatus.cancelled: return const Color(0xFFEF4444);
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case OrderStatus.pending: return 'معلقة';
      case OrderStatus.processing: return 'معالجة';
      case OrderStatus.shipped: return 'مرسلة';
      case OrderStatus.delivered: return 'مُسلّمة';
      case OrderStatus.cancelled: return 'ملغاة';
    }
  }
}