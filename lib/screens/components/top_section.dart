import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';

class TopSection extends StatelessWidget {
  final List<Widget> children;
  const TopSection({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsExtended.darkBg.withAlpha(200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GlassContainer(
        padding: EdgeInsets.only(bottom: 12),
        child: Column(children: children),
      ),
    );
  }
}
