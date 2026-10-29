import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/components/icon_card_with_shadow.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/order_details_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/order_status_ui.dart';

/// شريط الإجراءات السريعة للطلب: نقل المرحلة، الفاتورة، تغيير الحالة، والإلغاء
class OrderActionsBar extends StatelessWidget {
  final OrderDetailsController controller;

  const OrderActionsBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final status = controller.order.status;
        final isUpdating = controller.isUpdatingStatus;
        final isGeneratingPdf = controller.isGeneratingPdf;
        final canCancel =
            status != OrderStatus.cancelled && status != OrderStatus.delivered;

        return SoftSurface(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.space16,
            vertical: AppDesignTokens.space12,
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppDesignTokens.space12,
            runSpacing: AppDesignTokens.space10,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const IconCardWithShadow(icon: Icons.bolt_rounded),
                  const SizedBox(width: AppDesignTokens.space10),
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Wrap(
                spacing: AppDesignTokens.space10,
                runSpacing: AppDesignTokens.space8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildNextStepAction(status, isUpdating, colorScheme),
                  FilledButton.tonalIcon(
                    onPressed: isGeneratingPdf ? null : controller.printInvoice,
                    icon: isGeneratingPdf
                        ? const _ButtonSpinner()
                        : const Icon(Icons.print_outlined, size: 18),
                    label: const Text('طباعة الفاتورة'),
                  ),
                  IconButton.filledTonal(
                    onPressed: isGeneratingPdf ? null : controller.shareInvoice,
                    icon: const Icon(Icons.share_outlined, size: 18),
                    tooltip: 'تصدير ومشاركة PDF',
                  ),
                  OutlinedButton.icon(
                    onPressed: isUpdating
                        ? null
                        : () => _showChangeStatusDialog(context),
                    icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                    label: const Text('تغيير الحالة'),
                  ),
                  if (canCancel)
                    OutlinedButton.icon(
                      onPressed: isUpdating
                          ? null
                          : () => _showCancelConfirmation(context),
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('إلغاء الطلب'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(
                          color: colorScheme.error.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// زر نقل الطلب للمرحلة التالية، أو شارة الحالة إذا انتهت دورة الطلب
  Widget _buildNextStepAction(
    OrderStatus status,
    bool isUpdating,
    ColorScheme colorScheme,
  ) {
    final (String, IconData, VoidCallback, Color)? step = switch (status) {
      OrderStatus.pending => (
        'تأكيد الطلب',
        Icons.check_circle_outline_rounded,
        controller.confirmOrder,
        AppColors.success,
      ),
      OrderStatus.processing => (
        'بدء الشحن',
        Icons.local_shipping_outlined,
        controller.shipOrder,
        colorScheme.primary,
      ),
      OrderStatus.shipped => (
        'تأكيد التوصيل',
        Icons.task_alt_rounded,
        controller.deliverOrder,
        colorScheme.primary,
      ),
      OrderStatus.delivered || OrderStatus.cancelled => null,
    };

    if (step == null) {
      return InfoPill(
        label: status == OrderStatus.delivered ? 'الطلب مكتمل' : 'الطلب ملغي',
        icon: status.icon,
        color: status.color,
      );
    }

    final (label, icon, action, color) = step;
    final foreground =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black;

    return FilledButton.icon(
      onPressed: isUpdating ? null : action,
      icon: isUpdating
          ? _ButtonSpinner(color: foreground)
          : Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: foreground,
      ),
    );
  }

  Future<void> _showChangeStatusDialog(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;
    final currentStatus = controller.order.status;
    var selectedStatus = currentStatus;

    final confirmed = await showDialog<OrderStatus>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          icon: Icon(
            Icons.swap_horiz_rounded,
            size: 28,
            color: colorScheme.primary,
          ),
          title: const Text('تغيير حالة الطلب', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final status in OrderStatus.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: ListTile(
                      selected: selectedStatus == status,
                      selectedColor: status.color,
                      selectedTileColor: status.color.withValues(alpha: 0.12),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppDesignTokens.radiusMedium,
                        side: BorderSide(
                          color: selectedStatus == status
                              ? status.color.withValues(alpha: 0.5)
                              : colorScheme.outlineVariant.withValues(
                                  alpha: 0.3,
                                ),
                        ),
                      ),
                      leading: Icon(status.icon, color: status.color, size: 20),
                      title: Text(status.label),
                      trailing: selectedStatus == status
                          ? const Icon(Icons.check_rounded)
                          : null,
                      onTap: () => setState(() => selectedStatus = status),
                    ),
                  ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
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

  Future<void> _showCancelConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'تأكيد إلغاء الطلب',
        message:
            'هل أنت متأكد من رغبتك في إلغاء الطلب رقم #${controller.order.id}؟\n'
            'سيتم تغيير حالة الطلب إلى "${OrderStatus.cancelled.label}".',
        confirmText: 'نعم، إلغاء الطلب',
        confirmColor: Theme.of(ctx).colorScheme.error,
        icon: Icons.warning_amber_rounded,
        onConfirm: () => Navigator.of(ctx).pop(true),
      ),
    );

    if (confirmed == true) {
      await controller.cancelOrder();
    }
  }
}

class _ButtonSpinner extends StatelessWidget {
  final Color? color;

  const _ButtonSpinner({this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
