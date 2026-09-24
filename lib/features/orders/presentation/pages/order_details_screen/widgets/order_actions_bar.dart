import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/order_details_controller.dart';

/// شريط الإجراءات السريعة للطلب (تأكيد، طباعة، مشاركة، إلغاء)
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
      final isPending = currentStatus == OrderStatus.pending;
      final canCancel = currentStatus != OrderStatus.cancelled &&
          currentStatus != OrderStatus.delivered;

      final isUpdating = controller.isUpdatingStatus.value;
      final isGeneratingPdf = controller.isGeneratingPdf.value;

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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.bolt_rounded,
                      size: 18,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'إجراءات سريعة:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // زر طباعة الفاتورة / PDF
                  FilledButton.tonalIcon(
                    onPressed: isGeneratingPdf ? null : controller.printInvoice,
                    icon: isGeneratingPdf
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.print_outlined, size: 18),
                    label: const Text('طباعة الفاتورة / PDF'),
                  ),

                  // زر مشاركة ملف PDF
                  IconButton.filledTonal(
                    onPressed: isGeneratingPdf ? null : controller.shareInvoice,
                    icon: const Icon(Icons.share_outlined, size: 18),
                    tooltip: 'مشاركة ملف الفاتورة PDF',
                  ),

                  // زر تأكيد الطلب (قيد الانتظار -> قيد المعالجة)
                  if (isPending)
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: isUpdating ? null : controller.confirmOrder,
                      icon: isUpdating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle_outline_rounded, size: 18),
                      label: const Text('تأكيد الطلب'),
                    ),

                  // زر بدء الشحن (قيد المعالجة -> تم الشحن)
                  if (currentStatus == OrderStatus.processing)
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.indigo.shade600,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: isUpdating ? null : controller.shipOrder,
                      icon: isUpdating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.local_shipping_outlined, size: 18),
                      label: const Text('بدء الشحن'),
                    ),

                  // زر تأكيد التوصيل (تم الشحن -> تم التوصيل)
                  if (currentStatus == OrderStatus.shipped)
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: isUpdating ? null : controller.deliverOrder,
                      icon: isUpdating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.task_alt_rounded, size: 18),
                      label: const Text('تأكيد التوصيل'),
                    ),

                  // زر تغيير الحالة يدويًا لأي حالة
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                    ),
                    onPressed: isUpdating
                        ? null
                        : () => _showChangeStatusDialog(context),
                    icon: const Icon(Icons.edit_note_rounded, size: 18),
                    label: const Text('تغيير الحالة...'),
                  ),

                  // زر إلغاء الطلب
                  if (canCancel)
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(
                          color: colorScheme.error.withValues(alpha: 0.7),
                        ),
                      ),
                      onPressed: isUpdating
                          ? null
                          : () => _showCancelConfirmationDialog(context),
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('إلغاء الطلب'),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  /// حوار تغيير حالة الطلب يدويًا
  Future<void> _showChangeStatusDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentStatus = controller.order.value.status;
    OrderStatus selectedStatus = currentStatus;

    final confirmed = await showDialog<OrderStatus>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: isSelected
                      ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                      : null,
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline,
                  ),
                  title: Text(
                    controller.getStatusText(status),
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                  onTap: () {
                    setState(() => selectedStatus = status);
                  },
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

  /// حوار تأكيد إلغاء الطلب
  Future<void> _showCancelConfirmationDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final orderId = controller.order.value.id;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: Icon(
          Icons.warning_amber_rounded,
          color: colorScheme.error,
          size: 36,
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
