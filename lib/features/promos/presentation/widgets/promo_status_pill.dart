import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

/// شارة حالة الإعلان الموحدة (نشط / غير نشط)
class PromoStatusPill extends StatelessWidget {
  final bool isActive;

  const PromoStatusPill({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return InfoPill(
      label: isActive ? 'نشط' : 'غير نشط',
      icon: isActive ? Icons.check_circle_rounded : Icons.pause_circle_rounded,
      color: isActive
          ? AppColors.success
          : Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}
