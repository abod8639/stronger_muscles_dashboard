import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/image_gallery_editor.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_controller.dart';

/// نافذة نموذج الإعلان المتوافقة بالكامل مع معايير Material Design 3
class PromoFormSheet extends StatelessWidget {
  final PromoEntity? promo;

  const PromoFormSheet({super.key, this.promo});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PromosController>();
    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = promo != null;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      child: Column(
        children: [
          // M3 Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          _buildHeader(context, isEditing),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Section
                  Obx(() {
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
                  }),
                  const SizedBox(height: 24),
                  _buildLanguageTabs(context, controller),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'إعدادات الإعلان'),
                  _buildColorRow(context, controller),
                  const SizedBox(height: 20),
                  _buildTargetSection(context, controller),
                  const SizedBox(height: 20),
                  Obx(
                    () => SwitchListTile(
                      title: Text(
                        'تفعيل الإعلان',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      value: controller.isActive.value,
                      onChanged: (val) => controller.isActive.value = val,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Obx(() => _buildSaveButton(context, controller, isEditing)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────  Header  ──────────────────────────────────

  Widget _buildHeader(BuildContext context, bool isEditing) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isEditing ? 'تعديل الإعلان' : 'إضافة إعلان جديد',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
            tooltip: 'إغلاق',
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────  Language Tabs  ───────────────────────────

  Widget _buildLanguageTabs(BuildContext context, PromosController controller) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'المحتوى النصي'),
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
                Tab(text: 'العربية'),
                Tab(text: 'English'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: TabBarView(
              children: [
                _buildTextFields(
                  titleCtrl: controller.titleArController,
                  subtitleCtrl: controller.subtitleArController,
                  buttonCtrl: controller.buttonArController,
                ),
                _buildTextFields(
                  titleCtrl: controller.titleEnController,
                  subtitleCtrl: controller.subtitleEnController,
                  buttonCtrl: controller.buttonEnController,
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
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ModernTextField(
            icon: Icons.title_rounded,
            label: 'العنوان',
            controller: titleCtrl,
          ),
          const SizedBox(height: 14),
          ModernTextField(
            icon: Icons.subtitles_rounded,
            label: 'العنوان الفرعي',
            controller: subtitleCtrl,
          ),
          const SizedBox(height: 14),
          ModernTextField(
            icon: Icons.smart_button_rounded,
            label: 'نص الزر',
            controller: buttonCtrl,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────  Color Row  ───────────────────────────────

  Widget _buildColorRow(BuildContext context, PromosController controller) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: parsed,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
          );
        }),
        const SizedBox(width: 12),
        Expanded(
          child: ModernTextField(
            icon: Icons.color_lens_outlined,
            label: 'لون الخلفية (Hex #RRGGBB)',
            controller: controller.backgroundColorController,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────  Target Section  ──────────────────────────

  Widget _buildTargetSection(BuildContext context, PromosController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'توجيه الإعلان'),
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(
                  value: 'none',
                  label: Text('لا يوجد'),
                  icon: Icon(Icons.block_rounded, size: 18),
                ),
                ButtonSegment<String>(
                  value: 'product',
                  label: Text('منتج'),
                  icon: Icon(Icons.inventory_2_rounded, size: 18),
                ),
                ButtonSegment<String>(
                  value: 'brand',
                  label: Text('ماركة'),
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

  Widget _buildProductDropdown(
    BuildContext context,
    PromosController controller,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final products = controller.products;
      if (products.isEmpty) {
        return _loadingDropdown(context, 'جاري تحميل المنتجات...');
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
              'اختر منتجًا...',
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
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => Icon(
                          Icons.category,
                          color: colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                        placeholder: (_, _) => Icon(
                          Icons.category,
                          color: colorScheme.onSurfaceVariant,
                          size: 24,
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

  Widget _buildBrandDropdown(
    BuildContext context,
    PromosController controller,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final brands = controller.brands;
      final isFetching = controller.isBrandsLoading.value;

      if (isFetching && brands.isEmpty) {
        return _loadingDropdown(context, 'جاري تحميل الماركات...');
      }

      if (brands.isEmpty) {
        return _emptyState(context, 'لا توجد ماركات متاحة');
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
                ? null
                : controller.selectedTargetId.value,
            hint: Text(
              'اختر ماركة...',
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
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Icon(
                            Icons.category,
                            color: colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                          placeholder: (_, _) => Icon(
                            Icons.category,
                            color: colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                      )
                    else
                      Icon(
                        Icons.category_rounded,
                        color: colorScheme.onSurfaceVariant,
                        size: 32,
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
                          Text(
                            b.id,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
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

  // ─────────────────────────────  Save Button  ─────────────────────────────

  Widget _buildSaveButton(
    BuildContext context,
    PromosController controller,
    bool isEditing,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: controller.isLoading.value
            ? null
            : () => controller.savePromo(existingPromo: promo),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: controller.isLoading.value
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onPrimary,
                ),
              )
            : Icon(
                isEditing ? Icons.save_rounded : Icons.add_circle_rounded,
                size: 20,
              ),
        label: Text(
          isEditing ? 'تحديث الإعلان' : 'حفظ الإعلان',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────  Helpers  ─────────────────────────────────

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
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
