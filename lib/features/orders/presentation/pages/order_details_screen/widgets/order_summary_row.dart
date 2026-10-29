import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

/// صف في ملخص المبالغ؛ صف الإجمالي يظهر داخل سطح بارز
class OrderSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? color;

  const OrderSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color ?? colorScheme.primary,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color ?? colorScheme.onSurface,
                ),
        ),
      ],
    );

    if (!isTotal) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDesignTokens.space6,
          horizontal: AppDesignTokens.space4,
        ),
        child: row,
      );
    }

    return SoftSurface(
      compact: true,
      margin: const EdgeInsets.only(top: AppDesignTokens.space12),
      borderRadius: AppDesignTokens.radiusMedium,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.space16,
        vertical: AppDesignTokens.space14,
      ),
      child: row,
    );
  }
}
