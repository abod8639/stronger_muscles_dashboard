import 'package:flutter/material.dart';

enum TextFieldStyle { solid, glass }

/// حقل إدخال عصري متوافق مع معايير Material Design 3
class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool enabled;
  final bool isNumber;
  final int maxLines;
  final TextFieldStyle style;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const ModernTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.enabled = true,
    this.isNumber = false,
    this.maxLines = 1,
    this.style = TextFieldStyle.solid,
    this.onChanged,
    this.focusNode,
    this.onSubmitted,
    this.hint,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      enabled: enabled,
      focusNode: focusNode,
      onFieldSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType ??
          (isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : (maxLines > 1 ? TextInputType.multiline : TextInputType.text)),
      maxLines: maxLines,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      cursorColor: colorScheme.primary,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
        prefixIcon: Icon(
          icon,
          size: 20,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// دالة مساعدة متوافقة عكسياً
Widget buildModernTextField(
  TextEditingController controller,
  String label,
  IconData icon, {
  bool enabled = true,
  bool isNumber = false,
  int maxLines = 1,
  TextFieldStyle style = TextFieldStyle.solid,
  Function(String)? onChanged,
  FocusNode? focusNode,
  VoidCallback? onSubmitted,
  String? hint,
}) {
  return ModernTextField(
    controller: controller,
    label: label,
    icon: icon,
    enabled: enabled,
    isNumber: isNumber,
    maxLines: maxLines,
    style: style,
    onChanged: onChanged,
    focusNode: focusNode,
    onSubmitted: onSubmitted,
    hint: hint,
  );
}
