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

  Widget _buildTableHeader(
    OrdersController controller,
    ResponsiveLayout responsive,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02), // لمسة زجاجية خلفية
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.08), width: 1.5),
        ),
      ),
      child: Row(
        children: [
          // 1. قسم الفلاتر (Filter Tabs)
          Expanded(
            child: SizedBox(
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Obx(
                  () => Row(
                    children: [
                      _buildTab(controller, 'all', 'All Orders'),
                      _buildTab(controller, 'pending', 'Pending'),
                      _buildTab(controller, 'processing', 'Processing'),
                      _buildTab(controller, 'shipped', 'Shipped'),
                      _buildTab(controller, 'delivered', 'Delivered'),
                      _buildTab(controller, 'cancelled', 'Cancelled'),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // 2. حقل البحث المحسن
          _buildSearchBox(controller),
        ],
      ),
    );
  }

  Widget _buildTab(OrdersController controller, String id, String label) {
    final isSelected = controller.selectedStatusId.value == id;
    return GestureDetector(
      onTap: () => controller.onStatusChanged(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withOpacity(0.05),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox(OrdersController controller) {
    return Container(
      width: 280,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: TextField(
        onChanged: (v) => controller.onSearchChanged(v),
        style: const TextStyle(fontSize: 13, color: Colors.white),
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          hintText: 'Search orders...',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.25),
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 18,
            color: Colors.white.withOpacity(0.4),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildTableContent(
    OrdersController controller,
    ResponsiveLayout responsive,
  ) {
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
                _buildColumnHeader('ORDER ID', flex: 3),
                _buildColumnHeader('CUSTOMER', flex: 2),
                _buildColumnHeader('DATE', flex: 2),
                _buildColumnHeader('TOTAL AMOUNT', flex: 2),
                _buildColumnHeader('STATUS', flex: 2),
              ],
            ),
          ),

          // Rows
          ...List.generate(orders.length, (index) {
            return _buildOrderRow(
              
              orders[index],
              isLast: index == orders.length - 1,
            );
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

  Widget _buildColumnHeader(
    String label, {
    int flex = 1,
    TextAlign textAlign = TextAlign.start,
  }) {
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

  Widget _buildOrderRow( OrderModel order, {bool isLast = false}) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Builder(
      builder: (context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
        return InkWell(
          onTap: () => Get.to(() => OrderDetailsScreen(order: order)),
          hoverColor: Colors.white.withOpacity(0.02),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24, 
              vertical: 16
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
              ),
            ),
            // التبديل بين Column للهاتف و Row للكمبيوتر
            child: isMobile 
              ? _buildMobileLayout(order, dateFormat) 
              : _buildDesktopLayout(order, dateFormat),
          ),
        );
      }
    );
  }

  // --- تصميم شاشات الكمبيوتر (الجدول الأصلي المحسن) ---
  Widget _buildDesktopLayout(OrderModel order, DateFormat dateFormat) {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildOrderId(order)),
        Expanded(flex: 2, child: _buildCustomerInfo(order)),
        Expanded(flex: 2, child: _buildDate(order, dateFormat)),
        Expanded(flex: 2, child: _buildPrice(order)),
        Expanded(flex: 1, child: OrderStatusBadge(status: order.status)),
        Expanded(flex: 1, child: _buildActionBtn(order)),
      ],
    );
  }

  Widget _buildMobileLayout(OrderModel order, DateFormat dateFormat) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // توزيع العناصر
          children: [
            _buildCustomerInfo(order), // صورة واسم العميل
            OrderStatusBadge(status: order.status), // الحالة في الزاوية
          ],
        ),
        const SizedBox(height: 12),
        Divider(color: Colors.white.withOpacity(0.05), thickness: 1),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderId(order),
                const SizedBox(height: 4),
                _buildDate(order, dateFormat),
              ],
            ),
            _buildPrice(order), // السعر بخط واضح
          ],
        ),
      ],
    );
  }


  Widget _buildOrderId(OrderModel order) {
    return Text(
      '#ORD-${order.id.toString().padLeft(4, '0')}',
      style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12),
    );
  }

  Widget _buildCustomerInfo(OrderModel order) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAvatar(order),
        const SizedBox(width: 10),
        Flexible( 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order.userName, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              Text(order.userEmail, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDate(OrderModel order, DateFormat dateFormat) {
    return Text(dateFormat.format(order.orderDate),
        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12));
  }

  Widget _buildPrice(OrderModel order) {
    return Text('${order.totalAmount.toStringAsFixed(2)} SAR',
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800));
  }

  Widget _buildActionBtn(OrderModel order) {
    return const Align(
      alignment: Alignment.centerRight,
      child: Icon(Icons.chevron_right_rounded, size: 20, color: Colors.white24),
    );
  }

  Widget _buildAvatar(OrderModel order) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.4),
            AppColors.primary.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Center(
        child: order.userPhoto != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(order.userPhoto!, fit: BoxFit.cover),
              )
            : Text(
                order.userName.isNotEmpty
                    ? order.userName[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildTableFooter(
    OrdersController controller,
    ResponsiveLayout responsive,
  ) {
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
        final start =
            (controller.currentPage.value - 1) * controller.itemsPerPage.value +
            1;
        final end = (start + controller.paginatedOrders.length - 1).clamp(
          0,
          controller.filteredOrders.length,
        );

        return Row(
          children: [
            Text(
              'Showing $start-$end of ${controller.filteredOrders.length} orders',
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 12,
              ),
            ),
            const Spacer(),

            // Pagination buttons
            _buildPaginationButton(
              icon: Icons.chevron_left,
              onPressed: controller.currentPage.value > 1
                  ? controller.previousPage
                  : null,
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
                      child: Text(
                        '...',
                        style: TextStyle(color: Colors.white24),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }
              }

              return GestureDetector(
                onTap: () => controller.goToPage(pageNum),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$pageNum',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(width: 8),

            _buildPaginationButton(
              icon: Icons.chevron_right,
              onPressed: controller.currentPage.value < controller.totalPages
                  ? controller.nextPage
                  : null,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPaginationButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20,
        color: onPressed != null
            ? Colors.white.withOpacity(0.8)
            : Colors.white10,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
