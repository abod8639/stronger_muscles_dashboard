import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_controller.dart';
import 'widget/category_basic_info_section.dart';
import 'widget/category_image_section.dart';
import 'widget/category_parent_section.dart';
import 'widget/category_save_action_card.dart';
import 'widget/category_section_card.dart';
import 'widget/category_status_section.dart';
import 'widget/category_top_banner.dart';

/// صفحة إنشاء وتعديل التصنيفات المحدثة بالكامل بنمط Material Design 3
/// وبتنظيم تركيبي معياري متجاوب مع جميع أحجام الشاشات.
class CategoryFormPage extends StatefulWidget {
  final CategoryEntity? category;

  const CategoryFormPage({super.key, this.category});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  late final CategoriesController controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = Get.find<CategoriesController>();
    if (widget.category != null) {
      controller.prepareFormForEdit(widget.category!);
    } else {
      controller.clearForm();
    }
  }

  void _submitForm() async {
    // 1. التحقق من صحة المدخلات
    if (controller.idController.text.trim().isEmpty) {
      _showSnackbar('المعرف الفريد (System ID) مطلوب', isError: true);
      return;
    }

    if (controller.nameArController.text.trim().isEmpty &&
        controller.nameEnController.text.trim().isEmpty) {
      _showSnackbar('اسم التصنيف مطلوب (بالعربية أو بالإنجليزية)', isError: true);
      return;
    }

    HapticFeedback.mediumImpact();

    final success = await controller.saveCategory(
      existingId: widget.category?.id,
    );

    if (success) {
      HapticFeedback.heavyImpact();
      Get.back();
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    HapticFeedback.vibrate();
    final colorScheme = Theme.of(context).colorScheme;

    Get.snackbar(
      isError ? 'تنبيه' : 'تم بنجاح',
      message,
      backgroundColor: isError ? colorScheme.errorContainer : colorScheme.primaryContainer,
      colorText: isError ? colorScheme.onErrorContainer : colorScheme.onPrimaryContainer,
      icon: Icon(
        isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
        color: isError ? colorScheme.error : colorScheme.primary,
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.category != null;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth >= 960;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: BaseAppBar(
        title: isEditing ? 'تعديل التصنيف' : 'تصنيف جديد',
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
                      onPressed: _submitForm,
                      icon: Icon(
                        isEditing ? Icons.save_rounded : Icons.check_circle_rounded,
                        size: 18,
                      ),
                      label: Text(isEditing ? 'حفظ' : 'إنشاء'),
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. ترويسة معلوماتية
                CategoryTopBanner(isEditing: isEditing),
                const SizedBox(height: 20),
            
                // 2. شبكة المحتوى (متجاوبة: عمودان للشاشات العريضة، عمود واحد للموبايل)
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العمود الرئيسي: البيانات الأساسية + التصنيف الأب
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            CategorySectionCard(
                              title: 'المعلومات الأساسية والمسميات',
                              icon: Icons.info_outline_rounded,
                              child: CategoryBasicInfoSection(
                                controller: controller,
                                category: widget.category,
                                isWide: true,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CategorySectionCard(
                              title: 'التبعية الهرمية (التصنيف الأب)',
                              icon: Icons.account_tree_outlined,
                              child: CategoryParentSection(
                                controller: controller,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
            
                      // العمود الجانبي: الصورة + حالة التفعيل + زر الحفظ
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            CategorySectionCard(
                              title: 'صورة وشعار التصنيف',
                              icon: Icons.image_outlined,
                              child: CategoryImageSection(
                                controller: controller,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CategorySectionCard(
                              title: 'حالة الظهور والتفعيل',
                              icon: Icons.visibility_outlined,
                              child: CategoryStatusSection(
                                controller: controller,
                              ),
                            ),
                            const SizedBox(height: 24),
                            CategorySaveActionCard(
                              controller: controller,
                              isEditing: isEditing,
                              onSave: _submitForm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  // تخطيط الشاشات الصغيرة والهواتف
                  Column(
                    children: [
                      CategorySectionCard(
                        title: 'المعلومات الأساسية والمسميات',
                        icon: Icons.info_outline_rounded,
                        child: CategoryBasicInfoSection(
                          controller: controller,
                          category: widget.category,
                          isWide: false,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CategorySectionCard(
                        title: 'التبعية الهرمية (التصنيف الأب)',
                        icon: Icons.account_tree_outlined,
                        child: CategoryParentSection(
                          controller: controller,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CategorySectionCard(
                        title: 'صورة وشعار التصنيف',
                        icon: Icons.image_outlined,
                        child: CategoryImageSection(
                          controller: controller,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CategorySectionCard(
                        title: 'حالة الظهور والتفعيل',
                        icon: Icons.visibility_outlined,
                        child: CategoryStatusSection(
                          controller: controller,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CategorySaveActionCard(
                        controller: controller,
                        isEditing: isEditing,
                        onSave: _submitForm,
                      ),
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
