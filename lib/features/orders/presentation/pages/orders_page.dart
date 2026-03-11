import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/orders_table.dart';
import '../widgets/orders_stats_section.dart';

class OrdersPage extends GetView<OrdersController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppColorsExtended.backgroundColor,
      appBar: BaseAppBar(
        extraActions: [
          _buildHeaderButton(
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 180, child: OrdersStatsSection()),
                SizedBox(height: 10),
                OrdersTable(),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isOutline = false,
  }) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : const Color(0xFFFF1744), // AppColors.primary
        borderRadius: BorderRadius.circular(10),
        border: isOutline
            ? Border.all(color: Colors.white.withValues(alpha: 0.1))
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
