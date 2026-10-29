import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/icon_card_with_shadow.dart';
import 'package:stronger_muscles_dashboard/core/components/section_header.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

/// مكون عرض البيانات العام بأسلوب Neumorphism / Soft UI
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

  /// الحشوة الأفقية؛ مرّر 0 عندما تكون الصفحة المضيفة محشوة مسبقاً
  final double? horizontalPadding;

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
    this.horizontalPadding,
    this.showCount,
  });

  double _hPadding(ResponsiveLayout res) =>
      horizontalPadding ?? res.defaultPadding.left;

  int get _displayCount =>
      showCount != null ? min(showCount!, items.length) : items.length;

  List<T> get _displayItems => items.take(_displayCount).toList();

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveLayout(context);

    final int effectiveCrossAxisCount =
        crossAxisCount ?? (res.isMobile ? 1 : res.getGridColumns());

    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: _hPadding(res)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, res),
            _NeumorphicEmptyView(title: title),
          ],
        ),
      );
    }

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
    return SectionHeader(
      title: title,
      count: items.length,
      onSeeAll:
          onSeeAll != null && (showCount == null || items.length > showCount!)
          ? onSeeAll
          : null,
      padding: EdgeInsets.symmetric(
        horizontal: _hPadding(res),
        vertical: res.defaultPadding.top / 2,
      ),
    );
  }

  Widget _buildListView(ResponsiveLayout res) {
    final displayList = _displayItems;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayList.length,
      padding: EdgeInsets.symmetric(horizontal: _hPadding(res)),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: itemBuilder(context, displayList[index], index),
      ),
    );
  }

  Widget _buildGridView(ResponsiveLayout res, int columns, double spacing) {
    final displayList = _displayItems;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: _hPadding(res),
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
    );
  }
}

/// واجهة الحالة الفارغة بأسلوب Soft UI
class _NeumorphicEmptyView extends StatelessWidget {
  final String title;

  const _NeumorphicEmptyView({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SoftSurface(
      margin: const EdgeInsets.symmetric(vertical: AppDesignTokens.space8),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.space24,
        vertical: 36,
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconCardWithShadow(
            icon: Icons.inbox_rounded,
            size: 28,
            padding: const EdgeInsets.all(14),
            borderRadius: 18,
            iconColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(height: AppDesignTokens.space14),
          Text(
            'لا توجد $title متاحة حالياً',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
