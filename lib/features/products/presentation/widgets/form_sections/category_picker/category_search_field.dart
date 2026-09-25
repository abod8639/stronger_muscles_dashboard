import 'package:flutter/material.dart';

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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark
            ? Color.lerp(colorScheme.surfaceContainerLowest, Colors.black, 0.20)!
            : Color.lerp(colorScheme.surfaceContainerHighest, Colors.white, 0.40)!,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.22),
            offset: const Offset(1.5, 1.5),
            blurRadius: 2.5,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.015)
                : Colors.white.withValues(alpha: 0.85),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 2.5,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.white.withValues(alpha: 0.85),
          width: 1.0,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 13,
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
