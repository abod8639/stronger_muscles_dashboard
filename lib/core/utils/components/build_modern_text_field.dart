import 'package:flutter/material.dart';

enum TextFieldStyle { solid, glass }

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
  return TextField(
    controller: controller,
    enabled: enabled,
    focusNode: focusNode,
    onSubmitted: onSubmitted != null ? (_) => onSubmitted() : null,
    onChanged: onChanged,
    keyboardType: isNumber
        ? const TextInputType.numberWithOptions(decimal: true)
        : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
    ),
  );
}
