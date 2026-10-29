import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/components/base_data_view.dart';
import 'package:stronger_muscles_dashboard/core/components/category_card.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_providers.dart';
import 'package:stronger_muscles_dashboard/features/navigation/navigation_feature.dart';

class CategoriesSummarySection extends ConsumerWidget {
  const CategoriesSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = context.responsive;
    final stats = ref.watch(dashboardStatsNotifierProvider).value ??
        DashboardStatsEntity.initial();
    final categories = stats.categories;

    if (categories.isEmpty) return const SizedBox();

    return BaseDataView<CategoryEntity>(
      title: 'التصنيفات',
      crossAxisCount: res.isDesktop ? 3 : 2,
      items: categories,
      onSeeAll: () =>
          ref.read(navigationControllerProvider.notifier).selectTab(1),
      itemBuilder: (context, category, index) {
        return CategoryCard(
          category: category,
          index: index,
          onTap: () => context.push(AppRoutes.categoryForm, extra: category),
        );
      },
    );
  }
}
