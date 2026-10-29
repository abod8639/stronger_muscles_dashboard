import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/components/section_card.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_providers.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_appearance_section.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_image_section.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_language_section.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_live_preview.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_publishing_section.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_save_action_card.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_target_section.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/form/promo_top_banner.dart';

/// صفحة إنشاء وتعديل الإعلانات الترويجية
class PromoFormScreen extends ConsumerWidget {
  final PromoEntity? promo;

  const PromoFormScreen({super.key, this.promo});

  static const double _desktopBreakpoint = 1050;
  static const double _tabletBreakpoint = 680;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(promoFormControllerProvider(promo));
    final isEditing = controller.isEditing;
    final responsive = context.responsive;
    final gap = responsive.isMobile
        ? AppDesignTokens.space12
        : AppDesignTokens.space16;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BaseAppBar(
        title: isEditing ? 'تعديل الإعلان' : 'إنشاء إعلان جديد',
        extraActions: [
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) => controller.isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : FilledButton.icon(
                    onPressed: () => savePromoAndClose(context, controller),
                    icon: Icon(
                      isEditing
                          ? Icons.save_rounded
                          : Icons.check_circle_rounded,
                      size: 18,
                    ),
                    label: Text(isEditing ? 'تحديث' : 'نشر'),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.isDesktop
              ? AppDesignTokens.space32
              : responsive.defaultPadding.left,
          vertical: gap,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PromoTopBanner(isEditing: isEditing),
                SizedBox(height: gap),
                LayoutBuilder(
                  builder: (context, constraints) => _buildLayout(
                    width: constraints.maxWidth,
                    gap: gap,
                    isEditing: isEditing,
                    preview: SectionCard(
                      title: 'المعاينة المباشرة للإعلان',
                      subtitle: 'محاكاة فورية لظهور البانر في تطبيق المتجر',
                      icon: Icons.preview_rounded,
                      highlighted: true,
                      trailing: const InfoPill(
                        label: 'معاينة حية',
                        icon: Icons.fiber_manual_record_rounded,
                        color: AppColors.success,
                      ),
                      child: PromoLivePreview(controller: controller),
                    ),
                    image: SectionCard(
                      title: 'صورة الإعلان الرئيسية',
                      subtitle: 'رفع صورة الغلاف أو إدراج رابط صورة مباشر',
                      icon: Icons.image_outlined,
                      child: PromoImageSection(controller: controller),
                    ),
                    appearance: SectionCard(
                      title: 'المظهر ولون الخلفية',
                      subtitle: 'كود اللون السداسي أو لون جاهز',
                      icon: Icons.palette_outlined,
                      child: PromoAppearanceSection(controller: controller),
                    ),
                    language: SectionCard(
                      title: 'المحتوى النصي ثنائي اللغة',
                      subtitle: 'العنوان والعنوان الفرعي وزر الإجراء',
                      icon: Icons.translate_rounded,
                      trailing: const InfoPill(label: 'AR / EN'),
                      child: PromoLanguageSection(controller: controller),
                    ),
                    target: SectionCard(
                      title: 'توجيه الإعلان (الارتباط)',
                      subtitle: 'وجهة العميل عند الضغط على البانر',
                      icon: Icons.link_rounded,
                      child: PromoTargetSection(controller: controller),
                    ),
                    publishing: SectionCard(
                      title: 'حالة النشر',
                      icon: Icons.sensors_rounded,
                      child: PromoPublishingSection(controller: controller),
                    ),
                    save: SectionCard(
                      title: isEditing ? 'تحديث الإعلان' : 'نشر الإعلان',
                      icon: isEditing
                          ? Icons.save_rounded
                          : Icons.rocket_launch_rounded,
                      child: PromoSaveActionCard(controller: controller),
                    ),
                  ),
                ),
                const SizedBox(height: AppDesignTokens.space32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ترتيب الأقسام حسب العرض المتاح؛ الأقسام نفسها تُبنى مرة واحدة
  Widget _buildLayout({
    required double width,
    required double gap,
    required bool isEditing,
    required Widget preview,
    required Widget image,
    required Widget appearance,
    required Widget language,
    required Widget target,
    required Widget publishing,
    required Widget save,
  }) {
    Widget row(List<Widget> children, {List<int>? flex}) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: gap),
          Expanded(flex: flex?[i] ?? 1, child: children[i]),
        ],
      ],
    );

    Widget column(List<Widget> children) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );

    if (width >= _desktopBreakpoint) {
      return column([
        row(
          [
            preview,
            column([image, appearance]),
          ],
          flex: [7, 5],
        ),
        row(
          [
            language,
            column([
              target,
              row([publishing, save]),
            ]),
          ],
          flex: [7, 5],
        ),
      ]);
    }

    if (width >= _tabletBreakpoint) {
      return column([
        preview,
        row([image, appearance]),
        row([language, target]),
        row([publishing, save]),
      ]);
    }

    return column([
      preview,
      image,
      appearance,
      language,
      target,
      publishing,
      save,
    ]);
  }
}
