import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/core/components/base_data_view.dart';
import 'package:stronger_muscles_dashboard/core/components/generic_grid_card.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_providers.dart';
import 'package:stronger_muscles_dashboard/features/navigation/navigation_feature.dart';

/// ملخص التصنيفات في لوحة التحكم
class CategoriesSummarySection extends ConsumerWidget {
  const CategoriesSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = context.responsive;
    final stats =
        ref.watch(dashboardStatsNotifierProvider).value ??
        DashboardStatsEntity.initial();
    final categories = stats.categories;

    if (categories.isEmpty) return const SizedBox.shrink();

    return BaseDataView<CategoryEntity>(
      title: 'التصنيفات',
      crossAxisCount: res.isDesktop ? 4 : (res.isTablet ? 3 : 2),
      childAspectRatio: 0.95,
      items: categories,
      horizontalPadding: 0,
      showCount: res.isDesktop ? 8 : 6,
      onSeeAll: () =>
          ref.read(navigationControllerProvider.notifier).selectTab(1),
      itemBuilder: (context, category, index) =>
          GenericGridCard<CategoryEntity>(
            data: category,
            title: category.displayName,
            subtitle: category.descriptionAr,
            imageUrl: category.imageUrl,
            icon: Icons.category_outlined,
            statusWidget: category.isActive
                ? null
                : InfoPill(
                    label: 'معطل',
                    icon: Icons.pause_circle_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
            onTap: () => context.push(AppRoutes.categoryForm, extra: category),
          ),
    );
  }
}
