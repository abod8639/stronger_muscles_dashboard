import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class AvailabilitySwitch extends StatelessWidget {
  final RxBool isAvailable;
  final String title;
  final Function(bool)? onChanged;

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

    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          // تغيير لون الخلفية حسب الحالة
          color: isAvailable.value
              ? AppColors.primary.withOpacity(0.05)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isAvailable.value
                ? AppColors.primary.withOpacity(0.3)
                : theme.dividerColor,
            width: 1.5,
          ),
        ),
        child: SwitchListTile(
          value: isAvailable.value,
          onChanged: (value) {
            isAvailable.value = value;
            if (onChanged != null) onChanged!(value);
          },
          // تحسين الألوان والمظهر
          activeThumbColor: AppColors.primary,
          activeTrackColor: AppColors.primary.withOpacity(0.2),
          inactiveThumbColor: Colors.grey[400],
          secondary: Icon(
            isAvailable.value ? Icons.check_circle : Icons.do_not_disturb_on,
            color: isAvailable.value ? AppColors.primary : Colors.grey,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: responsive.getTitleFontSize(),
              fontWeight: FontWeight.w800,
              color: isAvailable.value
                  ? AppColors.primary
                  : theme.textTheme.bodyLarge?.color,
            ),
          ),
          subtitle: Text(
            isAvailable.value ? "متاح  الآن" : "غير متاح حالياً",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
