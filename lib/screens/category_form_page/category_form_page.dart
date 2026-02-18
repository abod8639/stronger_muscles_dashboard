import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/categories_controller.dart';
import 'package:stronger_muscles_dashboard/models/category_model.dart';
import 'package:stronger_muscles_dashboard/models/product_model.dart';
import 'package:stronger_muscles_dashboard/screens/category_form_page/widget/gradient_background_painter.dart';
import 'package:stronger_muscles_dashboard/screens/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/screens/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/availability_switch.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/category_tree_selector.dart';

class CategoryFormPage extends StatefulWidget {
  final CategoryModel? category;

  const CategoryFormPage({super.key, this.category});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage>
    with TickerProviderStateMixin {
  final controller = Get.find<CategoriesController>();
  final _formKey = GlobalKey<FormState>();
  bool _isIdFieldEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      controller.prepareFormForEdit(widget.category!);
    } else {
      controller.clearForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final res = context.responsive;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0A0A)
          : const Color(0xFFF5F7FA),
      extendBodyBehindAppBar: true,
      appBar: BaseAppBar(title: ""), // buildAppBar(isDark),
      floatingActionButton: buildFloatingActionButton(isDark),
      body: Stack(
        children: [
          // Animated gradient background
          buildGradientBackground(isDark),

          // Form content
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + kToolbarHeight + 20,
                left: 24,
                right: 24,
                bottom: 100,
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 850),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildPageHeader(isDark),

                      const SizedBox(height: 32),

                      buildAnimatedSection(
                        delay: 100,
                        child: buildSectionTitle(
                          'المعلومات الأساسية',
                          Icons.info_outline,
                          isDark,
                        ),
                      ),

                      const SizedBox(height: 20),

                      buildAnimatedSection(
                        delay: 200,
                        child: buildGlassmorphicCard(isDark, [
                          buildIdField(isDark),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: buildModernTextField(
                                  controller.nameArController,
                                  'اسم التصنيف (بالعربي)',
                                  Icons.label_important_outline_rounded,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: buildModernTextField(
                                  controller.nameEnController,
                                  'Category Name (EN)',
                                  Icons.label_important_outline_rounded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: buildModernTextField(
                                  controller.descArController,
                                  'وصف التصنيف (بالعربي) - اختياري',
                                  Icons.description_outlined,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: buildModernTextField(
                                  controller.descEnController,
                                  'Description (EN) - Optional',
                                  Icons.description_outlined,
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),

                      const SizedBox(height: 40),

                      buildAnimatedSection(
                        delay: 250,
                        child: buildSectionTitle(
                          'التصنيف الأب',
                          Icons.account_tree_outlined,
                          isDark,
                        ),
                      ),

                      const SizedBox(height: 20),

                      buildAnimatedSection(
                        delay: 280,
                        child: buildGlassmorphicCard(isDark, [
                          Obx(() => CategoryTreeSelector(
                                categories: controller.categories,
                                selectedId: controller.parentId.value,
                                onSelected: (id) =>
                                    controller.parentId.value = id,
                                label: 'اختر التصنيف الرئيسي (اختياري)',
                              )),
                        ]),
                      ),

                      const SizedBox(height: 40),

                      buildAnimatedSection(
                        delay: 300,
                        child: buildSectionTitle(
                          'الوسائط والحالة',
                          Icons.image_outlined,
                          isDark,
                        ),
                      ),

                      const SizedBox(height: 20),

                      buildAnimatedSection(
                        delay: 400,
                        child: buildGlassmorphicCard(isDark, [
                          buildEnhancedImageSection(isDark, res),
                          const SizedBox(height: 24),
                          buildDivider(isDark),
                          const SizedBox(height: 24),
                          buildStatusSection(isDark),
                        ]),
                      ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGradientBackground(bool isDark) {
    return Positioned.fill(
      child: CustomPaint(painter: GradientBackgroundPainter(isDark: isDark)),
    );
  }

  Widget buildPageHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.2),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                widget.category == null
                    ? Icons.add_business_rounded
                    : Icons.edit_rounded,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.category == null ? 'تصنيف جديد' : 'تعديل التصنيف',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.category == null
                        ? 'أضف تصنيف جديد لتنظيم منتجاتك بشكل أفضل'
                        : 'قم بتحديث معلومات التصنيف',
                    style: TextStyle(
                      fontSize: 14,
                      color: (isDark ? Colors.white : Colors.black).withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildAnimatedSection({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  Widget buildSectionTitle(String title, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGlassmorphicCard(bool isDark, List<Widget> children) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
  // --- داخل _CategoryFormPageState ---

  Widget buildIdField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 8),
          child: Text(
            "معرف النظام الفريد",
            style: TextStyle(
              fontSize: 12,
              color: _isIdFieldEnabled ? AppColors.warning : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: () => _toggleIdLock(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut, // حركة مطاطية عند فتح القفل
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _isIdFieldEnabled
                  ? AppColors.warning.withValues(alpha: 0.05)
                  : (isDark ? Colors.white10 : Colors.grey[100]),
              border: Border.all(
                color: _isIdFieldEnabled
                    ? AppColors.warning
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                buildModernTextField(
                  controller.idController,
                  'ID: e.g. supplements_creatine',
                  Icons.terminal_rounded, // أيقونة تقنية أكثر
                  enabled: _isIdFieldEnabled && !controller.isLoading.value,
                ),
                Positioned(
                  right: 16,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      _isIdFieldEnabled
                          ? Icons.lock_open_rounded
                          : Icons.lock_outline_rounded,
                      key: ValueKey(_isIdFieldEnabled),
                      size: 20,
                      color: _isIdFieldEnabled
                          ? AppColors.warning
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- تحسين معاينة الصورة ---
  Widget buildEnhancedImagePreview(bool isDark) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ), // عدم تمدد الصورة بشكل مفرط في الويب
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: -10,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: controller.imageController.text,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => _buildImageShimmer(isDark),
                    errorWidget: (_, _, _) => buildErrorWidget(isDark),
                  ),
                ),
              ),
            ),
            // أزرار التحكم الطافية
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMiniIconButton(
                      Icons.refresh_rounded,
                      Colors.blue,
                      () => setState(() {}),
                    ),
                    const SizedBox(width: 4),
                    _buildMiniIconButton(
                      Icons.delete_sweep_rounded,
                      Colors.redAccent,
                      () {
                        controller.imageController.clear();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniIconButton(IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }

  Widget buildEnhancedImageSection(bool isDark, ResponsiveLayout res) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'صورة التصنيف',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        buildModernTextField(
          controller.imageController,
          'رابط الصورة (URL)',
          Icons.link_rounded,
        ),
        const SizedBox(height: 20),
        ValueListenableBuilder(
          valueListenable: controller.imageController,
          builder: (context, value, child) {
            if (controller.imageController.text.isEmpty) {
              return buildEnhancedImagePlaceholder(isDark);
            }
            return buildEnhancedImagePreview(isDark);
          },
        ),
      ],
    );
  }

  Widget buildEnhancedImagePlaceholder(bool isDark) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.white.withValues(alpha: 0.05), Colors.white.withValues(alpha: 0.02)]
              : [Colors.grey.withValues(alpha: 0.1), Colors.grey.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.grey).withValues(alpha: 0.2),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_photo_alternate_outlined,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'قم بإدخال رابط الصورة أعلاه',
            style: TextStyle(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.5),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'سيتم عرض المعاينة هنا',
            style: TextStyle(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, size: 20, color: color),
          ),
        ),
      ),
    );
  }

  Widget buildShimmerPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildErrorWidget(bool isDark) {
    return Container(
      color: isDark ? Colors.grey[900] : Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 64,
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'فشل تحميل الصورة',
            style: TextStyle(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تحقق من الرابط وحاول مرة أخرى',
            style: TextStyle(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.toggle_on_outlined, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'حالة التصنيف',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AvailabilitySwitch(
          isAvailable: controller.isActive,
          title: 'تفعيل التصنيف في المتجر',
        ),
      ],
    );
  }

  Widget buildDivider(bool isDark) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildImageShimmer(bool isDark) {
    // الألوان المختارة لتعطي إيحاء "المعدن السائل" أو النبض التقني
    final baseColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.grey[300]!;
    final highlightColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.grey[100]!;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // استخدام TweenAnimationBuilder لعمل حركة لمعان مخصصة بدون حزم خارجية
              TweenAnimationBuilder<double>(
                tween: Tween(begin: -1.0, end: 2.0),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeInOutSine,
                onEnd: () {}, // سنستخدم شيمر خارجي أو نكرر الحركة
                builder: (context, value, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(value - 0.5, -0.3),
                        end: Alignment(value, 0.3),
                        colors: [
                          Colors.transparent,
                          highlightColor,
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  );
                },
              ),

              // إضافة أيقونة في المنتصف تعطي إيحاء "جاري التحميل" بشكل هادئ
              Center(
                child: Opacity(
                  opacity: 0.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_download_outlined,
                        size: 40,
                        color: isDark ? Colors.white24 : Colors.black26,
                      ),
                      const SizedBox(height: 12),
                      // شريط صغير تحت الأيقونة
                      Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildFloatingActionButton(bool isDark) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        width: isLoading ? 70 : 180, // يتحول لدائرة عند التحميل
        height: 60,
        child: FloatingActionButton.extended(
          onPressed: isLoading ? null : _submitForm,
          backgroundColor: isLoading ? Colors.grey[800] : AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          label: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  "حفظ البيانات",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
          icon: isLoading
              ? null
              : const Icon(Icons.send_rounded, color: Colors.white),
        ),
      );
    });
  }

  void _toggleIdLock() {
    if (!_isIdFieldEnabled && widget.category != null) {
      Get.dialog(
        ConfirmDialog(
          title: '⚠️ تنبيه الأمان',
          message:
              'تعديل المعرف (ID) قد يؤدي إلى:\n• كسر الروابط القديمة\n• مشاكل في قاعدة البيانات\n• فقدان البيانات المرتبطة\n\nهل أنت متأكد من المتابعة؟',
          confirmText: 'نعم، فك القفل',
          onConfirm: () {
            setState(() => _isIdFieldEnabled = true);
            HapticFeedback.mediumImpact();
            Get.back();
          },
        ),
      );
    } else {
      setState(() => _isIdFieldEnabled = !_isIdFieldEnabled);

      HapticFeedback.lightImpact();
    }
  }

  void _submitForm() async {
    // Validate required fields
    if (controller.idController.text.trim().isEmpty) {
      _showErrorSnackbar('المعرف الفريد مطلوب');
      return;
    }

    if (controller.nameArController.text.trim().isEmpty &&
        controller.nameEnController.text.trim().isEmpty) {
      _showErrorSnackbar('اسم التصنيف مطلوب (عربي أو إنجليزي)');
      return;
    }

    // Validate ID format (alphanumeric and underscores only)
    // final idRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    // if (!idRegex.hasMatch(controller.idController.text.trim())) {
    //   _showErrorSnackbar('المعرف يجب أن يحتوي على أحرف وأرقام فقط');
    //   return;
    // }

    HapticFeedback.mediumImpact();

    final categoryData = CategoryModel(
      id: controller.idController.text.trim(),
      name: TranslatableString(
        ar: controller.nameArController.text.trim(),
        en: controller.nameEnController.text.trim(),
      ),
      imageUrl: controller.imageController.text.trim(),
      description: TranslatableString(
        ar: controller.descArController.text.trim(),
        en: controller.descEnController.text.trim(),
      ),
      isActive: controller.isActive.value,
      icon: controller.iconController.text.trim(),
      parentId: controller.parentId.value,
    );

    bool success = widget.category == null
        ? await controller.addCategory(categoryData)
        : await controller.updateCategory(categoryData);

    if (success) {
      HapticFeedback.heavyImpact();
      Get.back();
      Get.snackbar(
        'نجح',
        widget.category == null
            ? 'تم إضافة التصنيف بنجاح'
            : 'تم تحديث التصنيف بنجاح',
        backgroundColor: Colors.greenAccent[400],
        colorText: Colors.black,
        icon: const Icon(Icons.check_circle_rounded, color: Colors.black),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _showErrorSnackbar(String message) {
    HapticFeedback.vibrate();
    Get.snackbar(
      'خطأ',
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
    );
  }
}
