import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_controller.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/availability_switch.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/category_tree_selector.dart';

class CategoryFormSheet extends StatefulWidget {
  final CategoryEntity? category;

  const CategoryFormSheet({super.key, this.category});

  @override
  State<CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends State<CategoryFormSheet> {
  final controller = Get.find<CategoriesController>();
  final _formKey = GlobalKey<FormState>();

  bool _isIdFieldEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      controller.prepareFormForEdit(widget.category!);
      _isIdFieldEnabled = false;
    } else {
      controller.clearForm();
      _isIdFieldEnabled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final res = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        left: res.defaultPadding.left,
        right: res.defaultPadding.right,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHandleBar(),
              const SizedBox(height: 20),
              _buildHeader(res),
              const SizedBox(height: 24),
              Tooltip(
                message: _isIdFieldEnabled
                    ? 'الحقل مفعل حالياً'
                    : 'انقر مرتين لتعديل الكود المعرف',
                child: GestureDetector(
                  onDoubleTap: () {
                    if (!_isIdFieldEnabled) {
                      Get.dialog(
                        ConfirmDialog(
                          title: 'فتح قفل المعرف (ID)',
                          message:
                              'تعديل المعرف قد يؤثر على الروابط المرتبطة بهذا التصنيف. هل تريد الاستمرار؟',
                          confirmText: 'تفعيل التعديل',
                          confirmColor: AppColors.primaryDark,
                          onConfirm: () {
                            setState(() => _isIdFieldEnabled = true);
                            Get.back();
                          },
                        ),
                      );
                    } else {
                      setState(() => _isIdFieldEnabled = false);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: _isIdFieldEnabled
                          ? [
                              BoxShadow(
                                color: AppColors.warning.withValues(alpha: 0.1),
                                blurRadius: 10,
                              ),
                            ]
                          : [],
                    ),
                    child: buildModernTextField(
                      controller.idController,
                      'كود التصنيف (اختياري - سيتم توليده تلقائياً)',
                      Icons.fingerprint_rounded,
                      enabled: _isIdFieldEnabled && !controller.isLoading.value,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'الاسم والوصف (بالعربي والإنجليزي)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: buildModernTextField(
                      controller.nameArController,
                      'الاسم (AR)',
                      Icons.label_important_outline_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildModernTextField(
                      controller.nameEnController,
                      'Name (EN)',
                      Icons.translate_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: buildModernTextField(
                      controller.descArController,
                      'الوصف (AR)',
                      Icons.description_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildModernTextField(
                      controller.descEnController,
                      'Description (EN)',
                      Icons.description_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => CategoryTreeSelector(
                  categories: controller.categories
                      .where((c) => c.id != widget.category?.id)
                      .toList(),
                  selectedId: controller.parentId.value.isEmpty
                      ? null
                      : controller.parentId.value,
                  onSelected: (id) => controller.parentId.value = id,
                  label: 'التصنيف الأب (اختياري)',
                ),
              ),
              const SizedBox(height: 16),
              _buildImageSection(res),
              const SizedBox(height: 32),
              AvailabilitySwitch(
                isAvailable: controller.isActive,
                title: 'التصنيف مفعل',
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandleBar() {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildHeader(ResponsiveLayout res) {
    return Row(
      children: [
        Icon(
          widget.category == null
              ? Icons.add_circle_outline
              : Icons.edit_note_rounded,
          color: AppColors.primary,
          size: 28,
        ),
        const SizedBox(width: 12),
        Text(
          widget.category == null ? 'إضافة تصنيف جديد' : 'تعديل التصنيف الحالي',
          style: TextStyle(
            fontSize: res.getTitleFontSize(),
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection(ResponsiveLayout res) {
    return Column(
      children: [
        buildModernTextField(
          controller.imageController,
          'رابط الصورة (URL)',
          Icons.link_rounded,
        ),
        if (controller.imageController.text.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildImagePreview(),
        ],
      ],
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: controller.imageController.text,
          fit: BoxFit.cover,
          placeholder: (_, _) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (_, _, _) => const Center(
            child: Icon(Icons.broken_image_outlined, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: Obx(() {
        final isLoading = controller.isLoading.value;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: isLoading
                  ? [Colors.grey, Colors.grey.shade400]
                  : [AppColors.primary, const Color(0xFF6366F1)],
            ),
            boxShadow: [
              if (!isLoading)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : _submitForm,
              borderRadius: BorderRadius.circular(18),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'حفظ وإرسال البيانات',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _submitForm() async {
    if (controller.nameArController.text.trim().isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يجب ملء حقل الاسم على الأقل',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    final categoryData = CategoryEntity(
      id: controller.idController.text.trim(),
      nameAr: controller.nameArController.text.trim(),
      nameEn: controller.nameEnController.text.trim(),
      descriptionAr: controller.descArController.text.trim(),
      descriptionEn: controller.descEnController.text.trim(),
      imageUrl: controller.imageController.text.trim(),
      isActive: controller.isActive.value,
      parentId: controller.parentId.value.isEmpty
          ? null
          : controller.parentId.value,
      icon: controller.iconController.text.trim(),
    );

    bool success;
    if (widget.category == null) {
      success = await controller.addCategory(categoryData);
    } else {
      success = await controller.updateCategory(categoryData);
    }

    if (success) Get.back();
  }
}
