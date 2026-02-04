import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/screens/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/screens/components/top_section.dart';
import 'package:stronger_muscles_dashboard/screens/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/screens/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_recent_orders.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_stats_section.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: BaseAppBar(
        title: 'إدارة الطلبات',
        onPressed: controller.fetchOrders,
        icon: Icons.refresh_rounded,
      ),
      body: Obx(() {
        // حالة التحميل الأولية
        if (controller.isLoading.value && controller.filteredOrders.isEmpty) {
          return const EnhancedLoadingWidget(message: 'جاري تحميل الطلبات...');
        }

        return Column(
          children: [
            // قسم البحث والإحصائيات العلوي (نفس نمط UsersScreen)
            TopSection(
              children: [
                CustomSearchBar(
                  hintText: 'ابحث برقم الطلب، اسم العميل، أو الحالة...',
                  padding: responsive.defaultPadding,
                  onSearch: (value) => controller.onSearchChanged(value),
                ),

                // عرض الإحصائيات (Stats) فقط في الشاشات الكبيرة لتجنب الازدحام
                if (responsive.isDesktop || responsive.isTablet)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.defaultPadding.left,
                      vertical: 8,
                    ),
                    child: GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: buildStatsSection(),
                    ),
                  ),
              ],
            ),

            // قائمة الطلبات أو حالات الخطأ/الفراغ
            Expanded(
              child: controller.filteredOrders.isEmpty
                  ? _buildEmptyOrErrorState(controller)
                  : MyRefreshIndicator(
                      onRefresh: controller.fetchOrders,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          bottom: responsive.defaultPadding.bottom,
                        ),
                        child: buildRecentOrders(responsive),
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }

  // دالة مساعدة للتعامل مع حالات الخطأ أو البحث الفارغ
  Widget _buildEmptyOrErrorState(OrdersController controller) {
    final isSearching = controller.searchQuery.value.isNotEmpty;
    final hasError = controller.errorMessage.isNotEmpty;

    return EnhancedErrorWidget(
      title: hasError
          ? 'حدث خطأ ما'
          : (isSearching ? 'لا توجد نتائج' : 'لا توجد طلبات'),
      message: hasError
          ? controller.errorMessage.value
          : (isSearching
                ? 'لم نجد أي طلب يطابق: "${controller.searchQuery.value}"'
                : 'قائمة الطلبات فارغة حالياً'),
      icon: hasError
          ? Icons.error_outline
          : (isSearching ? Icons.search_off : Icons.inbox_outlined),
      onRetry: () {
        if (isSearching) {
          controller.onSearchChanged('');
        } else {
          controller.fetchOrders();
        }
      },
      // btnText: isSearching ? 'مسح البحث' : 'إعادة المحاولة',
    );
  }
}
