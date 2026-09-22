import 'package:flutter/material.dart';

Widget buildSummaryRow(
  String label,
  String value, {
  bool isTotal = false,
  Color? color,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      if (isTotal) {
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color ?? colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color ?? colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    },
  );
}
