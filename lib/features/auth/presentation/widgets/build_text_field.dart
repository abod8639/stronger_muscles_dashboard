import 'package:flutter/material.dart';
import 'auth_text_field.dart';

@Deprecated(
  'Use AuthTextField widget directly for better performance and const support',
)
Widget buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType? keyboardType,
  bool isPassword = false,
  bool isPasswordVisible = false,
  VoidCallback? onTogglePassword,
  ValueChanged<String>? onChanged,
  String? errorText,
}) {
  return AuthTextField(
    controller: controller,
    label: label,
    icon: icon,
    keyboardType: keyboardType,
    isPassword: isPassword,
    isPasswordVisible: isPasswordVisible,
    onTogglePassword: onTogglePassword,
    onChanged: onChanged,
    errorText: errorText,
  );
}
