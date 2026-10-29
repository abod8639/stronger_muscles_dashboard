import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_providers.dart';
import 'widgets/order_actions_bar.dart';
import 'widgets/order_customer_section.dart';
import 'widgets/order_hero_header.dart';
import 'widgets/order_notes_section.dart';
import 'widgets/order_products_section.dart';
import 'widgets/order_shipping_section.dart';
import 'widgets/order_summary_section.dart';

/// شاشة عرض تفاصيل الطلب
class OrderDetailsScreen extends ConsumerWidget {
  final OrderEntity order;

  const OrderDetailsScreen({super.key, required this.order});

  /// العرض الذي يبدأ عنده تخطيط العمودين (رئيسي + جانبي)
  static const double _wideBreakpoint = 960;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(orderDetailsControllerProvider(order));

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final currentOrder = controller.order;
        final responsive = context.responsive;
        final isWide = responsive.screenWidth >= _wideBreakpoint;
        final gap = responsive.isMobile
            ? AppDesignTokens.space12
            : AppDesignTokens.space16;

        // كل قسم يُبنى مرة واحدة ثم يُرتَّب حسب التخطيط
        final summary = OrderSummarySection(order: currentOrder);
        final products = OrderProductsSection(items: currentOrder.items);
        final notes = (currentOrder.notes?.isNotEmpty ?? false)
            ? OrderNotesSection(notes: currentOrder.notes!)
            : null;
        final customer = OrderCustomerSection(
          order: currentOrder,
          controller: controller,
        );
        final shipping = OrderShippingSection(
          order: currentOrder,
          controller: controller,
        );

        Widget column(List<Widget?> sections) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final section in sections.nonNulls) ...[
              section,
              SizedBox(height: gap),
            ],
          ],
        );

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: BaseAppBar(title: 'تفاصيل الطلب #${currentOrder.id}'),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide
                  ? AppDesignTokens.space32
                  : responsive.defaultPadding.left,
              vertical: gap,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OrderHeroHeader(
                      order: currentOrder,
                      controller: controller,
                    ),
                    SizedBox(height: gap),
                    OrderActionsBar(controller: controller),
                    SizedBox(height: gap),
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: column([products, notes, shipping]),
                          ),
                          SizedBox(width: gap),
                          Expanded(flex: 2, child: column([summary, customer])),
                        ],
                      )
                    else
                      column([summary, products, notes, customer, shipping]),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
