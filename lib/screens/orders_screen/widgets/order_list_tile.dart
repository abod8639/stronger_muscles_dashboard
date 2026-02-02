import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/screens/components/status_badge.dart';
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
  State<OrderListTile> createState() => _OrderListTileState();
}

class _OrderListTileState extends State<OrderListTile>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: GlassContainer(
          padding: EdgeInsets.zero,
          opacity: _isHovered ? 0.12 : 0.07,
          blur: 15,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withOpacity(0.3)
                : Colors.white.withOpacity(0.05),
            width: 1.5,
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildOrderID(),
                      OrderStatusBadge(status: widget.order.status),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.order.totalAmount.toStringAsFixed(2)} SAR',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildInfoRow(
                              icon: Icons.person_outline,
                              text: 'العميل: ${widget.order.userId}',
                            ),
                          ],
                        ),
                      ),
                      _buildOrderImage(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderID() {
    String order() {
      bool isMobile = MediaQuery.of(context).size.width < 600;
      if (isMobile) {
        return widget.order.id.toString().padLeft(4, '0').substring(10);
      }
      return widget.order.id.toString().padLeft(4, '0');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order(),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        Text(
          _formatDate(widget.order.orderDate),
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderImage() {
    final items = widget.order.items ?? [];
    if (items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: 45,
      height: 45,
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(items.length > 2 ? 2 : items.length, (index) {
          return Positioned(
            right: index * 12.0,
            bottom: index * 4.0,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 8,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: items[index].imageUrl ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.white10,
                    child: const Icon(
                      Icons.inventory_2,
                      size: 14,
                      color: Colors.white24,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.white38),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0)
      return 'اليوم، ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    if (diff.inDays == 1) return 'أمس';
    return '${date.day}/${date.month}/${date.year}';
  }
}
