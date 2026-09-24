import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/icon_card_with_shadow.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/image_gallery_editor.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_controller.dart';

/// صفحة مخصصة متكاملة لإدارة وإنشاء وتعديل الإعلانات الترويجية بنظام Material Design 3
class PromoFormScreen extends StatefulWidget {
  final PromoEntity? promo;

  const PromoFormScreen({super.key, this.promo});

  @override
  State<PromoFormScreen> createState() => _PromoFormScreenState();
}

class _PromoFormScreenState extends State<PromoFormScreen> {
  late final PromosController controller;

  // ألوان سريعة جاهزة للإعلانات
  static const List<String> _presetColors = [
    '#FFFFFF',
    '#18181B',
    '#0F172A',
    '#B91C1C',
    '#15803D',
    '#1D4ED8',
    '#7C3AED',
    '#C2410C',
    '#0E7490',
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.find<PromosController>();
    if (widget.promo != null) {
      controller.populateForm(widget.promo!);
    } else {
      controller.clearForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.promo != null;
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
                      onPressed: () => controller.savePromo(existingPromo: widget.promo),
                      icon: Icon(
                        isEditing ? Icons.save_rounded : Icons.check_circle_rounded,
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
                // 1. Header Banner & Status
                _buildTopInfoBanner(context, isEditing),
                const SizedBox(height: 16),

                // 2. Main Content Grid
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العمود الرئيسي: المعاينة الحية + المحتوى النصي + التوجيه
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _SectionCard(
                              title: 'المعاينة المباشرة للإعلان (Live Preview)',
                              icon: Icons.preview_rounded,
                              child: _PromoLivePreview(controller: controller),
                            ),
                            const SizedBox(height: 16),
                            _SectionCard(
                              title: 'المحتوى النصي ثنائي اللغة',
                              icon: Icons.translate_rounded,
                              child: _buildLanguageTabs(context, controller),
                            ),
                            const SizedBox(height: 16),
                            _SectionCard(
                              title: 'توجيه الإعلان (الارتباط)',
                              icon: Icons.link_rounded,
                              child: _buildTargetSection(context, controller),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // العمود الجانبي: صورة الإعلان + المظهر واللون + حالة النشر
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _SectionCard(
                              title: 'صورة الإعلان الرئيسية',
                              icon: Icons.image_outlined,
                              child: _buildImageSection(controller),
                            ),
                            const SizedBox(height: 16),
                            _SectionCard(
                              title: 'المظهر ولون الخلفية',
                              icon: Icons.palette_outlined,
                              child: _buildAppearanceSection(context, controller),
                            ),
                            const SizedBox(height: 16),
                            _SectionCard(
                              title: 'حالة النشر والظهور',
                              icon: Icons.visibility_outlined,
                              child: _buildPublishingStatusSection(context, controller),
                            ),
                            const SizedBox(height: 24),
                            _buildSaveActionCard(context, controller, isEditing),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  // تخطيط الهواتف المحمولة
                  Column(
                    children: [
                      _SectionCard(
                        title: 'المعاينة المباشرة للإعلان',
                        icon: Icons.preview_rounded,
                        child: _PromoLivePreview(controller: controller),
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'صورة الإعلان',
                        icon: Icons.image_outlined,
                        child: _buildImageSection(controller),
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'المحتوى النصي',
                        icon: Icons.translate_rounded,
                        child: _buildLanguageTabs(context, controller),
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'توجيه الإعلان',
                        icon: Icons.link_rounded,
                        child: _buildTargetSection(context, controller),
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'لون ومظهر الإعلان',
                        icon: Icons.palette_outlined,
                        child: _buildAppearanceSection(context, controller),
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'حالة النشر',
                        icon: Icons.visibility_outlined,
                        child: _buildPublishingStatusSection(context, controller),
                      ),
                      const SizedBox(height: 24),
                      _buildSaveActionCard(context, controller, isEditing),
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

  // ── Top Info Banner ──────────────────────────────────────────────────────
  Widget _buildTopInfoBanner(BuildContext context, bool isEditing) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card.outlined(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            IconCardWithShadow(icon: Icons.campaign_rounded),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? 'تعديل الإعلان الترويجي' : 'إدارة الحملات الإعلانية',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'قم بتخصيص البانر الإعلاني ونصوصه ونقاط توجيهه للعملاء في التطبيق.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Image Section ────────────────────────────────────────────────────────
  Widget _buildImageSection(PromosController controller) {
    return Obx(() {
      final imageUrls = <String>[];
      if (controller.selectedImage.value != null) {
        imageUrls.add(controller.selectedImage.value!.path);
      } else if (controller.existingImageUrl.value.isNotEmpty) {
        imageUrls.add(controller.existingImageUrl.value);
      }

      return ImageGalleryEditor(
        imageUrls: imageUrls,
        onAddUrl: (url) {
          controller.existingImageUrl.value = url;
          controller.selectedImage.value = null;
        },
        onRemove: (index) {
          controller.existingImageUrl.value = '';
          controller.selectedImage.value = null;
        },
        onPickImage: () => controller.pickImage(),
        onReorder: (oldIndex, newIndex) {},
      );
    });
  }

  // ── Language Tabs ────────────────────────────────────────────────────────
  Widget _buildLanguageTabs(BuildContext context, PromosController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: colorScheme.onPrimary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: theme.textTheme.labelLarge,
              tabs: const [
                Tab(
                  icon: Icon(Icons.language_rounded, size: 18),
                  text: 'اللغة العربية',
                ),
                Tab(
                  icon: Icon(Icons.translate_rounded, size: 18),
                  text: 'English',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: TabBarView(
              children: [
                _buildTextFields(
                  titleCtrl: controller.titleArController,
                  subtitleCtrl: controller.subtitleArController,
                  buttonCtrl: controller.buttonArController,
                  titleLabel: 'العنوان بالعربية',
                  subtitleLabel: 'العنوان الفرعي بالعربية',
                  buttonLabel: 'نص زر الإجراء (CTA)',
                ),
                _buildTextFields(
                  titleCtrl: controller.titleEnController,
                  subtitleCtrl: controller.subtitleEnController,
                  buttonCtrl: controller.buttonEnController,
                  titleLabel: 'Title in English',
                  subtitleLabel: 'Subtitle in English',
                  buttonLabel: 'Button Text (CTA)',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFields({
    required TextEditingController titleCtrl,
    required TextEditingController subtitleCtrl,
    required TextEditingController buttonCtrl,
    required String titleLabel,
    required String subtitleLabel,
    required String buttonLabel,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ModernTextField(
            icon: Icons.title_rounded,
            label: titleLabel,
            controller: titleCtrl,
          ),
          const SizedBox(height: 14),
          ModernTextField(
            icon: Icons.subtitles_rounded,
            label: subtitleLabel,
            controller: subtitleCtrl,
          ),
          const SizedBox(height: 14),
          ModernTextField(
            icon: Icons.smart_button_rounded,
            label: buttonLabel,
            controller: buttonCtrl,
          ),
        ],
      ),
    );
  }

  // ── Appearance Section (Color & Presets) ──────────────────────────────────
  Widget _buildAppearanceSection(BuildContext context, PromosController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              Color parsed = Colors.white;
              try {
                final hex = controller.backgroundColorHex.value.replaceAll('#', '');
                if (hex.length == 6) parsed = Color(int.parse('FF$hex', radix: 16));
              } catch (_) {}
              return Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: parsed,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(width: 14),
            Expanded(
              child: ModernTextField(
                icon: Icons.color_lens_outlined,
                label: 'كود اللون (Hex #RRGGBB)',
                controller: controller.backgroundColorController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'ألوان جاهزة مقترحة:',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _presetColors.map((hex) {
            Color color = Colors.white;
            try {
              final raw = hex.replaceAll('#', '');
              color = Color(int.parse('FF$raw', radix: 16));
            } catch (_) {}

            return Obx(() {
              final isSelected = controller.backgroundColorHex.value.toUpperCase() == hex.toUpperCase();
              return InkWell(
                onTap: () {
                  controller.backgroundColorController.text = hex;
                  controller.backgroundColorHex.value = hex;
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
                      width: isSelected ? 2.5 : 1.0,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: ThemeData.estimateBrightnessForColor(color) == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        )
                      : null,
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }

  // ── Target Section ───────────────────────────────────────────────────────
  Widget _buildTargetSection(BuildContext context, PromosController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(
                  value: 'none',
                  label: Text('عام (بدون توجيه)'),
                  icon: Icon(Icons.block_rounded, size: 18),
                ),
                ButtonSegment<String>(
                  value: 'product',
                  label: Text('منتج محدد'),
                  icon: Icon(Icons.inventory_2_rounded, size: 18),
                ),
                ButtonSegment<String>(
                  value: 'brand',
                  label: Text('ماركة تجارية'),
                  icon: Icon(Icons.category_rounded, size: 18),
                ),
              ],
              selected: {controller.selectedTargetType.value},
              onSelectionChanged: (newSelection) {
                controller.selectedTargetType.value = newSelection.first;
                controller.selectedTargetId.value = null;
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.selectedTargetType.value == 'product') {
            return _buildProductDropdown(context, controller);
          } else if (controller.selectedTargetType.value == 'brand') {
            return _buildBrandDropdown(context, controller);
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildProductDropdown(BuildContext context, PromosController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final products = controller.products;
      if (products.isEmpty) {
        return _loadingDropdown(context, 'جاري تحميل قائمة المنتجات...');
      }

      return Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedTargetId.value,
            hint: Text(
              'اختر منتجاً لربط الإعلان به...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            dropdownColor: colorScheme.surfaceContainerHigh,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            items: products.map((p) {
              return DropdownMenuItem<String>(
                value: p.id,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: p.imageUrls.isNotEmpty ? p.imageUrls.first : '',
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => Icon(
                          Icons.inventory_2_outlined,
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        placeholder: (_, _) => Icon(
                          Icons.inventory_2_outlined,
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        p.nameAr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) => controller.selectedTargetId.value = val,
          ),
        ),
      );
    });
  }

  Widget _buildBrandDropdown(BuildContext context, PromosController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final brands = controller.brands;
      final isFetching = controller.isBrandsLoading.value;

      if (isFetching && brands.isEmpty) {
        return _loadingDropdown(context, 'جاري تحميل قائمة الماركات...');
      }

      if (brands.isEmpty) {
        return _emptyState(context, 'لا توجد ماركات مسجلة حالياً');
      }

      return Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: brands.any((b) => b.id == controller.selectedTargetId.value)
                ? controller.selectedTargetId.value
                : null,
            hint: Text(
              'اختر ماركة لربط الإعلان بها...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            dropdownColor: colorScheme.surfaceContainerHigh,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            items: brands.map((b) {
              return DropdownMenuItem<String>(
                value: b.id,
                child: Row(
                  children: [
                    if (b.imageUrl != null && b.imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: b.imageUrl!,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Icon(
                            Icons.category,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          placeholder: (_, _) => Icon(
                            Icons.category,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      )
                    else
                      Icon(
                        Icons.category_rounded,
                        color: colorScheme.onSurfaceVariant,
                        size: 28,
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            b.displayName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) => controller.selectedTargetId.value = val,
          ),
        ),
      );
    });
  }

  // ── Publishing Status Section ────────────────────────────────────────────
  Widget _buildPublishingStatusSection(BuildContext context, PromosController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(
      () => SwitchListTile.adaptive(
        title: Text(
          'تفعيل الإعلان فوراً',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          controller.isActive.value
              ? 'الإعلان نشط وسيظهر للمستخدمين في التطبيق'
              : 'الإعلان مسودة ولن يظهر للعملاء',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        value: controller.isActive.value,
        onChanged: (val) => controller.isActive.value = val,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  // ── Save Action Card ─────────────────────────────────────────────────────
  Widget _buildSaveActionCard(
    BuildContext context,
    PromosController controller,
    bool isEditing,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: controller.isLoading.value
              ? null
              : () => controller.savePromo(existingPromo: widget.promo),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: controller.isLoading.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onPrimary,
                  ),
                )
              : Icon(
                  isEditing ? Icons.save_rounded : Icons.check_circle_rounded,
                  size: 20,
                ),
          label: Text(
            isEditing ? 'حفظ التعديلات' : 'نشر الإعلان في المتجر',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  Widget _loadingDropdown(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة قسم موحدة بنمط Material Design 3
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card.outlined(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                IconCardWithShadow(icon: icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// معاينة مباشرة وتفاعلية للإعلان تحاكي ظهوره في تطبيق المستخدم
class _PromoLivePreview extends StatelessWidget {
  final PromosController controller;

  const _PromoLivePreview({required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      Color bgColor = Colors.white;
      try {
        final hex = controller.backgroundColorHex.value.replaceAll('#', '');
        if (hex.length == 6) bgColor = Color(int.parse('FF$hex', radix: 16));
      } catch (_) {}

      final isDarkBg = ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark;
      final textColor = isDarkBg ? Colors.white : Colors.black87;
      final subtextColor = isDarkBg ? Colors.white70 : Colors.black54;

      final title = controller.titleArController.text.isNotEmpty
          ? controller.titleArController.text
          : (controller.titleEnController.text.isNotEmpty
              ? controller.titleEnController.text
              : 'عنوان الإعلان الترويجي');

      final subtitle = controller.subtitleArController.text.isNotEmpty
          ? controller.subtitleArController.text
          : (controller.subtitleEnController.text.isNotEmpty
              ? controller.subtitleEnController.text
              : 'وصف جذاب يوضح تفاصيل العرض');

      final buttonText = controller.buttonArController.text.isNotEmpty
          ? controller.buttonArController.text
          : (controller.buttonEnController.text.isNotEmpty
              ? controller.buttonEnController.text
              : 'تسوق الآن');

      final hasLocalImage = controller.selectedImage.value != null;
      final hasRemoteImage = controller.existingImageUrl.value.isNotEmpty;

      return Container(
        height: 175,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              left: -20,
              bottom: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDarkBg ? Colors.white : Colors.black).withValues(alpha: 0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: subtextColor,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDarkBg ? Colors.white : Colors.black87,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            buttonText,
                            style: TextStyle(
                              color: isDarkBg ? Colors.black87 : Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 135,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: (isDarkBg ? Colors.white : Colors.black).withValues(alpha: 0.06),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: hasLocalImage
                          ? Image.file(
                              controller.selectedImage.value!,
                              fit: BoxFit.cover,
                            )
                          : (hasRemoteImage
                              ? CachedNetworkImage(
                                  imageUrl: controller.existingImageUrl.value,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, _, _) => Icon(
                                    Icons.campaign_outlined,
                                    size: 40,
                                    color: subtextColor,
                                  ),
                                  placeholder: (_, _) => Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 28,
                                        color: subtextColor,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'اختر صورة',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: subtextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: controller.isActive.value
                      ? Colors.green.shade700
                      : Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  controller.isActive.value ? 'نشط' : 'غير نشط',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
