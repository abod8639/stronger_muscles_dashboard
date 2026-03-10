import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/page/widget/build_indicator_card.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/page/widget/build_section_title.dart';

Widget buildMainIndicatorsSection(ResponsiveLayout res) {
  final bool isSmallScreen = res.isMobile;

  final int crossAxisCount = isSmallScreen
      ? 1
      : (res.screenWidth < 1200 ? 2 : 3);

  final double childAspectRatio = isSmallScreen
      ? 1.5
      : (res.screenWidth < 1400 ? 1.1 : 1.5);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildSectionTitle('المؤشرات الرئيسية', res),

      SizedBox(height: res.itemSpacing),

      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: res.itemSpacing * 1.5,
          mainAxisSpacing: res.itemSpacing * 1.5,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeOut,
            child: buildIndicatorCard(index),
          );
        },
      ),
    ],
  );
}
