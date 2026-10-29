import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/core/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/base_data_view.dart';
import 'package:stronger_muscles_dashboard/core/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/generic_empty_state.dart';
import 'package:stronger_muscles_dashboard/core/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_controller.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_providers.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/promo_app_banner_preview.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/promo_list_item.dart';

/// شاشة إدارة الإعلانات: معاينة البانر كما في التطبيق + قائمة الإعلانات
class PromosScreen extends ConsumerWidget {
  const PromosScreen({super.key});

  /// أقصى عرض للمحتوى على الشاشات العريضة
  static const double _maxContentWidth = 1400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(promosControllerProvider);
    final responsive = context.responsive;

    void openForm([PromoEntity? promo]) =>
        context.push(AppRoutes.promoForm, extra: promo);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BaseAppBar(title: 'الإعلانات', onPressed: controller.fetchPromos),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openForm,
        icon: const Icon(Icons.add_rounded),
        label: const Text('إعلان جديد'),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.isLoading && controller.promos.isEmpty) {
            return const EnhancedLoadingWidget(
              message: 'جاري تحميل الإعلانات...',
            );
          }

          if (controller.promos.isEmpty) {
            return GenericEmptyState(
              title: 'لا توجد إعلانات',
              message: 'لا توجد إعلانات مسجلة حالياً في النظام',
              icon: Icons.campaign_rounded,
              actionLabel: 'إنشاء إعلان',
              actionIcon: Icons.add_rounded,
              onAction: openForm,
            );
          }

          final filtered = controller.filteredPromos;

          return MyRefreshIndicator(
            onRefresh: controller.fetchPromos,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              // مساحة سفلية حتى لا يغطي الزر العائم آخر عنصر
              padding: EdgeInsets.fromLTRB(
                responsive.defaultPadding.left,
                0,
                responsive.defaultPadding.right,
                96,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomSearchBar(
                        hintText: 'ابحث عن إعلان بالعنوان...',
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.defaultPadding.top,
                        ),
                        onSearch: controller.onSearchChanged,
                      ),
                      PromoAppBannerPreview(
                        promos: controller.promos,
                        onPromoTap: openForm,
                      ),
                      if (filtered.isEmpty)
                        GenericEmptyState(
                          title: 'لا توجد نتائج',
                          message:
                              'لم نجد أي إعلان يطابق بحثك: "${controller.searchQuery}"',
                          icon: Icons.search_off_rounded,
                        )
                      else
                        BaseDataView<PromoEntity>(
                          title: 'قائمة الإعلانات المسجلة',
                          items: filtered,
                          horizontalPadding: 0,
                          useListView: !responsive.isDesktop,
                          crossAxisCount: 2,
                          mainAxisExtent: 112,
                          itemBuilder: (context, promo, index) => PromoListItem(
                            key: ValueKey(promo.id),
                            promo: promo,
                            index: index,
                            onEdit: () => openForm(promo),
                            onDelete: () =>
                                _confirmDelete(context, controller, promo),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    PromosController controller,
    PromoEntity promo,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'تأكيد الحذف',
        message: 'هل أنت متأكد أنك تريد حذف الإعلان "${promo.displayTitle}"؟',
        confirmText: 'حذف',
        confirmColor: Theme.of(ctx).colorScheme.error,
        icon: Icons.delete_forever_rounded,
        onConfirm: () {
          Navigator.of(ctx).pop();
          controller.deletePromo(promo.id);
        },
      ),
    );
  }
}
