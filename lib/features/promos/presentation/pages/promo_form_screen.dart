import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_providers.dart';
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
class PromoFormScreen extends ConsumerWidget {
  final PromoEntity? promo;

  const PromoFormScreen({super.key, this.promo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(promoFormControllerProvider(promo));

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
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) => controller.isLoading
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
                      onPressed: () => controller.savePromo(context),
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
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => SingleChildScrollView(
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
                // 1. ترويسة معلوماتية بنمط Bento
                PromoTopBanner(isEditing: isEditing),
                const SizedBox(height: 18),

                // 2. شبكة Bento Grid المتجاوبة بحسب عرض الشاشة الفعلي
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    if (width >= 1050) {
                      return _buildDesktopBentoGrid(
                        context,
                        controller,
                        isEditing,
                      );
                    } else if (width >= 680) {
                      return _buildTabletBentoGrid(
                        context,
                        controller,
                        isEditing,
                      );
                    } else {
                      return _buildMobileBentoStack(
                        context,
                        controller,
                        isEditing,
                      );
                    }
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  // ── 1. تخطيط Bento Grid للشاشات الكبيرة (Desktop >= 1050px) ─────────────────
  Widget _buildDesktopBentoGrid(
    BuildContext context,
    PromoFormController controller,
    bool isEditing,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── الصف الأول: بصريات البانر والمظهر (Visual Bento Matrix) ──
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // كارد 1: المعاينة المباشرة التفاعلية (Hero Bento Card - 7 أعمدة)
            Expanded(
              flex: 7,
              child: PromoSectionCard(
                title: 'المعاينة المباشرة للإعلان (Live Preview)',
                subtitle: 'محاكاة تفاعلية فورية لظهور البانر في تطبيق الجوال',
                icon: Icons.preview_rounded,
                isHero: true,
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Live Simulator',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                child: PromoLivePreview(controller: controller),
              ),
            ),
            const SizedBox(width: 16),

            // العمود الجانبي المتمم للصف الأول (5 أعمدة): صورة الإعلان + المظهر واللون
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  // كارد 2: صورة الإعلان الرئيسية (Media Bento)
                  PromoSectionCard(
                    title: 'صورة الإعلان الرئيسية',
                    subtitle: 'رفع صورة الغلاف أو إدراج رابط صورة مباشر',
                    icon: Icons.image_outlined,
                    child: PromoImageSection(controller: controller),
                  ),
                  const SizedBox(height: 16),

                  // كارد 3: المظهر ولون الخلفية (Style Bento)
                  PromoSectionCard(
                    title: 'المظهر ولون الخلفية',
                    subtitle: 'تخصيص كود اللون السداسي Hex أو اختيار لون جاهز',
                    icon: Icons.palette_outlined,
                    child: PromoAppearanceSection(controller: controller),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ── الصف الثاني: المحتوى والتوجيه والإجراءات (Data & Actions Bento Matrix) ──
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // كارد 4: المحتوى النصي ثنائي اللغة (Content Bento - 7 أعمدة)
            Expanded(
              flex: 7,
              child: PromoSectionCard(
                title: 'المحتوى النصي ثنائي اللغة',
                subtitle:
                    'العنوان والعنوان الفرعي وزر الإجراء بالعربية والإنجليزية',
                icon: Icons.translate_rounded,
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'AR / EN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                child: PromoLanguageSection(controller: controller),
              ),
            ),
            const SizedBox(width: 16),

            // كارد 5 و 6 و 7: توجيه الإعلان وحالة النشر وزر الحفظ (5 أعمدة)
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  // كارد 5: توجيه الإعلان ونقاط الربط (Target Bento)
                  PromoSectionCard(
                    title: 'توجيه الإعلان (الارتباط)',
                    subtitle:
                        'تحديد وجهة العميل عند الضغط على البانر داخل التطبيق',
                    icon: Icons.link_rounded,
                    child: PromoTargetSection(controller: controller),
                  ),
                  const SizedBox(height: 16),

                  // كارد 6 و 7: مقسم أفقي لحالة النشر وإجراء الحفظ السريع
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // كارد 6: حالة النشر والظهور
                      Expanded(
                        child: PromoSectionCard(
                          title: 'حالة النشر',
                          icon: Icons.sensors_rounded,
                          contentPadding: const EdgeInsets.all(14),
                          trailing: ListenableBuilder(
                            listenable: controller,
                            builder: (context, _) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: controller.isActive
                                    ? Colors.green.withValues(alpha: 0.15)
                                    : Colors.grey.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                controller.isActive ? 'مباشر' : 'مسودة',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: controller.isActive
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          child: PromoPublishingSection(controller: controller),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // كارد 7: إجراء الحفظ والتأكيد
                      Expanded(
                        child: PromoSectionCard(
                          title: isEditing ? 'تحديث الإعلان' : 'نشر الإعلان',
                          icon: isEditing
                              ? Icons.save_rounded
                              : Icons.rocket_launch_rounded,
                          contentPadding: const EdgeInsets.all(14),
                          child: PromoSaveActionCard(controller: controller),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── 2. تخطيط Bento Grid للشاشات المتوسطة (Tablet: 680px - 1050px) ───────────
  Widget _buildTabletBentoGrid(
    BuildContext context,
    PromoFormController controller,
    bool isEditing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. المعاينة المباشرة عريضة كـ Hero Tile
        PromoSectionCard(
          title: 'المعاينة المباشرة للإعلان (Live Preview)',
          subtitle: 'محاكاة تفاعلية فورية لظهور البانر في تطبيق الجوال',
          icon: Icons.preview_rounded,
          isHero: true,
          child: PromoLivePreview(controller: controller),
        ),
        const SizedBox(height: 16),

        // 2. شبكة متجاوبة من عمودين: صورة الإعلان + المظهر واللون
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PromoSectionCard(
                title: 'صورة الإعلان الرئيسية',
                subtitle: 'رفع الصورة أو إدراج رابط مباشر',
                icon: Icons.image_outlined,
                child: PromoImageSection(controller: controller),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PromoSectionCard(
                title: 'المظهر ولون الخلفية',
                subtitle: 'كود اللون أو باليت جاهزة',
                icon: Icons.palette_outlined,
                child: PromoAppearanceSection(controller: controller),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 3. المحتوى النصي + توجيه الإعلان
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PromoSectionCard(
                title: 'المحتوى النصي ثنائي اللغة',
                subtitle: 'العناوين والأوصاف وأزرار الإجراء',
                icon: Icons.translate_rounded,
                child: PromoLanguageSection(controller: controller),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PromoSectionCard(
                title: 'توجيه الإعلان (الارتباط)',
                subtitle: 'تحديد وجهة الرابط عند الضغط',
                icon: Icons.link_rounded,
                child: PromoTargetSection(controller: controller),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 4. حالة النشر + زر الحفظ
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PromoSectionCard(
                title: 'حالة النشر والظهور',
                icon: Icons.sensors_rounded,
                child: PromoPublishingSection(controller: controller),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PromoSectionCard(
                title: isEditing ? 'تحديث الإعلان' : 'نشر الإعلان',
                icon: isEditing
                    ? Icons.save_rounded
                    : Icons.rocket_launch_rounded,
                child: PromoSaveActionCard(controller: controller),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── 3. تخطيط Bento Stack للهواتف والشاشات الصغيرة (< 680px) ─────────────────
  Widget _buildMobileBentoStack(
    BuildContext context,
    PromoFormController controller,
    bool isEditing,
  ) {
    return Column(
      children: [
        PromoSectionCard(
          title: 'المعاينة المباشرة للإعلان',
          subtitle: 'محاكاة لظهور الإعلان في المتجر',
          icon: Icons.preview_rounded,
          isHero: true,
          child: PromoLivePreview(controller: controller),
        ),
        const SizedBox(height: 16),
        PromoSectionCard(
          title: 'صورة الإعلان الرئيسية',
          subtitle: 'رفع الصورة أو رابط خارجي',
          icon: Icons.image_outlined,
          child: PromoImageSection(controller: controller),
        ),
        const SizedBox(height: 16),
        PromoSectionCard(
          title: 'المظهر ولون الخلفية',
          subtitle: 'اختيار لون البانر',
          icon: Icons.palette_outlined,
          child: PromoAppearanceSection(controller: controller),
        ),
        const SizedBox(height: 16),
        PromoSectionCard(
          title: 'المحتوى النصي ثنائي اللغة',
          subtitle: 'العناوين وأزرار الإجراء',
          icon: Icons.translate_rounded,
          child: PromoLanguageSection(controller: controller),
        ),
        const SizedBox(height: 16),
        PromoSectionCard(
          title: 'توجيه الإعلان (الارتباط)',
          subtitle: 'وجهة الضغط على الإعلان',
          icon: Icons.link_rounded,
          child: PromoTargetSection(controller: controller),
        ),
        const SizedBox(height: 16),
        PromoSectionCard(
          title: 'حالة النشر والظهور',
          icon: Icons.sensors_rounded,
          child: PromoPublishingSection(controller: controller),
        ),
        const SizedBox(height: 16),
        PromoSectionCard(
          title: isEditing ? 'تحديث الإعلان' : 'نشر الإعلان في المتجر',
          icon: isEditing
              ? Icons.save_rounded
              : Icons.rocket_launch_rounded,
          child: PromoSaveActionCard(controller: controller),
        ),
      ],
    );
  }
}
