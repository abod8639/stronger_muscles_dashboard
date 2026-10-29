import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/section_card.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

/// بطاقة ملاحظات العميل على الطلب
class OrderNotesSection extends StatelessWidget {
  final String notes;

  const OrderNotesSection({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SectionCard(
      title: 'ملاحظات العميل',
      icon: Icons.note_alt_outlined,
      child: SoftSurface(
        compact: true,
        borderRadius: AppDesignTokens.radiusMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.space16,
          vertical: AppDesignTokens.space14,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote_rounded,
              size: 20,
              color: colorScheme.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(width: AppDesignTokens.space10),
            Expanded(
              child: SelectableText(
                notes,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
