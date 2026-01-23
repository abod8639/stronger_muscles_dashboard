import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/enhanced_error_widget.dart';
import '../../controllers/orders_controller.dart';
import '../../components/index.dart';
import '../../config/theme.dart';
import '../../config/responsive.dart';
import '../../models/order_model.dart';
import 'widgets/order_details_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: buildAppBar(context, controller, responsive),
      body: Column(
        children: [
          buildSearchBar(context, controller, responsive),
          buildStatusTabs(context, controller, responsive),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.filteredOrders.isEmpty) {
                return const Center(child: EnhancedLoadingWidget(message: 'جاري تحميل الطلبات...'));
              }

              if (controller.errorMessage.isNotEmpty && controller.filteredOrders.isEmpty) {
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

              return RefreshIndicator(
                onRefresh: () => controller.fetchOrders(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.defaultPadding.left,
                    vertical: 10,
                  ),
                  itemCount: controller.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = controller.filteredOrders[index];
                    return AnimatedOrderListTile(
                      order: order,
                      index: index,
                      onTap: () {
                        Get.to(() => OrderDetailsScreen(order: order));
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
  PreferredSizeWidget buildAppBar(BuildContext context, OrdersController controller, ResponsiveLayout responsive) {
    return AppBar(
      title: Text(
        'إدارة الطلبات',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: responsive.getTitleFontSize() + 2,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () => controller.fetchOrders(),
          icon: const Icon(Icons.refresh),
          tooltip: 'تحديث',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget buildSearchBar(BuildContext context, OrdersController controller, ResponsiveLayout responsive) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: responsive.defaultPadding,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
        ),
        child: TextField(
          onChanged: controller.setSearchQuery,
          decoration: InputDecoration(
            hintText: 'البحث عن طلب برقم التعريف أو المبلغ...',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: Obx(() => controller.searchQuery.isNotEmpty 
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    controller.setSearchQuery('');
                  },
                ) 
              : const SizedBox.shrink()),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget buildStatusTabs(BuildContext context, OrdersController controller, ResponsiveLayout responsive) {
    final statuses = [
      null, // All
      OrderStatus.pending,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered,
      OrderStatus.cancelled,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: responsive.defaultPadding.left),
      child: Obx(() => Row(
        children: statuses.map((status) {
          final isSelected = controller.selectedStatus.value == status;
          final label = status == null ? 'الكل' : controller.getStatusText(status);
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) controller.setFilterStatus(status);
              },
              backgroundColor: Colors.transparent,
              selectedColor: AppColors.primary.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
                ),
              ),
            ),
          );
        }).toList(),
      )),
    );
  }

  Widget buildEmptyState(OrdersController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            controller.searchQuery.isEmpty && controller.selectedStatus.value == null
                ? 'لا توجد طلبات حالياً'
                : 'لا توجد نتائج تطابق بحثك',
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          if (controller.searchQuery.isNotEmpty || controller.selectedStatus.value != null)
            TextButton(
              onPressed: () {
                controller.setSearchQuery('');
                controller.setFilterStatus(null);
              },
              child: const Text('مسح الفلاتر'),
            ),
        ],
      ),
    );
  }

