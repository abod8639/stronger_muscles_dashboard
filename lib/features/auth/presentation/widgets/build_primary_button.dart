import 'package:flutter/material.dart';
import 'auth_primary_button.dart';

@Deprecated('Use AuthPrimaryButton widget directly for better performance and const support')
Widget buildPrimaryButton({
  required String label,
  required bool isLoading,
  required VoidCallback onPressed,
}) {
  return AuthPrimaryButton(
    label: label,
    isLoading: isLoading,
    onPressed: onPressed,
  );
}
