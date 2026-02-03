import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/order_details_screen.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/order_list_tile.dart';
import '../../config/theme.dart';
import '../../config/responsive.dart';
import '../../models/index.dart';

class RecentOrdersList extends StatelessWidget {
  final List<OrderModel> orders;
  final VoidCallback? onSeeAll;

  const RecentOrdersList({super.key, required this.orders, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveLayout(context);
    final bool isSmallScreen = res.isMobile;

    final int crossAxisCount = isSmallScreen ? 1 : 2;

    // final double childAspectRatio = isSmallScreen
    //     ? 1.5
    //     : (res.screenWidth < 1400 ? 1.6 : 1.8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: res.defaultPadding.left,
            vertical: res.defaultPadding.top / 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الطلبات الأخيرة',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: res.getTitleFontSize(),
                ),
              ),
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  child: Text(
                    'عرض الكل',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: res.getBodyFontSize() - 1,
                    ),
                  ),
                ),
            ],
          ),
        ),

        isSmallScreen
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      res.defaultPadding.left,
                      0,
                      res.defaultPadding.left,
                      12,
                    ),
                    child: OrderListTile(
                      order: orders[index],
                      index: index,
                      onTap: () => Get.to(
                        () => OrderDetailsScreen(order: orders[index]),
                      ),
                    ),
                  );
                },
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: res.defaultPadding.left,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: res.itemSpacing,
                  mainAxisSpacing: res.itemSpacing,
                  mainAxisExtent: 190,
                ),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return OrderListTile(
                    order: orders[index],
                    index: index,
                    onTap: () =>
                        Get.to(() => OrderDetailsScreen(order: orders[index])),
                  );
                },
              ),
      ],
    );
  }
}
