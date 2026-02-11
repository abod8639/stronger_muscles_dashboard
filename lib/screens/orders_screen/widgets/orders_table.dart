import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/models/order_model.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/screens/components/status_badge.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/screens/order_details_screen/order_details_screen.dart';

class OrdersTable extends StatelessWidget {
  const OrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();
    final responsive = context.responsive;

    return GlassContainer(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          _buildTableHeader(controller, responsive),
          _buildTableContent(controller, responsive),
          _buildTableFooter(controller, responsive),
        ],
      ),
    );
  }

  Widget _buildTableHeader(OrdersController controller, ResponsiveLayout responsive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          // Filter Tabs
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Row(
                children: [
                  _buildTab(controller, 'all', 'All'),
                  _buildTab(controller, 'pending', 'Pending'),
                  _buildTab(controller, 'processing', 'Processing'),
                  _buildTab(controller, 'shipped', 'Shipped'),
                  _buildTab(controller, 'delivered', 'Delivered'),
                  _buildTab(controller, 'cancelled', 'Cancelled'),
                ],
              )),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Search Input
          Container(
            width: 250,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TextField(
              onChanged: (v) => controller.onSearchChanged(v),
              style: const TextStyle(fontSize: 13, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search order ID, customer...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
                prefixIcon: Icon(Icons.search, size: 18, color: Colors.white.withOpacity(0.3)),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(OrdersController controller, String id, String label) {
    final isSelected = controller.selectedStatusId.value == id;
    return GestureDetector(
      onTap: () => controller.onStatusChanged(id),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTableContent(OrdersController controller, ResponsiveLayout responsive) {
    return Obx(() {
      final orders = controller.paginatedOrders;
      
      Widget content = Column(
        children: [
          // Column Headers
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            color: Colors.white.withOpacity(0.02),
            child: Row(
              children: [
                _buildColumnHeader('ORDER ID', flex: 2),
                _buildColumnHeader('CUSTOMER', flex: 3),
                _buildColumnHeader('DATE', flex: 2),
                _buildColumnHeader('TOTAL AMOUNT', flex: 2),
                _buildColumnHeader('STATUS', flex: 2),
                _buildColumnHeader('ACTION', flex: 1, textAlign: TextAlign.center),
              ],
            ),
          ),
          
          // Rows
          ...List.generate(orders.length, (index) {
            return _buildOrderRow(orders[index], isLast: index == orders.length - 1);
          }),
          
          if (orders.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'No orders found',
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
            ),
        ],
      );

      if (responsive.isMobile || responsive.isTablet) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 800, // Minimum width for the table to remain readable
            child: content,
          ),
        );
      }
      
      return content;
    });
  }

  Widget _buildColumnHeader(String label, {int flex = 1, TextAlign textAlign = TextAlign.start}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: textAlign,
        style: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildOrderRow(OrderModel order, {bool isLast = false}) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    return GestureDetector(
      onTap: () => 
      Get.to(() =>  OrderDetailsScreen(order: order ) ) ,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        decoration: BoxDecoration(
          border: isLast ? null : Border(
            bottom: BorderSide(color: Colors.white.withOpacity(0.03)),
          ),
        ),
        child: Row(
          children: [
            // ORDER ID
            Expanded(
              flex: 2,
              child: Text(
                '#ORD-${order.id.toString().padLeft(4, '0')}',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            
            // CUSTOMER
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: order.userPhoto != null 
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(order.userPhoto!, fit: BoxFit.cover),
                        )
                      : Text(
                          order.userName.isNotEmpty ? order.userName[0].toUpperCase() : 'U',
                          style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.userName,
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          order.userEmail,
                          style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // DATE
            Expanded(
              flex: 2,
              child: Text(
                dateFormat.format(order.orderDate),
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
              ),
            ),
            
            // TOTAL AMOUNT
            Expanded(
              flex: 2,
              child: Text(
                '${order.totalAmount.toStringAsFixed(2)} SAR',
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            
            // STATUS
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: OrderStatusBadge(status: order.status),
              ),
            ),
            
            // ACTION
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.more_vert, size: 18, color: Colors.white.withOpacity(0.4)),
                onPressed: () {
                  Get.to(() => OrderDetailsScreen(order: order));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableFooter(OrdersController controller, ResponsiveLayout responsive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Obx(() {
        final start = (controller.currentPage.value - 1) * controller.itemsPerPage.value + 1;
        final end = (start + controller.paginatedOrders.length - 1).clamp(0, controller.filteredOrders.length);
        
        return Row(
          children: [
            Text(
              'Showing $start-$end of ${controller.filteredOrders.length} orders',
              style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12),
            ),
            const Spacer(),
            
            // Pagination buttons
            _buildPaginationButton(
              icon: Icons.chevron_left,
              onPressed: controller.currentPage.value > 1 ? controller.previousPage : null,
            ),
            
            const SizedBox(width: 8),
            
            ...List.generate(controller.totalPages, (index) {
              final pageNum = index + 1;
              final isSelected = controller.currentPage.value == pageNum;
              
              // Only show a limited number of page buttons
              if (controller.totalPages > 5) {
                if (pageNum != 1 && 
                    pageNum != controller.totalPages && 
                    (pageNum < controller.currentPage.value - 1 || 
                     pageNum > controller.currentPage.value + 1)) {
                  if (pageNum == 2 || pageNum == controller.totalPages - 1) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('...', style: TextStyle(color: Colors.white24)),
                    );
                  }
                  return const SizedBox.shrink();
                }
              }

              return GestureDetector(
                onTap: () => controller.goToPage(pageNum),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$pageNum',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
            
            const SizedBox(width: 8),
            
            _buildPaginationButton(
              icon: Icons.chevron_right,
              onPressed: controller.currentPage.value < controller.totalPages ? controller.nextPage : null,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPaginationButton({required IconData icon, VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: onPressed != null ? Colors.white.withOpacity(0.8) : Colors.white10),
      visualDensity: VisualDensity.compact,
    );
  }
}

