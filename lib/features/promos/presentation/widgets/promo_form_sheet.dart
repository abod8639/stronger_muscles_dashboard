import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/widgets/build_text_field.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        maxHeight: MediaQuery.of(context).size.height * 0.9,
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
                  _buildImageSelection(controller),
                  const SizedBox(height: 24),
                  _buildLanguageTabs(controller),
                  const SizedBox(height: 24),
                  _buildSectionTitle('إعدادات إضافية'),
                  buildTextField(
                    icon: Icons.link,
                    label: 'رابط التوجيه (Target URL)',
                    controller: controller.targetUrlController,
                    // hint: 'مثال: /product/123 أو https://example.com',
                    // prefixIcon: Icons.link,
                  ),
                  const SizedBox(height: 16),
                 buildTextField(
                  icon: Icons.color_lens,
                    label: 'لون الخلفية (Background Color - Hex)',
                    controller: controller.backgroundColorController,
                    // hint: 'مثال: #FF0000',
                    // prefixIcon: Icons.color_lens,
                  ),
                  const SizedBox(height: 16),
                  Obx(() => SwitchListTile(
                        title: const Text('تفعيل الإعلان (Active)'),
                        value: controller.isActive.value,
                        onChanged: (val) => controller.isActive.value = val,
                        activeThumbColor: AppColorsExtended.purpleAccent,
                        contentPadding: EdgeInsets.zero,
                      )),
                  const SizedBox(height: 32),
                  Obx(() => TextButton(
                    
                     child: Text( isEditing ? 'تحديث الإعلان' : 'حفظ الإعلان'),
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.savePromo(existingPromo: promo),
                        // isLoading: controller.isLoading.value,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isEditing) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColorsExtended.greenLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [],
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
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSelection(PromosController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('صورة الإعلان'),
        GestureDetector(
          onTap: () => controller.pickImage(),
          child: Obx(() {
            return Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppColorsExtended.greenLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColorsExtended.greenAccent,
                  style: BorderStyle.solid,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _getImageWidget(controller),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _getImageWidget(PromosController controller) {
    if (controller.selectedImage.value != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            controller.selectedImage.value!,
            fit: BoxFit.cover,
          ),
          _buildImageOverlay(),
        ],
      );
    } else if (controller.existingImageUrl.value.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: controller.existingImageUrl.value,
            fit: BoxFit.cover,
          ),
          _buildImageOverlay(),
        ],
      );
    } else {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate, size: 48, color: AppColorsExtended.textSecondary),
          SizedBox(height: 8),
          Text('اختر صورة الإعلان', style: TextStyle(color: AppColorsExtended.textSecondary)),
        ],
      );
    }
  }

  Widget _buildImageOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(
        child: Icon(Icons.edit, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildLanguageTabs(PromosController controller) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('المحتوى النصي'),
          Container(
            decoration: BoxDecoration(
              color: AppColorsExtended.greenLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColorsExtended.greenAccent),
            ),
            child: const TabBar(
              indicatorColor: AppColorsExtended.cardBgLight,
              labelColor: AppColorsExtended.cardBgLight,
              unselectedLabelColor: AppColorsExtended.textSecondary,
              tabs: [
                Tab(text: 'العربية'),
                Tab(text: 'English'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280, // Fixed height for tabs content
            child: TabBarView(
              children: [
                _buildFields(
                  titleController: controller.titleArController,
                  subtitleController: controller.subtitleArController,
                  buttonController: controller.buttonArController,
                ),
                _buildFields(
                  titleController: controller.titleEnController,
                  subtitleController: controller.subtitleEnController,
                  buttonController: controller.buttonEnController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFields({
    required TextEditingController titleController,
    required TextEditingController subtitleController,
    required TextEditingController buttonController,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildTextField(
            icon: Icons.title,
            label: 'العنوان (Title)',
            controller: titleController,
          ),
          const SizedBox(height: 16),
          buildTextField(
            icon: Icons.subtitles,
            label: 'العنوان الفرعي (Subtitle)',
            controller: subtitleController,
          ),
          const SizedBox(height: 16),
          buildTextField(
            icon: Icons.smart_button_sharp,
            label: 'نص الزر (Button Text)',
            controller: buttonController,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColorsExtended.textPrimary,
        ),
      ),
    );
  }
}
