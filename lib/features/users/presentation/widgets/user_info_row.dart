import 'package:flutter/material.dart';
import '../../../../config/theme.dart';

class UserInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const UserInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
