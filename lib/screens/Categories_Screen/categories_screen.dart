import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/Categories_Screen/widgets/CategoryGridItem.dart';
import 'package:stronger_muscles_dashboard/screens/Categories_Screen/widgets/CategoryListIte.dart';
import '../../controllers/categories_controller.dart';
import '../../models/index.dart';
import '../../config/theme.dart';
import '../../config/responsive.dart';
import '../../components/index.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoriesController());
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إدارة التصنيفات',
          style: TextStyle(
            fontSize: responsive.getTitleFontSize(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showCategoryForm(context, controller),
            icon: Icon(Icons.add_circle_outline, size: responsive.iconSize),
            tooltip: 'إضافة تصنيف جديد',
          ),
          SizedBox(width: responsive.itemSpacing),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: padding,
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'ابحث عن تصنيف بالاسم أو الكود...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: padding.left,
                  vertical: padding.top / 2,
                ),
              ),
            ),
          ),

          // قائمة التصنيفات
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.categories.isEmpty) {
                return const EnhancedLoadingWidget(
                  message: 'جاري تحميل التصنيفات...',
                );
              }

              if (controller.filteredCategories.isEmpty) {
                return EnhancedErrorWidget(
                  title: 'لا توجد تصنيفات',
                  message: controller.searchQuery.isEmpty
                      ? 'لا يوجد تصنيفات متاحة حالياً'
                      : 'لم يتم العثور على نتائج للبحث',
                  icon: Icons.category_outlined,
                  onRetry: () => controller.fetchCategories(),
                );
              }

              return responsive.isMobile
                  ? ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: padding.left,
                        vertical: padding.top / 2,
                      ),
                      itemCount: controller.filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = controller.filteredCategories[index];
                        return CategoryListItem(
                          category: category,
                          onEdit: () =>
                              _showCategoryForm(context, controller, category: category),
                          onDelete: () => controller.deleteCategory(category.id),
                        );
                      },
                    )
                  : GridView.builder(
                      padding: padding,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: responsive.isTablet ? 2 : 3,
                        crossAxisSpacing: responsive.itemSpacing,
                        mainAxisSpacing: responsive.itemSpacing,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: controller.filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = controller.filteredCategories[index];
                        return CategoryGridItem(
                          category: category,
                          onEdit: () =>
                              _showCategoryForm(context, controller, category: category),
                          onDelete: () => controller.deleteCategory(category.id),
                        );
                      },
                    );
            }),
          ),
        ],
      ),
    );
  }

  void _showCategoryForm(BuildContext context, CategoriesController controller, {CategoryModel? category}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CategoryFormSheet(
        controller: controller,
        category: category,
      ),
    );
  }
}

class _CategoryFormSheet extends StatefulWidget {
  final CategoriesController controller;
  final CategoryModel? category;

  const _CategoryFormSheet({
    required this.controller,
    this.category,
  });

  @override
  State<_CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends State<_CategoryFormSheet> {
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

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.category == null ? 'إضافة تصنيف جديد' : 'تعديل التصنيف',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildTextField(idController, 'كود التصنيف (ID فريد)', Icons.fingerprint, enabled: widget.category == null),
          const SizedBox(height: 16),
          _buildTextField(nameController, 'اسم التصنيف', Icons.label_outline),
          const SizedBox(height: 16),
          _buildTextField(imageController, 'رابط الصورة (اختياري)', Icons.image_outlined),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Obx(() => widget.controller.isLoading.value 
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(widget.category == null ? 'إضافة التصنيف' : 'حفظ التغييرات')
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool enabled = true}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !enabled,
        fillColor: !enabled ? Colors.grey.withOpacity(0.1) : null,
      ),
    );
  }

  void _submitForm() {
    if (idController.text.isEmpty) {
      Get.snackbar('تنبیه', 'يرجى إدخال كود التصنيف');
      return;
    }
    if (nameController.text.isEmpty) {
      Get.snackbar('تنبیه', 'يرجى إدخال اسم التصنيف');
      return;
    }

    if (widget.category == null) {
      widget.controller.addCategory(idController.text, nameController.text, imageController.text);
    } else {
      widget.controller.updateCategory(widget.category!.id, nameController.text, imageController.text);
    }
  }
}
