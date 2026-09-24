import 'package:flutter/material.dart';
import 'order_card_section.dart';

/// بطاقة ملاحظات العميل على الطلب
class OrderNotesSection extends StatelessWidget {
  final String notes;

  const OrderNotesSection({
    super.key,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return OrderCardSection(
      title: 'ملاحظات العميل',
      icon: Icons.note_alt_outlined,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          notes,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
