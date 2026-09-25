import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/status_badge.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/build_enhanced_order_images.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/build_info_section.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/build_order_header.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/build_price_section.dart';

/// بطاقة عرض عنصر الطلب بتصميم Neumorphism / Soft UI
/// متناسقة ديناميكياً مع ألوان وثيم التطبيق وتدعم الوضع الفاتح والداكن بانتقالات بصرية وتفاعلية ملموسة.
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
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = context.isMobile;

    final borderRadius = BorderRadius.circular(isMobile ? 20 : 24);

    final double currentScale = _isPressed
        ? 0.985
        : (_isHovered ? 1.012 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: widget.onTap != null ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: widget.onTap != null
            ? (_) {
                setState(() => _isPressed = false);
                widget.onTap?.call();
              }
            : null,
        onTapCancel: widget.onTap != null ? () => setState(() => _isPressed = false) : null,
        child: AnimatedScale(
          scale: currentScale,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Color.lerp(colorScheme.surfaceContainer, Colors.white, _isHovered ? 0.05 : 0.03)!,
                        Color.lerp(colorScheme.surfaceContainer, Colors.black, _isHovered ? 0.05 : 0.09)!,
                      ]
                    : [
                        Color.lerp(colorScheme.surfaceContainer, Colors.white, _isHovered ? 0.75 : 0.65)!,
                        Color.lerp(colorScheme.surfaceContainer, Colors.black, _isHovered ? 0.01 : 0.035)!,
                      ],
              ),
              boxShadow: _isPressed
                  ? [
                      // في حالة الضغط، تتراجع الظلال لمحاكاة انضغاط السطح
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.3)
                            : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
                        offset: const Offset(2, 2.5),
                        blurRadius: 5,
                      ),
                    ]
                  : [
                      // الظل السفلي الغامق (Drop Shadow)
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: _isHovered ? 0.65 : 0.55)
                            : const Color(0xFFA3B1C6).withValues(alpha: _isHovered ? 0.55 : 0.42),
                        offset: _isHovered ? const Offset(6, 8) : const Offset(4, 6),
                        blurRadius: _isHovered ? 18 : 14,
                        spreadRadius: 0,
                      ),
                      // الظل العلوي الفاتح العاكس للضوء (Highlight Glow)
                      BoxShadow(
                        color: isDark
                            ? Colors.white.withValues(alpha: _isHovered ? 0.06 : 0.04)
                            : Colors.white.withValues(alpha: _isHovered ? 1.0 : 0.95),
                        offset: _isHovered ? const Offset(-4, -4) : const Offset(-3, -3),
                        blurRadius: _isHovered ? 14 : 10,
                        spreadRadius: 0,
                      ),
                      // وهج ناعم بلون السمة عند التحويم
                      if (_isHovered)
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: isDark ? 0.10 : 0.12),
                          offset: const Offset(0, 4),
                          blurRadius: 16,
                          spreadRadius: -2,
                        ),
                    ],
              border: Border.all(
                color: isDark
                    ? (_isHovered
                        ? colorScheme.primary.withValues(alpha: 0.35)
                        : Colors.white.withValues(alpha: 0.06))
                    : (_isHovered
                        ? colorScheme.primary.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.85)),
                width: _isHovered ? 1.3 : 1.0,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: borderRadius,
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
