import 'package:flutter/material.dart';

/// عنصر الشريحة (M3 FilterChip) المتوافق مع معايير Material Design 3
class ChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const ChipItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsetsDirectional.only(start: index < 1 ? 0 : 8),
      child: Center(
        child: FilterChip(
          selected: isSelected,
          onSelected: (_) => onTap(),
          label: Text(label),
          labelStyle: theme.textTheme.labelLarge?.copyWith(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
          backgroundColor: colorScheme.surfaceContainerLow,
          selectedColor: colorScheme.primary,
          showCheckmark: false,
          side: BorderSide(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
      ),
    );
  }
}
