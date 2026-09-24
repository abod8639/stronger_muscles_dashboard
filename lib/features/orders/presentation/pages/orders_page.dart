import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/orders_table.dart';
import '../widgets/orders_stats_section.dart';

/// صفحة إدارة الطلبات المحدثة بالكامل وفق معايير وتصميم Material Design 3
class OrdersPage extends GetView<OrdersController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: BaseAppBar(
        title: 'إدارة الطلبات',
        icon: Icons.refresh_rounded,
        onPressed: controller.fetchOrders,
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
      body: Obx(() {
        if (controller.isLoading.value && controller.filteredOrders.isEmpty) {
          return const EnhancedLoadingWidget(message: 'جاري تحميل الطلبات...');
        }

        return MyRefreshIndicator(
          onRefresh: () async => await controller.fetchOrders(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: responsive.defaultPadding.left,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // 1. بطاقات المؤشرات والإحصائيات بنمط Material 3
                OrdersStatsSection(),

                SizedBox(height: 18),

                // 2. جدول وعمليات الطلبات
                OrdersTable(),

                SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }
}
