import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/index.dart';

class AnimatedOrderListTile extends StatefulWidget {
  final OrderModel order;
  final VoidCallback? onTap;
  final int index;

  const AnimatedOrderListTile({
    super.key,
    required this.order,
    this.onTap,
    required this.index,
  });

  @override
  State<AnimatedOrderListTile> createState() => _AnimatedOrderListTileState();
}

class _AnimatedOrderListTileState extends State<AnimatedOrderListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _extractAddress(Map<String, dynamic>? snapshot) {
    if (snapshot == null || snapshot.isEmpty) {
      return 'العنوان غير متوفر';
    }

    Map<String, dynamic> addressData = {};
    if (snapshot.containsKey('address')) {
      addressData = snapshot['address']!;
    } else {
      // Fallback for slightly different structures
      addressData = snapshot.values.isNotEmpty ? snapshot.values.first : {};
    }

    final city = addressData['city'] ?? addressData['City'] ?? '';
    final street = addressData['street'] ?? addressData['Street'] ?? '';

    final fullAddress = [city, street].where((s) => s.isNotEmpty).join(', ');

    return fullAddress.isNotEmpty ? fullAddress : 'العنوان غير محدد';
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.backgroundLight,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.15),
                              AppColors.primary.withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'الطلب: #${widget.order.id}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                _OrderStatusBadge(status: widget.order.status),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.order.totalAmount.toStringAsFixed(2)} ر.س',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _formatDate(widget.order.orderDate),
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 16, thickness: 0.5),
                            _buildInfoRow(Icons.person_outline,
                                'العميل: ${widget.order.userId}'),
                            const SizedBox(height: 4),
                            if (widget.order.phoneNumber != null &&
                                widget.order.phoneNumber!.isNotEmpty) ...[
                              _buildInfoRow(
                                  Icons.phone_outlined, widget.order.phoneNumber!),
                              const SizedBox(height: 4),
                            ],
                            _buildInfoRow(
                              Icons.location_on_outlined,
                              _extractAddress(widget.order.shippingAddressSnapshot),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'قبل ${difference.inDays} أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _OrderStatusBadge({required this.status});

  Color _getStatusColor() {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.pending;
      case OrderStatus.processing:
        return AppColors.processing;
      case OrderStatus.shipped:
        return AppColors.shipped;
      case OrderStatus.delivered:
        return AppColors.delivered;
      case OrderStatus.cancelled:
        return AppColors.cancelled;
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case OrderStatus.pending:
        return 'معلقة';
      case OrderStatus.processing:
        return 'قيد المعالجة';
      case OrderStatus.shipped:
        return 'مرسلة';
      case OrderStatus.delivered:
        return 'مُسلّمة';
      case OrderStatus.cancelled:
        return 'ملغاة';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(
        _getStatusLabel(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
