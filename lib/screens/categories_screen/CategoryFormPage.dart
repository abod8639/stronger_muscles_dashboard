import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/categories_controller.dart';
import 'package:stronger_muscles_dashboard/models/category_model.dart';
import 'package:stronger_muscles_dashboard/screens/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/screens/components/buildModernTextField.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/availability_switch.dart';

class CategoryFormPage extends StatefulWidget {
  final CategoryModel? category;

  const CategoryFormPage({super.key, this.category});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
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

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF8F9FA),
      appBar: _buildAppBar(isDark),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800), // لجعلها مريحة في الويب والتابلت
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('المعلومات الأساسية', Icons.info_outline),
                  const SizedBox(height: 20),
                  
                  // كارت يحتوي على الحقول الأساسية
                  _buildFormCard(isDark, [
                    _buildIdField(),
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
                  ]),

                  const SizedBox(height: 32),
                  _buildSectionTitle('الوسائط والحالة', Icons.image_outlined),
                  const SizedBox(height: 20),

                  _buildFormCard(isDark, [
                    _buildImageSection(res),
                    const Divider(height: 40, thickness: 0.5),
                    AvailabilitySwitch(
                      isAvailable: controller.isActive,
                      title: 'تفعيل التصنيف في المتجر',
                    ),
                  ]),

                  const SizedBox(height: 40),
                  _buildSubmitButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      elevation: 0,
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      title: Text(
        widget.category == null ? 'إضافة تصنيف جديد' : 'تعديل التصنيف',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Get.back(),
      ),
      actions: [
        if (widget.category != null)
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            onPressed: () {
              // إضافة منطق الحذف هنا لاحقاً
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildFormCard(bool isDark, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildIdField() {
    return Tooltip(
      message: _isIdFieldEnabled ? 'الحقل مفعل' : 'انقر مرتين لفك القفل',
      child: GestureDetector(
        onDoubleTap: () {
          if (!_isIdFieldEnabled) {
            Get.dialog(ConfirmDialog(
              title: 'تنبيه الأمان',
              message: 'تعديل المعرف (ID) قد يكسر الروابط القديمة. هل أنت متأكد؟',
              confirmText: 'نعم، فك القفل',
              onConfirm: () {
                setState(() => _isIdFieldEnabled = true);
                Get.back();
              },
            ));
          } else {
            setState(() => _isIdFieldEnabled = false);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _isIdFieldEnabled ? AppColors.warning.withOpacity(0.05) : Colors.transparent,
          ),
          child: buildCategoryFormSheetModernTextField(
            controller.idController,
            'المعرف الفريد (Unique ID)',
            Icons.fingerprint_rounded,
            enabled: _isIdFieldEnabled && !controller.isLoading.value,
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(ResponsiveLayout res) {
    return Column(
      children: [
        buildCategoryFormSheetModernTextField(
          controller.imageController,
          'رابط الصورة',
          Icons.link_rounded,
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder(
          // نستخدم ValueListenableBuilder إذا كان الكنترولر يدعم أو فقط Obx
          valueListenable: controller.imageController,
          builder: (context, value, child) {
            if (controller.imageController.text.isEmpty) {
              return _buildImagePlaceholder();
            }
            return _buildImagePreview();
          },
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1), style: BorderStyle.solid),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey),
          SizedBox(height: 8),
          Text('يرجى إدخال رابط الصورة للمعاينة', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: controller.imageController.text,
              fit: BoxFit.cover,
              placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 40)),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
              onPressed: () => setState(() {}),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      return Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isLoading ? [Colors.grey, Colors.grey] : [AppColors.primary, const Color(0xFF6366F1)],
          ),
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'حفظ التغييرات',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      );
    });
  }

  void _submitForm() async {
    if (controller.idController.text.trim().isEmpty || controller.nameController.text.trim().isEmpty) {
      Get.snackbar('تنبيه', 'يرجى ملء البيانات الأساسية', 
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    final categoryData = CategoryModel(
      id: controller.idController.text.trim(),
      name: controller.nameController.text.trim(),
      imageUrl: controller.imageController.text.trim(),
      description: controller.descriptionController.text.trim(),
      isActive: controller.isActive.value,
      icon: controller.iconController.text.trim(),
    );

    bool success = widget.category == null 
        ? await controller.addCategory(categoryData) 
        : await controller.updateCategory(categoryData);

    if (success) Get.back();
  }
}