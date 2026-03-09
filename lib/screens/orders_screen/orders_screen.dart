import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/screens/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/screens/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_stats_section.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/orders_table.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام Get.find() بدلاً من Get.put() لتجنب إنشاء instances جديدة
    final controller = Get.find<OrdersController>();
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppColorsExtended.backgroundColor,

      //  Colors.transparent,
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
        // حالة التحميل الأولية
        if (controller.isLoading.value && controller.filteredOrders.isEmpty) {
          return const EnhancedLoadingWidget(message: 'جاري تحميل الطلبات...');
        }

        return MyRefreshIndicator(
          onRefresh: () async => await controller.fetchOrders(),

          child: SingleChildScrollView(
            physics:
                // responsive.isDesktop
                // ? const NeverScrollableScrollPhysics()
                // :
                const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: responsive.defaultPadding.left,
              // vertical: responsive.defaultPadding.top,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Row
                if (responsive.isDesktop)
                  SizedBox(height: 160, child: buildStatsSection()),

                const SizedBox(height: 10),

                // The Main Table
                const OrdersTable(),

                const SizedBox(height: 10),
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
        color: isOutline ? Colors.transparent : AppColors.primary,
        borderRadius: BorderRadius.circular(10),
        border: isOutline
            ? Border.all(color: Colors.white.withValues(alpha: 0.1))
            : null,
        boxShadow: isOutline
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
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
