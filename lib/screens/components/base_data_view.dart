import 'dart:math'; // لاستخدام دالة min
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme.dart';
import '../../../config/responsive.dart';

class BaseDataView<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final VoidCallback? onSeeAll;
  final int? showCount; 

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
    this.showCount,
  });

  int get _displayCount => showCount != null ? min(showCount!, items.length) : items.length;

  List<T> get _displayItems => items.take(_displayCount).toList();

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveLayout(context);
    
    final int effectiveCrossAxisCount =
        crossAxisCount ?? (res.isMobile ? 1 : res.getGridColumns());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, res),
        useListView
            ? _buildListView(res)
            : _buildGridView(res, effectiveCrossAxisCount, res.itemSpacing),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ResponsiveLayout res) {
    return Padding(
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
          if (onSeeAll != null && (showCount == null || items.length > showCount!))
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
    );
  }

  Widget _buildListView(ResponsiveLayout res) {
    final displayList = _displayItems;
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayList.length,
        padding: EdgeInsets.symmetric(horizontal: res.defaultPadding.left),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: itemBuilder(context, displayList[index], index),
        ),
      ),
    );
  }

  Widget _buildGridView(ResponsiveLayout res, int columns, double spacing) {
    final displayList = _displayItems;
    return Obx(
      () => GridView.builder(
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
        itemCount: displayList.length,
        itemBuilder: (context, index) =>
            itemBuilder(context, displayList[index], index),
      ),
    );
  }
}