import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

/// عنوان قسم موحد: شريط لوني + العنوان + عداد اختياري + زر "عرض الكل" اختياري
class SectionHeader extends StatelessWidget {
  final String title;
  final int? count;
  final VoidCallback? onSeeAll;
  final EdgeInsetsGeometry padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.count,
    this.onSeeAll,
    this.padding = const EdgeInsets.only(bottom: AppDesignTokens.space12),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final res = context.responsive;

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: AppDesignTokens.space10),
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: res.getTitleFontSize(),
                color: colorScheme.onSurface,
              ),
            ),
          ),
          if (count != null && count! > 0) ...[
            const SizedBox(width: AppDesignTokens.space10),
            SoftSurface(
              compact: true,
              borderRadius: AppDesignTokens.radiusCircular,
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              child: Text(
                '$count',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const Spacer(),
          if (onSeeAll != null)
            SoftSurface(
              compact: true,
              borderRadius: AppDesignTokens.radiusCircular,
              onTap: onSeeAll,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesignTokens.space14,
                vertical: AppDesignTokens.space8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'عرض الكل',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppDesignTokens.space6),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
