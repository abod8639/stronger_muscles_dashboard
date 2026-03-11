import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/status_badge.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/order_details_screen/order_details_screen.dart';

import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/build_recent_orders.dart';

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

          responsive.isDesktop
              ? _buildTableContent(controller, responsive)
              : buildRecentOrders(responsive,controller.paginatedOrders),

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.015),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (!responsive.isMobile) ...[
                const Text(
                  "Orders Management",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                if (responsive.isDesktop) const Spacer(),
              ],

              Expanded(
                child: CustomSearchBar(
                  onSearch: controller.onSearchChanged,
                  hintText: "    Search orders...",
                ),
              ),
            ],
          ),

          SizedBox(
            height: 42,
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
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.05),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.4),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: 0.3,
          ),
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
            color: Colors.white.withValues(alpha: 0.02),
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
            return _buildOrderRow( orders[index], isLast: index == orders.length - 1);
          }),

          if (orders.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'No orders found',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
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
          color: Colors.white.withValues(alpha: 0.3),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildOrderRow(OrderEntity order, {bool isLast = false}) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Builder(
      builder: (context) {
        bool isMobile = MediaQuery.of(context).size.width < 600;
        return InkWell(
          onTap: () => Get.to(() => OrderDetailsScreen(order: order)),
          hoverColor: Colors.white.withValues(alpha: 0.02),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
            ),
            // التبديل بين Column للهاتف و Row للكمبيوتر
            child: isMobile
                ? _buildMobileLayout(order, dateFormat)
                : _buildDesktopLayout(order, dateFormat),
          ),
        );
      },
    );
  }

  // --- تصميم شاشات الكمبيوتر (الجدول الأصلي المحسن) ---
  Widget _buildDesktopLayout(OrderEntity order, DateFormat dateFormat) {
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

  Widget _buildMobileLayout(OrderEntity order, DateFormat dateFormat) {
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
        Divider(color: Colors.white.withValues(alpha: 0.05), thickness: 1),
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

  Widget _buildOrderId(OrderEntity order) {
    return Text(
      '#ORD-${order.id.toString().padLeft(4, '0')}',
      style: const TextStyle(
        color: AppColors.accent,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }

  Widget _buildCustomerInfo(OrderEntity order) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAvatar(order),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                order.userEmail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDate(OrderEntity order, DateFormat dateFormat) {
    return Text(
      dateFormat.format(order.orderDate),
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.5),
        fontSize: 12,
      ),
    );
  }

  Widget _buildPrice(OrderEntity order) {
    return Text(
      '${order.totalAmount.toStringAsFixed(2)} L.E ',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildActionBtn(OrderEntity order) {
    return const Align(
      alignment: Alignment.centerRight,
      child: Icon(Icons.chevron_right_rounded, size: 20, color: Colors.white24),
    );
  }

  Widget _buildAvatar(OrderEntity order) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.4),
            AppColors.primary.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
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

        // النص الإحصائي
        Widget statsText = Text(
          'Showing $start to $end of ${controller.filteredOrders.length} entries',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 12,
          ),
        );

        // أزرار التنقل
        Widget paginationControls = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNavButton(
              icon: Icons.chevron_left_rounded,
              onPressed: controller.currentPage.value > 1
                  ? controller.previousPage
                  : null,
            ),
            const SizedBox(width: 12),
            ..._buildPageNumbers(controller),
            const SizedBox(width: 12),
            _buildNavButton(
              icon: Icons.chevron_right_rounded,
              onPressed: controller.currentPage.value < controller.totalPages
                  ? controller.nextPage
                  : null,
            ),
          ],
        );

        // التبديل بين التصميم الأفقي والعمودي
        return responsive.isMobile
            ? Column(
                children: [
                  statsText,
                  const SizedBox(height: 16),
                  paginationControls,
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [statsText, paginationControls],
              );
      }),
    );
  }

  List<Widget> _buildPageNumbers(OrdersController controller) {
    List<Widget> pages = [];
    for (int i = 1; i <= controller.totalPages; i++) {
      if (controller.totalPages > 5) {
        if (i != 1 &&
            i != controller.totalPages &&
            (i < controller.currentPage.value - 1 ||
                i > controller.currentPage.value + 1)) {
          if (i == 2 || i == controller.totalPages - 1) {
            pages.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '...',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                ),
              ),
            );
          }
          continue;
        }
      }
      pages.add(_buildPageButton(i, controller));
    }
    return pages;
  }

  Widget _buildPageButton(int pageNum, OrdersController controller) {
    final isSelected = controller.currentPage.value == pageNum;
    return GestureDetector(
      onTap: () => controller.goToPage(pageNum),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          '$pageNum',
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({required IconData icon, VoidCallback? onPressed}) {
    bool isDisabled = onPressed == null;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(isDisabled ? 0.02 : 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(isDisabled ? 0.02 : 0.1),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDisabled
              ? Colors.white10
              : Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
