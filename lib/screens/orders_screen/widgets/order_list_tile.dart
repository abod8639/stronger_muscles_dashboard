import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/screens/components/status_badge.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_enhanced_order_images.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_info_section.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_order_header.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_price_section.dart';
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
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _scaleController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _scaleController.reverse();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: GlassContainer(
          padding: EdgeInsets.zero,
          opacity: _isHovered ? 0.15 : 0.08,
          blur: 20,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withOpacity(0.4)
                : Colors.white.withOpacity(0.08),
            width: _isHovered ? 2 : 1.5,
          ),
          gradient: _isHovered
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    Colors.transparent,
                  ],
                )
              : null,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(24),
            splashColor: AppColors.primary.withOpacity(0.1),
            highlightColor: AppColors.primary.withOpacity(0.05),
            child: Stack(
              children: [
                // Animated gradient overlay
                if (_isHovered)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.03),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: OrderHeader(order: widget.order)),
                          const SizedBox(width: 12),
                          OrderStatusBadge(status: widget.order.status),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Info Section
                      buildInfoSection(widget.order),

                      const Spacer(),

                      // Bottom Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(child: buildPriceSection(widget.order)),
                          const SizedBox(width: 1),
                          buildEnhancedOrderImages(widget.order, _isHovered),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
