import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_providers.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/orders_table.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/orders_error_card.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/orders_stats_section.dart';

/// صفحة إدارة الطلبات المحدثة بالكامل والمحمية بنمط Clean Architecture
/// وتعتمد على Riverpod [AsyncValue.when] لمنع أي تجميد للواجهة أو انهيار للتطبيق
class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersControllerProvider);
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: BaseAppBar(
        title: 'إدارة الطلبات',
        icon: Icons.refresh_rounded,
        onPressed: () => ref
            .read(ordersControllerProvider.notifier)
            .refreshOrders(forceRefresh: true),
        extraActions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: FilledButton.tonalIcon(
              onPressed: () {
                AppFeedback.showSuccess(
                  'جاري إعداد وتحميل ملف البيانات بصيغة CSV...',
                );
              },
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('تصدير CSV'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
            ),
          ),
        ],
      ),
      body: MyRefreshIndicator(
        onRefresh: () => ref
            .read(ordersControllerProvider.notifier)
            .refreshOrders(forceRefresh: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: responsive.defaultPadding.left,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. بطاقات المؤشرات والإحصائيات بنمط Material 3
              const OrdersStatsSection(),

              const SizedBox(height: 18),

              // 2. التحقق من حالة Riverpod عبر AsyncValue.when لعرض Fallback UI
              ordersAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: EnhancedLoadingWidget(message: 'جاري تحميل الطلبات...'),
                  ),
                ),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: OrdersErrorCard(
                        error: error,
                        onRetry: () => ref
                            .read(ordersControllerProvider.notifier)
                            .refreshOrders(forceRefresh: true),
                        onDismiss: () => ref
                            .read(ordersControllerProvider.notifier)
                            .clearError(),
                      ),
                    ),
                  ),
                ),
                data: (orders) => const OrdersTable(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
