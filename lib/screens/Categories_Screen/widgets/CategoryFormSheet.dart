
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/controllers/categories_controller.dart';
import 'package:stronger_muscles_dashboard/models/category.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/screens/widgets/buildModernTextField.dart';

class CategoryFormSheet extends StatefulWidget {
  final CategoriesController controller;
  final CategoryModel? category;

  const CategoryFormSheet({super.key, 
    required this.controller,
    this.category,
  });

  @override
  State<CategoryFormSheet> createState() => CategoryFormSheetState();
}

class CategoryFormSheetState extends State<CategoryFormSheet> {
  late final TextEditingController idController;
  late final TextEditingController nameController;
  late final TextEditingController imageController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.category?.id ?? '');
    nameController = TextEditingController(text: widget.category?.name ?? '');
    imageController = TextEditingController(text: widget.category?.imageUrl ?? '');
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: padding.left,
        right: padding.right,
        bottom: MediaQuery.of(context).viewInsets.bottom + padding.bottom,
        top: padding.top,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // مؤشر الجرجرة
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: padding.top),

          // العنوان
          Text(
            widget.category == null ? '✨ إضافة تصنيف جديد' : '✏️ تعديل التصنيف',
            style: TextStyle(
              fontSize: responsive.getTitleFontSize() + 2,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: padding.top),

          // الحقول
          buildCategoryFormSheetModernTextField(
            idController,
            'كود التصنيف (ID)',
            Icons.fingerprint_rounded,
            enabled: widget.category == null,
          ),
          SizedBox(height: padding.top),
          
          buildCategoryFormSheetModernTextField(
            enabled: true,
            nameController,
            'اسم التصنيف',
            Icons.label_outline_rounded,
          ),
          SizedBox(height: padding.top),
          
          buildCategoryFormSheetModernTextField(
            enabled: true,
            imageController,
            'رابط الصورة',
            Icons.image_outlined,
          ),
          SizedBox(height: padding.top * 2),

          // زر الحفظ
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _submitForm,
                  borderRadius: BorderRadius.circular(14),
                  child: Obx(
                    () => widget.controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          )
                        : const Center(
                            child: Text(
                              'حفظ التصنيف',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (idController.text.isEmpty || nameController.text.isEmpty) {
      Get.snackbar('تنبیه', 'يرجى ملء الكود والاسم');
      return;
    }

    if (widget.category == null) {
      widget.controller.addCategory(idController.text, nameController.text, imageController.text);
    } else {
      widget.controller.updateCategory(widget.category!.id, nameController.text, imageController.text);
    }
  }
}
