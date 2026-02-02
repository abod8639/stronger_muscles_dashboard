import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stronger_muscles_dashboard/screens/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/controllers/categories_controller.dart';
import 'package:stronger_muscles_dashboard/models/category_model.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/screens/components/buildModernTextField.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/availability_switch.dart';

class CategoryFormSheet extends StatefulWidget {
  final CategoryModel? category;

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

              // حقل الـ ID مع حماية متقدمة وتجربة مستخدم محسنة
              Tooltip(
                message: _isIdFieldEnabled
                    ? 'الحقل مفعل حالياً'
                    : 'انقر مرتين لتعديل الكود المعرف',
                child: GestureDetector(
                  onDoubleTap: () {
                    // إذا كان الحقل مغلقاً، نطلب التأكيد لتفعيله
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
                            Get.back(); // إغلاق الحوار
                          },
                        ),
                      );
                    } else {
                      // إذا كان مفعلاً، نقوم بقفله فوراً دون الحاجة لحوار تأكيد
                      setState(() => _isIdFieldEnabled = false);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // إضافة وميض بسيط أو ظل خفيف عندما يكون الحقل مفعلاً للتنبيه
                      boxShadow: _isIdFieldEnabled
                          ? [
                              BoxShadow(
                                color: AppColors.warning.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ]
                          : [],
                    ),
                    child: buildCategoryFormSheetModernTextField(
                      controller.idController,
                      'كود التصنيف (Unique ID)',
                      Icons.fingerprint_rounded,
                      // الحقل يكون مفعلاً فقط إذا تحقق الشرطان
                      enabled: _isIdFieldEnabled && !controller.isLoading.value,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              buildCategoryFormSheetModernTextField(
                controller.nameController,
                'اسم التصنيف',
                Icons.label_important_outline_rounded,
              ),
              const SizedBox(height: 16),

              buildCategoryFormSheetModernTextField(
                controller.descriptionController,
                'وصف التصنيف',
                Icons.description_outlined,
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
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildHeader(var res) {
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

  Widget _buildImageSection(var res) {
    return Column(
      children: [
        buildCategoryFormSheetModernTextField(
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
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: controller.imageController.text,
          fit: BoxFit.cover,
          placeholder: (_, __) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (_, __, ___) => const Center(
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
                  color: AppColors.primary.withOpacity(0.3),
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
    if (controller.idController.text.trim().isEmpty ||
        controller.nameController.text.trim().isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يجب ملء حقل الكود والاسم على الأقل',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    bool success;
    if (widget.category == null) {
      success = await controller.addCategory(
        CategoryModel(
          id: controller.idController.text.trim(),
          name: controller.nameController.text.trim(),
          imageUrl: controller.imageController.text.trim(),
          description: controller.descriptionController.text.trim(),
          isActive: controller.isActive.value,
          icon: controller.iconController.text.trim(),
        ),
      );
    } else {
      success = await controller.updateCategory(
        CategoryModel(
          id: controller.idController.text.trim(),
          name: controller.nameController.text.trim(),
          imageUrl: controller.imageController.text.trim(),
          description: controller.descriptionController.text.trim(),
          isActive: controller.isActive.value,
          icon: controller.iconController.text.trim(),
        ),
      );
    }

    if (success) Get.back();
  }


}
