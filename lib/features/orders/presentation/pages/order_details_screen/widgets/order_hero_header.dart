import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/order_details_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/order_status_ui.dart';
import 'order_quick_stats_strip.dart';

/// ترويسة الطلب: الرقم (مع النسخ)، حالتا الطلب والدفع، التاريخ، رقم التتبع، والإحصائيات السريعة
class OrderHeroHeader extends StatelessWidget {
  final OrderEntity order;
  final OrderDetailsController controller;

  const OrderHeroHeader({
    super.key,
    required this.order,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = intl.DateFormat('yyyy-MM-dd • hh:mm a');
    final hasTracking = order.trackingNumber?.isNotEmpty ?? false;

    return SoftSurface(
      padding: EdgeInsets.all(
        context.isMobile ? AppDesignTokens.space14 : AppDesignTokens.space18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppDesignTokens.space8,
            runSpacing: AppDesignTokens.space6,
            children: [
              _OrderIdChip(order: order, onCopy: controller.copyOrderId),
              OrderStatusBadge(status: order.status),
              PaymentStatusBadge(status: order.paymentStatus),
            ],
          ),
          const SizedBox(height: AppDesignTokens.space8),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppDesignTokens.space6),
              Text(
                dateFormat.format(order.orderDate),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (hasTracking) ...[
            const SizedBox(height: AppDesignTokens.space12),
            InfoPill(
              icon: Icons.local_shipping_outlined,
              label: 'رقم التتبع: ${order.trackingNumber}',
            ),
          ],
          const SizedBox(height: AppDesignTokens.space14),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppDesignTokens.space12),
          OrderQuickStatsStrip(order: order),
        ],
      ),
    );
  }
}

class _OrderIdChip extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onCopy;

  const _OrderIdChip({required this.order, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final style = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w800,
      color: colorScheme.onSurface,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.space10,
        vertical: AppDesignTokens.space4,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppDesignTokens.radiusSmall,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text.rich(
              TextSpan(
                text: 'طلب # ',
                style: style,
                children: [
                  TextSpan(
                    text: order.id,
                    style: style?.copyWith(color: colorScheme.primary),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppDesignTokens.space4),
          IconButton(
            onPressed: onCopy,
            tooltip: 'نسخ رقم الطلب',
            visualDensity: VisualDensity.compact,
            iconSize: 15,
            icon: Icon(Icons.copy_rounded, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
