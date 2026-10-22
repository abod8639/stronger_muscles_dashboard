import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/horizontal_chips_selector.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_providers.dart';

class DashboardPeriodSelector extends ConsumerWidget {
  const DashboardPeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(dashboardPeriodProvider);

    return HorizontalChipsSelector(
      items: dashboardPeriodItems,
      selectedId: selectedPeriod,
      onSelect: (id) => ref.read(dashboardPeriodProvider.notifier).setPeriod(id),
      labelKey: 'name',
      idKey: 'id',
      showAllOption: false,
      allLabel: 'الكل',
    );
  }
}
