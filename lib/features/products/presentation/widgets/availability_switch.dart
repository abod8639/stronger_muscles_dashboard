import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

class AvailabilitySwitch extends StatelessWidget {
  final bool isAvailable;
  final String title;
  final ValueChanged<bool>? onChanged;

  const AvailabilitySwitch({
    super.key,
    required this.isAvailable,
    required this.title,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isAvailable
              ? AppColors.primary.withAlpha(100)
              : theme.dividerColor,
          width: 1.5,
        ),
      ),
      child: SwitchListTile(
        value: isAvailable,
        onChanged: onChanged,
        activeThumbColor: AppColors.success.withAlpha(150),
        activeTrackColor: AppColors.success.withAlpha(50),
        inactiveThumbColor: Colors.grey[400],
        secondary: Icon(
          isAvailable ? Icons.check_circle : Icons.do_not_disturb_on,
          color: isAvailable ? AppColors.primary : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: responsive.getTitleFontSize(),
            fontWeight: FontWeight.w800,
            color: isAvailable
                ? AppColors.primary
                : theme.textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text(
          isAvailable ? "مفعل " : "غير مفعل",
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ),
    );
  }
}
