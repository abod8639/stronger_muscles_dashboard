import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

/// شريط ترقيم صفحات موحد: ملخص "عرض X إلى Y من Z" + أزرار الصفحات
/// يختصر الصفحات البعيدة بعلامة (...) عند تجاوز 5 صفحات
class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int itemsPerPage;
  final int totalCount;
  final int currentCount;
  final ValueChanged<int> onPageChanged;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.itemsPerPage,
    required this.totalCount,
    required this.currentCount,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final start = totalCount == 0 ? 0 : (currentPage - 1) * itemsPerPage + 1;
    final end = (start + currentCount - 1).clamp(0, totalCount);

    final summary = Text(
      'عرض $start إلى $end من $totalCount',
      style: theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );

    final controls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SoftIconButton(
          icon: Icons.chevron_right_rounded,
          tooltip: 'الصفحة السابقة',
          size: 32,
          onPressed: currentPage > 1
              ? () => onPageChanged(currentPage - 1)
              : null,
        ),
        const SizedBox(width: AppDesignTokens.space8),
        ..._buildPageItems(context),
        const SizedBox(width: AppDesignTokens.space8),
        SoftIconButton(
          icon: Icons.chevron_left_rounded,
          tooltip: 'الصفحة التالية',
          size: 32,
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.space20,
        vertical: AppDesignTokens.space14,
      ),
      child: context.isMobile
          ? Column(
              children: [
                summary,
                const SizedBox(height: AppDesignTokens.space12),
                FittedBox(fit: BoxFit.scaleDown, child: controls),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [summary, controls],
            ),
    );
  }

  List<Widget> _buildPageItems(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = <Widget>[];

    for (var page = 1; page <= totalPages; page++) {
      final isEdge = page == 1 || page == totalPages;
      final isNearCurrent = (page - currentPage).abs() <= 1;

      if (totalPages > 5 && !isEdge && !isNearCurrent) {
        if (page == 2 || page == totalPages - 1) {
          items.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '...',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          );
        }
        continue;
      }

      final isSelected = page == currentPage;
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: SoftSurface(
            compact: true,
            selected: isSelected,
            width: 32,
            height: 32,
            onTap: isSelected ? null : () => onPageChanged(page),
            child: Center(
              child: Text(
                '$page',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return items;
  }
}
