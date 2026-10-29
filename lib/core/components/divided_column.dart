import 'package:flutter/material.dart';

/// عمود يضع فاصلاً خفيفاً موحداً بين عناصره (صفوف التفاصيل، القوائم داخل البطاقات)
class DividedColumn extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;

  const DividedColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.35),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) divider,
          children[i],
        ],
      ],
    );
  }
}
