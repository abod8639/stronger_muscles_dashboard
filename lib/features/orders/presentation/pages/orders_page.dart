import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/orders_table.dart';
import '../widgets/orders_stats_section.dart';

class OrdersPage extends GetView<OrdersController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BaseAppBar(
        extraActions: [
          _buildHeaderButton(
            context,
            icon: Icons.download_rounded,
            label: 'Export CSV',
            onTap: () {
              // TODO: implement export CSV
            },
            isOutline: true,
          ),
        ],
        title: 'إدارة الطلبات',
        onPressed: controller.fetchOrders,
        icon: Icons.refresh_rounded,
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
            ),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height:responsive.isDesktop ? 180 : 320, 
                  child: OrdersStatsSection()),
            const    SizedBox(height: 10),
            const    OrdersTable(),
            const    SizedBox(height: 10),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isOutline = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    if (isOutline) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        ),
      );
    }
    return FilledButton.tonalIcon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
    );
  }
}
