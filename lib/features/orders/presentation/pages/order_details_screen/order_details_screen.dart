import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/order_details_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_controller.dart';
import 'widgets/order_actions_bar.dart';
import 'widgets/order_customer_section.dart';
import 'widgets/order_hero_header.dart';
import 'widgets/order_notes_section.dart';
import 'widgets/order_products_section.dart';
import 'widgets/order_shipping_section.dart';
import 'widgets/order_summary_section.dart';

/// شاشة عرض تفاصيل الطلب المتوافقة مع معايير Clean Architecture و Material Design 3
class OrderDetailsScreen extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      OrderDetailsController(
        initialOrder: order,
        updateOrderStatusUseCase: Get.find<UpdateOrderStatusUseCase>(),
        ordersController: Get.isRegistered<OrdersController>()
            ? Get.find<OrdersController>()
            : null,
      ),
      tag: order.id,
    );

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth >= 960;
    final isMobile = context.isMobile;

    return Obx(() {
      final currentOrder = controller.order.value;

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: BaseAppBar(
          title: 'تفاصيل الطلب #${currentOrder.id}',
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 28.0 : (isMobile ? 12.0 : 18.0),
            vertical: isMobile ? 12.0 : 18.0,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. ترويسة الطلب والإحصائيات السريعة
                  OrderHeroHeader(
                    order: currentOrder,
                    controller: controller,
                  ),
                  const SizedBox(height: 12),

                  // 2. شريط إجراءات الطلب السريعة (طباعة، مشاركة، تأكيد، إلغاء)
                  OrderActionsBar(controller: controller),
                  const SizedBox(height: 16),

                  // 3. الشبكة الرئيسية المتجاوبة
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // العمود الرئيسي: قائمة المنتجات والملاحظات
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              OrderProductsSection(items: currentOrder.items),
                              if (currentOrder.notes != null &&
                                  currentOrder.notes!.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                OrderNotesSection(notes: currentOrder.notes!),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // العمود الجانبي: الملخص المالي، بيانات العميل، وعنوان الشحن
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              OrderSummarySection(order: currentOrder),
                              const SizedBox(height: 16),
                              OrderCustomerSection(
                                order: currentOrder,
                                controller: controller,
                              ),
                              const SizedBox(height: 16),
                              OrderShippingSection(
                                order: currentOrder,
                                controller: controller,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    MobileView(currentOrder: currentOrder, controller: controller),

                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class MobileView extends StatelessWidget {
  const MobileView({
    super.key,
    required this.currentOrder,
    required this.controller,
  });

  final OrderEntity currentOrder;
  final OrderDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrderSummarySection(order: currentOrder),
        const SizedBox(height: 16),
        OrderProductsSection(items: currentOrder.items),
        const SizedBox(height: 16),
        OrderCustomerSection(
          order: currentOrder,
          controller: controller,
        ),
        const SizedBox(height: 16),
        OrderShippingSection(
          order: currentOrder,
          controller: controller,
        ),
        if (currentOrder.notes != null &&
            currentOrder.notes!.isNotEmpty) ...[
          const SizedBox(height: 16),
          OrderNotesSection(notes: currentOrder.notes!),
        ],
        const SizedBox(height: 50),
      ],
    );
  }
}
