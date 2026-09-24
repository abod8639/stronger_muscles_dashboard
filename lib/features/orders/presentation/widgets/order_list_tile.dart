import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/status_badge.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/build_enhanced_order_images.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/build_info_section.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/build_order_header.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/build_price_section.dart';

/// بطاقة عرض عنصر الطلب المتوافقة بالكامل مع مواصفات وتصميم Material Design 3
/// متناسقة مع ألوان وثيم التطبيق وتدعم الوضع الفاتح والداكن بانتقالات بصرية سلسة.
class OrderListTile extends StatefulWidget {
  final OrderEntity order;
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

class _OrderListTileState extends State<OrderListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = context.isMobile;

    final borderRadius = BorderRadius.circular(isMobile ? 18 : 22);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.012 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: _isHovered
                ? colorScheme.surfaceContainer
                : colorScheme.surfaceContainerLow,
            borderRadius: borderRadius,
            border: Border.all(
              color: _isHovered
                  ? colorScheme.primary.withValues(alpha: 0.45)
                  : colorScheme.outlineVariant.withValues(alpha: 0.45),
              width: _isHovered ? 1.4 : 1.0,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: isDark ? 0.35 : 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              else
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: isDark ? 0.22 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: borderRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onTap,
              hoverColor: Colors.transparent,
              splashColor: colorScheme.primary.withValues(alpha: 0.08),
              highlightColor: colorScheme.primary.withValues(alpha: 0.04),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 12 : 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. ترويسة الطلب: المعرف والتاريخ + شارة الحالة
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: OrderHeader(order: widget.order),
                        ),
                        const SizedBox(width: 8),
                        OrderStatusBadge(status: widget.order.status),
                      ],
                    ),

                    SizedBox(height: isMobile ? 10 : 12),

                    // 2. معلومات العميل وعدد المنتجات بنمط M3
                    buildInfoSection(widget.order),

                    SizedBox(height: isMobile ? 10 : 12),

                    // 3. الجزء السفلي: الإجمالي + معرض صور المنتجات المضمنة
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: buildPriceSection(widget.order),
                        ),
                        const SizedBox(width: 10),
                        buildEnhancedOrderImages(widget.order, _isHovered),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
