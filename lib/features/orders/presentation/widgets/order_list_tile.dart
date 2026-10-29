import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/icon_card_with_shadow.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/components/price_text.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/order_images_stack.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/order_status_ui.dart';
import 'package:stronger_muscles_dashboard/features/settings/settings_feature.dart';

/// بطاقة الطلب في القوائم (صفحة الطلبات على الهاتف/اللوحي، والطلبات الأخيرة في لوحة التحكم)
class OrderListTile extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final currency = ref.watch(storeCurrencyProvider);

    return SoftSurface(
      onTap: onTap,
      borderRadius: context.isMobile
          ? AppDesignTokens.radiusCard
          : AppDesignTokens.radiusLarge,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = context.isMobile || constraints.maxWidth < 320;
          final gap = isCompact
              ? AppDesignTokens.space8
              : AppDesignTokens.space10;

          final content = Padding(
            padding: EdgeInsets.all(
              isCompact ? AppDesignTokens.space10 : AppDesignTokens.space12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _OrderHeader(order: order)),
                    const SizedBox(width: AppDesignTokens.space8),
                    OrderStatusBadge(status: order.status),
                  ],
                ),
                SizedBox(height: gap),
                Row(
                  children: [
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.person_outline_rounded,
                        label: order.userName.isNotEmpty
                            ? order.userName
                            : order.userId.toString(),
                        sublabel: 'العميل',
                      ),
                    ),
                    SizedBox(width: gap),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.shopping_bag_outlined,
                        label: '${order.items.length}',
                        sublabel: order.items.length == 1
                            ? 'منتج واحد'
                            : 'منتجات',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: gap),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDesignTokens.space10,
                          vertical: AppDesignTokens.space6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: AppDesignTokens.radiusSmall,
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'الإجمالي',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            PriceText(
                              amount: order.totalAmount,
                              currency: currency,
                              color: colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (order.items.isNotEmpty) ...[
                      SizedBox(width: gap),
                      OrderImagesStack(order: order, size: isCompact ? 36 : 42),
                    ],
                  ],
                ),
              ],
            ),
          );

          // عند تقييد الارتفاع (شبكة لوحة التحكم) نصغّر المحتوى بدلاً من حدوث Overflow
          if (constraints.maxHeight.isFinite && constraints.maxHeight < 175) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topCenter,
              child: SizedBox(width: constraints.maxWidth, child: content),
            );
          }
          return content;
        },
      ),
    );
  }
}

/// رقم الطلب المختصر + حالة الدفع + التاريخ النسبي
class _OrderHeader extends StatelessWidget {
  final OrderEntity order;

  const _OrderHeader({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppDesignTokens.space6,
          runSpacing: AppDesignTokens.space4,
          children: [
            Tooltip(
              message: '#${order.id}',
              child: InfoPill(label: _shortId(context)),
            ),
            PaymentStatusBadge(status: order.paymentStatus),
          ],
        ),
        const SizedBox(height: AppDesignTokens.space4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 13,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            const SizedBox(width: AppDesignTokens.space4),
            Flexible(
              child: Text(
                _relativeDate(order.orderDate),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _shortId(BuildContext context) {
    final id = order.id.toString();
    final maxLength = context.isMobile ? 8 : (context.isTablet ? 12 : 20);
    return id.length > maxLength
        ? '#${id.substring(0, maxLength - 2)}…'
        : '#$id';
  }

  String _relativeDate(DateTime date) {
    final diff = DateTime.now().difference(date);
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

/// معلومة مصغرة (أيقونة + قيمة + وصف) داخل بطاقة الطلب
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.space8,
        vertical: AppDesignTokens.space6,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: AppDesignTokens.radiusSmall,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          IconCardWithShadow(
            icon: icon,
            size: 14,
            padding: const EdgeInsets.all(AppDesignTokens.space6),
            borderRadius: AppDesignTokens.radiusSmallValue,
          ),
          const SizedBox(width: AppDesignTokens.space8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  sublabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
