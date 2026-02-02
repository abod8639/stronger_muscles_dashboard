import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/screens/components/top_section.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_stats_section.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/order_list_tile.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_empty_state.dart';
import 'package:stronger_muscles_dashboard/screens/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/components/horizontal_chips_selector.dart';
import 'package:stronger_muscles_dashboard/screens/components/custom_search_bar.dart';
import '../components/enhanced_error_widget.dart';
import '../../controllers/orders_controller.dart';
import '../components/index.dart';
import '../../config/responsive.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: BaseAppBar(
        title: 'الطلبات',
        onPressed: controller.fetchOrders,
        icon: Icons.refresh_rounded,
      ),
      body: Column(
        children: [
          TopSection(
            children: [
              CustomSearchBar(
                hintText: 'ابحث عن الطلبات بالرقم أو اسم العميل...',
                padding: responsive.defaultPadding,
                onSearch: (value) => controller.onSearchChanged(value),
              ),

              Obx(
                () => HorizontalChipsSelector(
                  items: controller.statusItems,
                  selectedId: controller.selectedStatusId.value,
                  onSelect: (id) => controller.selectedStatusId.value = id,
                  showAllOption: true,
                  allLabel: 'جميع الطلبات',
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (responsive.isDesktop)
            GlassContainer(child: buildStatsSection(controller, responsive)),

          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.filteredOrders.isEmpty) {
                return const Center(
                  child: EnhancedLoadingWidget(
                    message: 'جاري تحميل الطلبات...',
                  ),
                );
              }

              if (controller.errorMessage.isNotEmpty &&
                  controller.filteredOrders.isEmpty) {
                return EnhancedErrorWidget(
                  title: 'حدث خطأ',
                  icon: Icons.error,
                  message: controller.errorMessage.value,
                  onRetry: () => controller.fetchOrders(),
                );
              }

              if (controller.filteredOrders.isEmpty) {
                return buildEmptyState(controller);
              }

              return MyRefreshIndicator(
                onRefresh: () => controller.fetchOrders(),
                child: AnimationLimiter(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.defaultPadding.left,
                      vertical: 10,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: responsive.getOrdersColumns(),
                      crossAxisSpacing: responsive.itemSpacing,
                      mainAxisSpacing: responsive.itemSpacing,
                      mainAxisExtent: 180, // Fixed height for consistency
                    ),
                    itemCount: controller.filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = controller.filteredOrders[index];
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: responsive.getOrdersColumns(),
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: OrderListTile(
                              index: index,
                              order: order,
                              onTap: () {
                                Get.to(() => OrderDetailsScreen(order: order));
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }


}
