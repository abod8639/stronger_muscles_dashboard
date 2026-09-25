import 'package:flutter/material.dart';

/// حقل إدخال استمارة المنتج بتصميم ناعم ومتناسق مع نمط Soft UI
class ModernFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData icon;
  final bool isNumber;
  final bool isRequired;
  final int maxLines;
  final String? suffixText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;

  const ModernFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    required this.icon,
    this.isNumber = false,
    this.isRequired = false,
    this.maxLines = 1,
    this.suffixText,
    this.onChanged,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
      maxLines: maxLines,
      validator: isRequired
          ? (val) {
              if (val == null || val.trim().isEmpty) {
                return 'هذا الحقل مطلوب';
              }
              return null;
            }
          : null,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        suffixText: suffixText,
        filled: true,
        fillColor: isDark
            ? colorScheme.surfaceContainerLowest.withValues(alpha: 0.5)
            : colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
