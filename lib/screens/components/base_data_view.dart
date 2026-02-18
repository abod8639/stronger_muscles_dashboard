import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme.dart';
import '../../../config/responsive.dart';

class BaseDataView<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final VoidCallback? onSeeAll;

  final int? crossAxisCount;
  final double? mainAxisExtent;
  final double? childAspectRatio;
  final bool useListView;

  const BaseDataView({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.onSeeAll,
    this.crossAxisCount,
    this.mainAxisExtent,
    this.childAspectRatio,
    this.useListView = false,
  });

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveLayout(context);
    final spacing = res.itemSpacing;

    // تحديد عدد الأعمدة تلقائياً إذا لم يتم تمرير قيمة
    final int effectiveCrossAxisCount =
        crossAxisCount ?? (res.isMobile ? 1 : res.getGridColumns());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // قسم العنوان (Header) موحد لكل الويدجت
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: res.defaultPadding.left,
            vertical: res.defaultPadding.top / 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: res.getTitleFontSize(),
                ),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
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

        // قسم المحتوى: إما قائمة أو شبكة
        useListView
            ? _buildListView(res)
            : _buildGridView(res, effectiveCrossAxisCount, spacing),
      ],
    );
  }

  Widget _buildListView(ResponsiveLayout res) {
    return Obx(()=>
       ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        padding: EdgeInsets.symmetric(horizontal: res.defaultPadding.left),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: itemBuilder(context, items[index], index),
        ),
      ),
    );
  }

  Widget _buildGridView(ResponsiveLayout res, int columns, double spacing) {
    return Obx(()=> GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: res.defaultPadding.left,
          vertical: spacing / 2,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          mainAxisExtent: mainAxisExtent,
          childAspectRatio: childAspectRatio ?? res.getCardAspectRatio(),
        ),
        itemCount: items.length,
        itemBuilder: (context, index) =>
            itemBuilder(context, items[index], index),
      ),
    );
  }
}
