import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/icon_card_with_shadow.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/order_details_controller.dart';

/// شريط الإجراءات السريعة للطلب بنظام Material Design 3
class OrderActionsBar extends StatelessWidget {
  final OrderDetailsController controller;

  const OrderActionsBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final currentOrder = controller.order.value;
      final currentStatus = currentOrder.status;
      final isUpdating = controller.isUpdatingStatus.value;
      final isGeneratingPdf = controller.isGeneratingPdf.value;

      final canCancel = currentStatus != OrderStatus.cancelled &&
          currentStatus != OrderStatus.delivered;

      return Card.outlined(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        color: colorScheme.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              // عنوان الشريط والمؤشر
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconCardWithShadow(icon: Icons.bolt_rounded),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'إجراءات الطلب',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'إدارة الحالة والمستندات',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // أزرار الإجراءات المتوافقة تماماً مع Material Design 3
              Wrap(
                
                spacing: 10,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // 1. زر الإجراء الأساسي الموجه لمرحلة الطلب
                  _buildPrimaryActionButton(
                    context: context,
                    currentStatus: currentStatus,
                    isUpdating: isUpdating,
                    colorScheme: colorScheme,
                  ),

                  // 2. طباعة الفاتورة (M3 FilledButton.tonal)
                  FilledButton.tonalIcon(
                    onPressed: isGeneratingPdf ? null : controller.printInvoice,
                    icon: isGeneratingPdf
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          )
                        : const Icon(Icons.print_outlined, size: 18),
                    label: const Text('طباعة الفاتورة'),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // 3. تصدير ومشاركة PDF (M3 IconButton.filledTonal)
                  IconButton.filledTonal(
                    onPressed: isGeneratingPdf ? null : controller.shareInvoice,
                    icon: const Icon(Icons.share_outlined, size: 18),
                    tooltip: 'تصدير ومشاركة PDF',
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // 4. تغيير الحالة يدوياً (M3 OutlinedButton)
                  OutlinedButton.icon(
                    onPressed: isUpdating
                        ? null
                        : () => _showChangeStatusDialog(context),
                    icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                    label: const Text('تغيير الحالة'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.onSurface,
                      side: BorderSide(
                        color: colorScheme.outlineVariant,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // 5. إلغاء الطلب (M3 Destructive OutlinedButton)
                  if (canCancel)
                    OutlinedButton.icon(
                      onPressed: isUpdating
                          ? null
                          : () => _showCancelConfirmationDialog(context),
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('إلغاء الطلب'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(
                          color: colorScheme.error.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  /// زر الإجراء الأساسي الموجه لمرحلة الطلب الحالية وفق معايير Material 3
  Widget _buildPrimaryActionButton({
    required BuildContext context,
    required OrderStatus currentStatus,
    required bool isUpdating,
    required ColorScheme colorScheme,
  }) {
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    switch (currentStatus) {
      case OrderStatus.pending:
        return FilledButton.icon(
          onPressed: isUpdating ? null : controller.confirmOrder,
          icon: isUpdating
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onPrimary,
                  ),
                )
              : const Icon(Icons.check_circle_outline_rounded, size: 18),
          label: const Text('تأكيد الطلب'),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: buttonShape,
          ),
        );

      case OrderStatus.processing:
        return FilledButton.icon(
          onPressed: isUpdating ? null : controller.shipOrder,
          icon: isUpdating
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onPrimary,
                  ),
                )
              : const Icon(Icons.local_shipping_outlined, size: 18),
          label: const Text('بدء الشحن'),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: buttonShape,
          ),
        );

      case OrderStatus.shipped:
        return FilledButton.icon(
          onPressed: isUpdating ? null : controller.deliverOrder,
          icon: isUpdating
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onPrimary,
                  ),
                )
              : const Icon(Icons.task_alt_rounded, size: 18),
          label: const Text('تأكيد التوصيل'),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: buttonShape,
          ),
        );

      case OrderStatus.delivered:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_rounded,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'الطلب مكتمل',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );

      case OrderStatus.cancelled:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.error.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cancel_rounded,
                size: 16,
                color: colorScheme.error,
              ),
              const SizedBox(width: 6),
              Text(
                'الطلب ملغي',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
        );
    }
  }

  /// حوار تغيير حالة الطلب يدويًا بنمط Material 3
  Future<void> _showChangeStatusDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentStatus = controller.order.value.status;
    OrderStatus selectedStatus = currentStatus;

    final confirmed = await showDialog<OrderStatus>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          icon: Icon(
            Icons.swap_horiz_rounded,
            size: 28,
            color: colorScheme.primary,
          ),
          title: Text(
            'تغيير حالة الطلب',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: OrderStatus.values.map((status) {
                final isSelected = selectedStatus == status;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.5)
                            : colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    tileColor: isSelected
                        ? colorScheme.primaryContainer.withValues(alpha: 0.35)
                        : colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                    leading: Icon(
                      isSelected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    title: Text(
                      controller.getStatusText(status),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      setState(() => selectedStatus = status);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(selectedStatus),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('حفظ التغيير'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != null && confirmed != currentStatus) {
      await controller.updateOrderStatus(confirmed);
    }
  }

  /// حوار تأكيد إلغاء الطلب بنمط Material 3
  Future<void> _showCancelConfirmationDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final orderId = controller.order.value.id;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(
          Icons.warning_amber_rounded,
          color: colorScheme.error,
          size: 32,
        ),
        title: Text(
          'تأكيد إلغاء الطلب',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في إلغاء هذا الطلب رقم #$orderId؟\nسيتم تغيير حالة الطلب إلى "ملغي".',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('تراجع'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('نعم، إلغاء الطلب'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await controller.cancelOrder();
    }
  }
}
