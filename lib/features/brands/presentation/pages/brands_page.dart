import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/generic_empty_state.dart';
import 'package:stronger_muscles_dashboard/core/components/generic_grid_card.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import '../../domain/entities/brand_entity.dart';
import '../controllers/brands_providers.dart';
import '../controllers/brands_state.dart';

/// صفحة تصفح العلامات التجارية والبحث فيها
/// تستمع انتقائياً عبر `.select()` لتجنب إعادة بناء الشاشة كاملة
class BrandsPage extends ConsumerWidget {
  const BrandsPage({super.key});

  /// أقصى عرض للمحتوى على الشاشات العريضة
  static const double _maxContentWidth = 1400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(brandsNotifierProvider.notifier);
    Future<void> refresh() => notifier.loadBrands(forceRefresh: true);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BaseAppBar(title: 'العلامات التجارية', onPressed: refresh),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Column(
            children: [
              CustomSearchBar(
                hintText: 'البحث عن علامة تجارية...',
                padding: context.responsive.defaultPadding,
                onSearch: notifier.searchBrands,
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final status = ref.watch(
                      brandsNotifierProvider.select((s) => s.status),
                    );

                    return switch (status) {
                      BrandsStatus.initial ||
                      BrandsStatus.loading => const EnhancedLoadingWidget(
                        message: 'جاري تحميل العلامات التجارية...',
                      ),
                      BrandsStatus.failure => EnhancedErrorWidget.fromError(
                        ref.watch(
                              brandsNotifierProvider.select((s) => s.failure),
                            ) ??
                            'خطأ غير معروف',
                        fallbackTitle: 'تعذر تحميل العلامات التجارية',
                        onRetry: refresh,
                      ),
                      BrandsStatus.success || BrandsStatus.refreshing =>
                        _BrandsGrid(onRefresh: refresh),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// الشبكة تُعاد بناؤها فقط عند تغيّر القائمة المصفاة أو التحديد
class _BrandsGrid extends ConsumerWidget {
  final Future<void> Function() onRefresh;

  const _BrandsGrid({required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brands = ref.watch(
      brandsNotifierProvider.select((s) => s.filteredBrands),
    );
    final selectedId = ref.watch(
      brandsNotifierProvider.select((s) => s.selectedBrandId),
    );
    final isRefreshing = ref.watch(
      brandsNotifierProvider.select((s) => s.isRefreshing),
    );
    final responsive = context.responsive;

    if (brands.isEmpty) {
      return const GenericEmptyState(
        title: 'لا توجد نتائج',
        message: 'لا توجد علامات تجارية مطابقة',
        icon: Icons.search_off_rounded,
      );
    }

    return MyRefreshIndicator(
      onRefresh: onRefresh,
      child: Stack(
        children: [
          GridView.builder(
            padding: responsive.defaultPadding,
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: responsive.isMobile ? 200 : 220,
              mainAxisSpacing: responsive.itemSpacing,
              crossAxisSpacing: responsive.itemSpacing,
              childAspectRatio: 0.85,
            ),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              final isSelected = brand.id == selectedId;
              return _BrandCard(
                key: ValueKey(brand.id),
                brand: brand,
                isSelected: isSelected,
                onTap: () => ref
                    .read(brandsNotifierProvider.notifier)
                    .selectBrand(isSelected ? null : brand.id),
              );
            },
          ),
          if (isRefreshing)
            const PositionedDirectional(
              top: 0,
              start: 0,
              end: 0,
              child: LinearProgressIndicator(minHeight: 2),
            ),
        ],
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  final BrandEntity brand;
  final bool isSelected;
  final VoidCallback onTap;

  const _BrandCard({
    super.key,
    required this.brand,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GenericGridCard<BrandEntity>(
      data: brand,
      title: brand.displayName,
      subtitle: brand.nameAr.isNotEmpty ? brand.nameEn : null,
      imageUrl: brand.imageUrl,
      imageFit: BoxFit.contain,
      icon: Icons.business_rounded,
      selected: isSelected,
      onTap: onTap,
      statusWidget: InfoPill(
        label: brand.isActive ? 'نشط' : 'غير نشط',
        icon: brand.isActive
            ? Icons.check_circle_rounded
            : Icons.pause_circle_rounded,
        color: brand.isActive
            ? AppColors.success
            : Theme.of(context).colorScheme.error,
      ),
    );
  }
}
