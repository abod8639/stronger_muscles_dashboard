import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/image_gallery_editor.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/widgets/build_text_field.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_controller.dart';

class PromoFormSheet extends StatelessWidget {
  final PromoEntity? promo;

  const PromoFormSheet({super.key, this.promo});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PromosController>();
    final isEditing = promo != null;

    return Container(
      decoration: const BoxDecoration(
        color: AppColorsExtended.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      child: Column(
        children: [
          _buildHeader(isEditing),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // _buildImageSection(controller),
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
                  _buildLanguageTabs(controller),
                  const SizedBox(height: 24),
                  _buildSectionTitle('إعدادات الإعلان'),
                  _buildColorRow(controller),
                  const SizedBox(height: 20),
                  _buildTargetSection(controller),
                  const SizedBox(height: 20),
                  Obx(
                    () => SwitchListTile(
                      title: const Text(
                        'تفعيل الإعلان',
                        style: TextStyle(color: AppColorsExtended.textPrimary),
                      ),
                      value: controller.isActive.value,
                      onChanged: (val) => controller.isActive.value = val,
                      activeThumbColor: AppColorsExtended.purpleAccent,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Obx(() => _buildSaveButton(controller, isEditing)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────  Header  ──────────────────────────────────

  Widget _buildHeader(bool isEditing) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: const BoxDecoration(
        color: AppColorsExtended.greenAccent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isEditing ? 'تعديل الإعلان' : 'إضافة إعلان جديد',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColorsExtended.textPrimary,
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: AppColorsExtended.textPrimary),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────  Language Tabs  ───────────────────────────

  Widget _buildLanguageTabs(PromosController controller) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('المحتوى النصي'),
          Container(
            decoration: BoxDecoration(
              color: AppColorsExtended.purpleAccent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColorsExtended.greenAccent),
            ),
            child: const TabBar(
              indicatorColor: AppColorsExtended.cardBgLight,
              labelColor: AppColorsExtended.cardBgLight,
              unselectedLabelColor: AppColorsExtended.borderColor,
              tabs: [
                Tab(text: 'العربية'),
                Tab(text: 'English'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
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
          buildTextField(
            icon: Icons.title,
            label: 'العنوان',
            controller: titleCtrl,
          ),
          const SizedBox(height: 16),
          buildTextField(
            icon: Icons.subtitles,
            label: 'العنوان الفرعي',
            controller: subtitleCtrl,
          ),
          const SizedBox(height: 16),
          buildTextField(
            icon: Icons.smart_button,
            label: 'نص الزر',
            controller: buttonCtrl,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────  Color Row  ───────────────────────────────

  Widget _buildColorRow(PromosController controller) {
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
            width: 44,
            height: 44,
            margin: const EdgeInsets.only(
              top: 8,
            ), // Align with text field input area
            decoration: BoxDecoration(
              color: parsed,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColorsExtended.borderColor),
            ),
          );
        }),
        const SizedBox(width: 12),
        Expanded(
          child: buildTextField(
            icon: Icons.color_lens,
            label: 'لون الخلفية (Hex #RRGGBB)',
            controller: controller.backgroundColorController,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────  Target Section  ──────────────────────────

  Widget _buildTargetSection(PromosController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('توجيه الإعلان'),
        // Type selector
        Obx(
          () => Row(
            children: [
              _typeChip(controller, 'none', 'لا يوجد', Icons.block),
              const SizedBox(width: 8),
              _typeChip(
                controller,
                'product',
                'منتج',
                Icons.inventory_2_rounded,
              ),
              const SizedBox(width: 8),
              _typeChip(controller, 'brand', 'ماركة', Icons.category_rounded),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Product dropdown — shown only when type = product
        Obx(() {
          if (controller.selectedTargetType.value == 'product') {
            return _buildProductDropdown(controller);
          } else if (controller.selectedTargetType.value == 'brand') {
            return _buildBrandDropdown(controller);
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _typeChip(
    PromosController c,
    String type,
    String label,
    IconData icon,
  ) {
    final isSelected = c.selectedTargetType.value == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          c.selectedTargetType.value = type;
          c.selectedTargetId.value = null; // Clear ID when type changes
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColorsExtended.purpleAccent.withOpacity(0.15)
                : AppColorsExtended.purpleAccent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColorsExtended.purpleAccent
                  : AppColorsExtended.backgroundColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? AppColorsExtended.purpleAccent
                    : AppColorsExtended.backgroundColor,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? AppColorsExtended.purpleAccent
                      : AppColorsExtended.backgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductDropdown(PromosController controller) {
    return Obx(() {
      final products = controller.products;
      if (products.isEmpty) return _loadingDropdown('جاري تحميل المنتجات...');

      return Container(
        decoration: BoxDecoration(
          color: AppColorsExtended.purpleAccent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColorsExtended.borderColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedTargetId.value,
            hint: const Text(
              'اختر منتجًا...',
              style: TextStyle(color: AppColorsExtended.backgroundColor),
            ),
            dropdownColor: AppColorsExtended.cardBg,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColorsExtended.purpleAccent,
            ),
            items: products.map((p) {
              return DropdownMenuItem<String>(
                value: p.id,
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: p.imageUrls.first,
                      width: 45,
                      // height: 20,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.category,
                        color: AppColorsExtended.textSecondary,
                      ),
                      placeholder: (context, url) => const Icon(
                        Icons.category,
                        color: AppColorsExtended.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      p.nameAr,
                      style: const TextStyle(
                        color: AppColorsExtended.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildBrandDropdown(PromosController controller) {
    return Obx(() {
      final brands = controller.brands;
      final isFetching = controller.isBrandsLoading.value;

      if (isFetching && brands.isEmpty) {
        return _loadingDropdown('جاري تحميل الماركات...');
      }

      if (brands.isEmpty) {
        return _emptyState('لا توجد ماركات متاحة');
        // return _loadingDropdown('لا توجد ماركات');
      }

      return Container(
        decoration: BoxDecoration(
          color: AppColorsExtended.greenLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColorsExtended.borderColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedTargetId.value.isEmpty || 
                    !brands.any((b) => b.id == controller.selectedTargetId.value)
                ? null 
                : controller.selectedTargetId.value,
            hint: const Text(
              'اختر ماركة...',
              style: TextStyle(color: AppColorsExtended.textSecondary),
            ),
            dropdownColor: AppColorsExtended.cardBg,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.orange,
            ),
            items: brands.map((b) {
              return DropdownMenuItem<String>(
                value: b.id,
                child: Row(
                  children: [
                    if (b.imageUrl != null)
                      CachedNetworkImage(
                        imageUrl: b.imageUrl!,
                        width: 45,
                        errorWidget: (context, url, error) => const Icon(
                          Icons.category,
                          color: AppColorsExtended.textSecondary,
                        ),
                        placeholder: (context, url) => const Icon(
                          Icons.category,
                          color: AppColorsExtended.textSecondary,
                        ),
                      )
                    else
                      const Icon(
                        Icons.category,
                        color: AppColorsExtended.textSecondary,
                        size: 45,
                      ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          b.displayName,
                          style: const TextStyle(
                            color: AppColorsExtended.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          b.id,
                          style: const TextStyle(
                            color: AppColorsExtended.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
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

  Widget _loadingDropdown(String message) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColorsExtended.greenLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColorsExtended.borderColor),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 10),
          Text(message),
        ],
      ),
    );
  }

  // ─────────────────────────────  Save Button  ─────────────────────────────

  Widget _buildSaveButton(PromosController controller, bool isEditing) {
    return ElevatedButton.icon(
      onPressed: controller.isLoading.value
          ? null
          : () => controller.savePromo(existingPromo: promo),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsExtended.purpleAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        disabledBackgroundColor: AppColorsExtended.purpleAccent.withOpacity(
          0.4,
        ),
      ),
      icon: controller.isLoading.value
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(isEditing ? Icons.save_rounded : Icons.add_circle_rounded),
      label: Text(
        isEditing ? 'تحديث الإعلان' : 'حفظ الإعلان',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ─────────────────────────────  Helpers  ─────────────────────────────────

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: AppColorsExtended.textPrimary,
        ),
      ),
    );
  }
  
  Widget _emptyState(String message) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColorsExtended.greenLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColorsExtended.borderColor),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColorsExtended.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              message,
              style: const TextStyle(color: AppColorsExtended.textSecondary),
            ),
          ],
        ),
      );
    }
  
  }

