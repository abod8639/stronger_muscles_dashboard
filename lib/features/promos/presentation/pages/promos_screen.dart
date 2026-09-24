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

              if (controller.filteredPromos.isEmpty) {
                return GenericEmptyState(
                  title: 'لا توجد نتائج',
                  message: controller.searchQuery.value.isEmpty
                      ? 'لا توجد إعلانات مسجلة حالياً'
                      : 'لم نجد أي إعلان يطابق بحثك: "${controller.searchQuery.value}"',
                  icon: Icons.campaign_rounded,
                  onAction: () => controller.fetchPromos(),
                  actionLabel: 'تحديث',
                );
              }

              return MyRefreshIndicator(
                onRefresh: () => controller.fetchPromos(),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.defaultPadding.left,
                    vertical: 10,
                  ),
                  itemCount: controller.filteredPromos.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final promo = controller.filteredPromos[index];
                    return PromoListItem(
                      promo: promo,
                      index: index,
                      onEdit: () {
                        Get.to(() => PromoFormScreen(promo: promo));
                      },
                      onDelete: () => controller.confirmDelete(promo.id, promo.displayTitle),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
