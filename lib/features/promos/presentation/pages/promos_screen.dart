import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/generic_empty_state.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/top_section.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_controller.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/pages/promo_form_screen.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/promo_app_banner_preview.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/promo_list_item.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';

class PromosScreen extends StatelessWidget {
  const PromosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PromosController>();
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BaseAppBar(
        title: 'الإعلانات (Promos)',
        onPressed: () {
          Get.to(() => const PromoFormScreen());
        },
        icon: Icons.add,
      ),
      body: Column(
        children: [
          TopSection(
            children: [
              CustomSearchBar(
                hintText: 'ابحث عن إعلان بالعنوان...',
                padding: responsive.defaultPadding,
                onSearch: (value) => controller.onSearchChanged(value),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.promos.isEmpty) {
                return const EnhancedLoadingWidget(
                  message: 'جاري تحميل الإعلانات...',
                );
              }

              if (controller.promos.isEmpty && !controller.isLoading.value) {
                return GenericEmptyState(
                  title: 'لا توجد إعلانات',
                  message: 'لا توجد إعلانات مسجلة حالياً في النظام',
                  icon: Icons.campaign_rounded,
                  onAction: () => controller.fetchPromos(),
                  actionLabel: 'تحديث',
                );
              }

              final promos = controller.promos;
              final filtered = controller.filteredPromos;

              return MyRefreshIndicator(
                onRefresh: () => controller.fetchPromos(),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.defaultPadding.left,
                    vertical: 10,
                  ),
                  children: [
                    // معاينة بانر الإعلانات داخل تطبيق المتجر
                    PromoAppBannerPreview(
                      promos: promos,
                      onPromoTap: (promo) {
                        Get.to(() => PromoFormScreen(promo: promo));
                      },
                    ),
                    const SizedBox(height: 4),

                    // شريط معلومات القائمة والبحث
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'قائمة الإعلانات المسجلة',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${filtered.length}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (controller.searchQuery.value.isNotEmpty)
                            TextButton.icon(
                              onPressed: () => controller.onSearchChanged(''),
                              icon: const Icon(Icons.clear_rounded, size: 16),
                              label: const Text(
                                'إلغاء البحث',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // نتائج البحث أو عناصر القائمة
                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: GenericEmptyState(
                          title: 'لا توجد نتائج',
                          message:
                              'لم نجد أي إعلان يطابق بحثك: "${controller.searchQuery.value}"',
                          icon: Icons.search_off_rounded,
                          onAction: () => controller.onSearchChanged(''),
                          actionLabel: 'مسح البحث',
                        ),
                      )
                    else
                      ...List.generate(filtered.length, (index) {
                        final promo = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PromoListItem(
                            promo: promo,
                            index: index,
                            onEdit: () {
                              Get.to(() => PromoFormScreen(promo: promo));
                            },
                            onDelete: () => controller.confirmDelete(
                              promo.id,
                              promo.displayTitle,
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
