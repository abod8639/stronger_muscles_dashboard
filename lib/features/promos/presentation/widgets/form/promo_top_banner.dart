import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/icon_card_with_shadow.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

/// ترويسة تعريفية أعلى نموذج الإعلان
class PromoTopBanner extends StatelessWidget {
  final bool isEditing;

  const PromoTopBanner({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SoftSurface(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.space18,
        vertical: AppDesignTokens.space14,
      ),
      child: Row(
        children: [
          const IconCardWithShadow(icon: Icons.campaign_rounded, size: 20),
          const SizedBox(width: AppDesignTokens.space14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEditing
                      ? 'تعديل الإعلان الترويجي'
                      : 'تصميم وإدارة الحملات الإعلانية',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppDesignTokens.space2),
                Text(
                  'قم بتخصيص البانر ومظهره والمحتوى النصي ونقاط توجيه العملاء مباشرة بدقة.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
