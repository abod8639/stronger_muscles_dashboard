import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';

/// شبكة بطاقات إحصائية متجاوبة:
/// - الهاتف: شريط أفقي قابل للتمرير يوفر المساحة ويمنع التكدس
/// - الجهاز اللوحي والحاسوب: شبكة أعمدة متناسقة
class ResponsiveStatsGrid extends StatelessWidget {
  final List<Widget> cards;
  final double mobileHeight;
  final double mainAxisExtent;
  final EdgeInsetsGeometry? padding;

  const ResponsiveStatsGrid({
    super.key,
    required this.cards,
    this.mobileHeight = 108,
    this.mainAxisExtent = 125,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final res = context.responsive;

    if (res.isMobile) {
      final cardWidth = math.max(160.0, (res.screenWidth - 32 - 12) / 2.2);
      return SizedBox(
        height: mobileHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          padding: padding,
          itemCount: cards.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            return SizedBox(width: cardWidth, child: cards[index]);
          },
        ),
      );
    }

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: res.isDesktop ? cards.length.clamp(1, 4) : 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        mainAxisExtent: mainAxisExtent,
      ),
      children: cards,
    );
  }
}
