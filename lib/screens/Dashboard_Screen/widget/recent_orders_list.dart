import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/order_list_tile.dart';
import '../../../config/theme.dart';
import '../../../config/responsive.dart';
import '../../../models/index.dart';

class RecentOrdersList extends StatelessWidget {
  final List<OrderModel> orders;
  final VoidCallback? onSeeAll;

  const RecentOrdersList({super.key, required this.orders, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;
    final spacing = responsive.itemSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: padding.left,
            vertical: padding.top / 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الطلبات الأخيرة',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.getTitleFontSize(),
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
                      fontSize: responsive.getBodyFontSize() - 1,
                    ),
                  ),
                ),
            ],
          ),
        ),
        responsive.isMobile
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding.left,
                      vertical: spacing / 2,
                    ),
                    child: OrderListTile(order: order, index: index,),
                  );
                },
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: padding.left),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: 2.5,
                ),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderListTile(order: order ,index: index, );
                },
              ),
      ],
    );
  }
}
