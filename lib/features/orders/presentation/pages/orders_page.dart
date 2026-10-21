import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_binding.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_providers.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/orders_table.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/orders_error_card.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/orders_stats_section.dart';

/// صفحة إدارة الطلبات المحدثة بالكامل والمحمية بنمط Clean Architecture
/// وتعتمد على Riverpod [AsyncValue.when] لمنع أي تجميد للواجهة أو انهيار للتطبيق
class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  @override
  void initState() {
    super.initState();
    // تهيئة الـ GetX Controller Bridge إن لم يكن موجوداً
    if (!Get.isRegistered<OrdersController>()) {
      OrdersBinding().dependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Get.snackbar(
                  'تصدير الطلبات',
                  'جاري إعداد وتحميل ملف البيانات بصيغة CSV...',
                  backgroundColor: colorScheme.primaryContainer,
                  colorText: colorScheme.onPrimaryContainer,
                  icon: Icon(Icons.download_rounded, color: colorScheme.primary),
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 16,
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
