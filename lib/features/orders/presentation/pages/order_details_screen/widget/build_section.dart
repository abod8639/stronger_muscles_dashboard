import 'package:flutter/material.dart';

class OrderCardSection extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const OrderCardSection({
    super.key,
    this.title,
    this.icon,
    required this.child,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card.outlined(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: 1.0,
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      title!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ],
          Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

Widget buildSection({required Widget child, EdgeInsets? padding}) {
  return OrderCardSection(
    padding: padding,
    child: child,
  );
}
