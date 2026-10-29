import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

/// صف حقول متجاوب: الحقول متجاورة بعرض متساوٍ على الشاشات الواسعة،
/// ومرصوصة عمودياً على الهاتف حتى لا تضيق الحقول
class ResponsiveFieldsRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const ResponsiveFieldsRow({
    super.key,
    required this.children,
    this.spacing = AppDesignTokens.space14,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: spacing),
            children[i],
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}
