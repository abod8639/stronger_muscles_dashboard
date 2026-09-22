import 'package:flutter/material.dart';

Widget buildDetailRow(
  IconData icon,
  String label,
  String value, {
  Widget? trailing,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              flex: 4,
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              flex: 5,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: trailing ??
                    SelectionArea(
                      child: Text(
                        value,
                        textAlign: TextAlign.end,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
