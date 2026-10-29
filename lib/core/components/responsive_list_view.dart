import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';

/// قائمة كسولة (Lazy) متجاوبة للقوائم الطويلة:
/// عمود واحد على الهاتف والجهاز اللوحي، وشبكة من [desktopColumns] أعمدة على الحاسوب.
/// على عكس [BaseDataView] لا تستخدم shrinkWrap، فلا تبني إلا العناصر الظاهرة.
class ResponsiveListView extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// ارتفاع العنصر في وضع الشبكة (مطلوب لأن عناصر الشبكة ثابتة الارتفاع)
  final double gridItemExtent;
  final int desktopColumns;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  const ResponsiveListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.gridItemExtent,
    this.desktopColumns = 2,
    this.padding,
    this.physics = const AlwaysScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    final res = context.responsive;
    final spacing = res.itemSpacing;
    final effectivePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: res.defaultPadding.left,
          vertical: spacing,
        );

    if (!res.isDesktop || desktopColumns <= 1) {
      return ListView.separated(
        physics: physics,
        padding: effectivePadding,
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(height: spacing),
        itemBuilder: itemBuilder,
      );
    }

    return GridView.builder(
      physics: physics,
      padding: effectivePadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: desktopColumns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        mainAxisExtent: gridItemExtent,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
