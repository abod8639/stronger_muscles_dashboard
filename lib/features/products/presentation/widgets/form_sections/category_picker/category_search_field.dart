import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

/// حقل بحث الأقسام بتصميم غائر Neumorphic Recessed
class CategorySearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool hasQuery;

  const CategorySearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.hasQuery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: AppDesignTokens.softSurface(
        colorScheme,
        isDark: isDark,
        borderRadius: BorderRadius.circular(12),
        depth: SoftDepth.inset,
        compact: true,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(fontSize: 13, color: colorScheme.onSurface),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          hintText: 'ابحث في الأقسام والتصنيفات بالاسم...',
          hintStyle: TextStyle(
            fontSize: 12.5,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 18,
            color: colorScheme.primary,
          ),
          suffixIcon: hasQuery
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 16),
                  onPressed: onClear,
                )
              : null,
        ),
      ),
    );
  }
}
