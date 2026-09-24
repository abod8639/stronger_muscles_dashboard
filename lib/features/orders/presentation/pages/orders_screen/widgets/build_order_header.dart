import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/build_payment_badge.dart';

class OrderHeader extends StatelessWidget {
  final OrderEntity order;

  const OrderHeader({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;
    final formattedOrderId = _getFormattedOrderId(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: isMobile ? 6 : 8,
          runSpacing: 4,
          children: [
            _buildOrderIdChip(
              theme: theme,
              colorScheme: colorScheme,
              orderIdText: formattedOrderId,
              isMobile: isMobile,
            ),
            buildPaymentBadge(order),
          ],
        ),
        SizedBox(height: isMobile ? 4 : 6),
        _buildDateRow(
          theme: theme,
          colorScheme: colorScheme,
          isMobile: isMobile,
        ),
      ],
    );
  }

  Widget _buildOrderIdChip({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required String orderIdText,
    required bool isMobile,
  }) {
    final fullOrderId = '#${order.id}';

    return Tooltip(
      message: fullOrderId,
      waitDuration: const Duration(milliseconds: 300),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 7 : 9,
          vertical: isMobile ? 2 : 3,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Text(
          orderIdText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: isMobile ? 11.5 : 12.5,
            color: colorScheme.onSurface,
            letterSpacing: 0.5,
          ) ??
              TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: isMobile ? 11.5 : 12.5,
                color: colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
        ),
      ),
    );
  }

  Widget _buildDateRow({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required bool isMobile,
  }) {
    final iconColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.7);
    final textStyle = (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: colorScheme.onSurfaceVariant,
      fontSize: isMobile ? 10.5 : 11.5,
      fontWeight: FontWeight.w500,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time_rounded,
          size: isMobile ? 12 : 13,
          color: iconColor,
        ),
        const SizedBox(width: 4),
        Text(
          _formatDate(order.orderDate),
          style: textStyle,
        ),
      ],
    );
  }

  String _getFormattedOrderId(BuildContext context) {
    final id = order.id.toString();

    if (context.isMobile) {
      return id.length > 8 ? '#${id.substring(id.length - 6)}' : '#$id';
    }

    if (context.isTablet) {
      return id.length > 12 ? '#${id.substring(0, 10)}...' : '#$id';
    }

    return id.length > 20 ? '#${id.substring(0, 18)}...' : '#$id';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return 'اليوم $hour:$minute';
    }
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';

    return '${date.day}/${date.month}/${date.year}';
  }
}
