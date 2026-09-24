import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/get_products_usecase.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/usecases/promo_usecases.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_controller.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_appearance_section.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_image_section.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_language_section.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_live_preview.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_publishing_section.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_save_action_card.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_section_card.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_target_section.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_top_banner.dart';

/// صفحة إنشاء وتعديل الإعلانات الترويجية المتوافقة مع معايير Clean Architecture و Material Design 3
class PromoFormScreen extends StatelessWidget {
  final PromoEntity? promo;

  const PromoFormScreen({super.key, this.promo});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      PromoFormController(
        initialPromo: promo,
        addPromoUseCase: Get.find<AddPromoUseCase>(),
        updatePromoUseCase: Get.find<UpdatePromoUseCase>(),
        uploadPromoImageUseCase: Get.find<UploadPromoImageUseCase>(),
        promosController: Get.isRegistered<PromosController>()
            ? Get.find<PromosController>()
            : null,
        getProductsUseCase: Get.isRegistered<GetProductsUseCase>()
            ? Get.find<GetProductsUseCase>()
            : null,
      ),
      tag: promo?.id ?? 'new_promo',
    );

    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = controller.isEditing;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth >= 960;
    final isMobile = context.isMobile;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: BaseAppBar(
        title: isEditing ? 'تعديل الإعلان' : 'إنشاء إعلان جديد',
        centerTitle: true,
        extraActions: [
          Obx(
            () => controller.isLoading.value
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FilledButton.icon(
                      onPressed: () => controller.savePromo(),
                      icon: Icon(
                        isEditing
                            ? Icons.save_rounded
                            : Icons.check_circle_rounded,
                        size: 18,
                      ),
                      label: Text(isEditing ? 'تحديث' : 'نشر الإعلان'),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 28.0 : (isMobile ? 12.0 : 18.0),
          vertical: isMobile ? 12.0 : 20.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. ترويسة معلوماتية
                PromoTopBanner(isEditing: isEditing),
                const SizedBox(height: 16),

                // 2. شبكة المحتوى المتجاوبة
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العمود الرئيسي: المعاينة + النصوص + التوجيه
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            PromoSectionCard(
                              title: 'المعاينة المباشرة للإعلان (Live Preview)',
                              icon: Icons.preview_rounded,
                              child: PromoLivePreview(controller: controller),
                            ),
                            const SizedBox(height: 16),
                            PromoSectionCard(
                              title: 'المحتوى النصي ثنائي اللغة',
                              icon: Icons.translate_rounded,
                              child:
                                  PromoLanguageSection(controller: controller),
                            ),
                            const SizedBox(height: 16),
                            PromoSectionCard(
                              title: 'توجيه الإعلان (الارتباط)',
                              icon: Icons.link_rounded,
                              child: PromoTargetSection(controller: controller),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // العمود الجانبي: الصورة + المظهر + حالة النشر + زر الحفظ
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            PromoSectionCard(
                              title: 'صورة الإعلان الرئيسية',
                              icon: Icons.image_outlined,
                              child: PromoImageSection(controller: controller),
                            ),
                            const SizedBox(height: 16),
                            PromoSectionCard(
                              title: 'المظهر ولون الخلفية',
                              icon: Icons.palette_outlined,
                              child: PromoAppearanceSection(
                                  controller: controller),
                            ),
                            const SizedBox(height: 16),
                            PromoSectionCard(
                              title: 'حالة النشر والظهور',
                              icon: Icons.visibility_outlined,
                              child: PromoPublishingSection(
                                  controller: controller),
                            ),
                            const SizedBox(height: 24),
                            PromoSaveActionCard(controller: controller),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  // تخطيط الشاشات الصغيرة والهواتف
                  Column(
                    children: [
                      PromoSectionCard(
                        title: 'المعاينة المباشرة للإعلان',
                        icon: Icons.preview_rounded,
                        child: PromoLivePreview(controller: controller),
                      ),
                      const SizedBox(height: 16),
                      PromoSectionCard(
                        title: 'صورة الإعلان',
                        icon: Icons.image_outlined,
                        child: PromoImageSection(controller: controller),
                      ),
                      const SizedBox(height: 16),
                      PromoSectionCard(
                        title: 'المحتوى النصي',
                        icon: Icons.translate_rounded,
                        child: PromoLanguageSection(controller: controller),
                      ),
                      const SizedBox(height: 16),
                      PromoSectionCard(
                        title: 'توجيه الإعلان',
                        icon: Icons.link_rounded,
                        child: PromoTargetSection(controller: controller),
                      ),
                      const SizedBox(height: 16),
                      PromoSectionCard(
                        title: 'لون ومظهر الإعلان',
                        icon: Icons.palette_outlined,
                        child:
                            PromoAppearanceSection(controller: controller),
                      ),
                      const SizedBox(height: 16),
                      PromoSectionCard(
                        title: 'حالة النشر',
                        icon: Icons.visibility_outlined,
                        child:
                            PromoPublishingSection(controller: controller),
                      ),
                      const SizedBox(height: 24),
                      PromoSaveActionCard(controller: controller),
                      const SizedBox(height: 32),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
