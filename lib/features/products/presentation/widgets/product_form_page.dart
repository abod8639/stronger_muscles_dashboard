import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_form_mixin.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_form_sections.dart';

/// صفحة نموذج إضافة / تعديل المنتج بتصميم Neumorphism / Soft UI
class ProductFormPage extends StatefulWidget {
  final ProductEntity? product;
  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage>
    with ProductFormMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  final ProductsController controller = Get.find<ProductsController>();

  @override
  ProductEntity? get product => widget.product;

  String? _selectedCategoryId;

  // GlobalKeys for Section Navigation
  final _basicInfoKey = GlobalKey();
  final _mediaKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _variantsKey = GlobalKey();
  final _settingsKey = GlobalKey();

  int _activeNavIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeProductFields();
    controller.imageUrls.assignAll(getInitialImageUrls());
    _selectedCategoryId = getInitialCategoryId();
  }

  @override
  void dispose() {
    disposeProductControllers();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key, int navIndex) {
    setState(() => _activeNavIndex = navIndex);
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        alignment: 0.05,
      );
    }
  }

  void _onSave() {
    controller.saveProduct(
      existingProduct: widget.product,
      formKey: _formKey,
      categoryId: _selectedCategoryId ?? '',
      productImages: controller.imageUrls.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 950;
    final isEditing = widget.product != null;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 58,
        leading: Padding(
          padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.02)!,
                        Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.08)!,
                      ]
                    : [
                        Color.lerp(colorScheme.surface, Colors.white, 0.85)!,
                        Color.lerp(colorScheme.surface, const Color(0xFFA3B1C6), 0.10)!,
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.35)
                      : const Color(0xFFA3B1C6).withValues(alpha: 0.28),
                  offset: const Offset(1.5, 2),
                  blurRadius: 3,
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.02)
                      : Colors.white.withValues(alpha: 0.90),
                  offset: const Offset(-1.5, -1.5),
                  blurRadius: 2.5,
                ),
              ],
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.white.withValues(alpha: 0.85),
                width: 1.0,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => Get.back(),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 15,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditing ? 'تعديل بيانات المنتج' : 'إضافة منتج جديد',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            if (isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        widget.product!.displayName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildSectionNavChips(theme, isDark),
        ),
      ),
      bottomNavigationBar: ProductStickyBottomBar(
        controller: controller,
        onSave: _onSave,
        isEditing: isEditing,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 32 : 16,
            vertical: 24,
          ),
          child: isWide ? _buildWideLayout() : _buildMobileLayout(),
        ),
      ),
    );
  }

  // ── شريط التنقل السريع بتصميم Neumorphism / Soft UI ─────────────────────
  Widget _buildSectionNavChips(ThemeData theme, bool isDark) {
    final colorScheme = theme.colorScheme;
    final navItems = [
      {'label': 'البيانات الأساسية', 'icon': Icons.edit_note_rounded, 'key': _basicInfoKey},
      {'label': 'الوسائط والصور', 'icon': Icons.photo_library_outlined, 'key': _mediaKey},
      {'label': 'التسعير والمخزون', 'icon': Icons.payments_outlined, 'key': _pricingKey},
      {'label': 'الأحجام والتنويعات', 'icon': Icons.tune_rounded, 'key': _variantsKey},
      {'label': 'إعدادات النشر', 'icon': Icons.toggle_on_outlined, 'key': _settingsKey},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Color.lerp(colorScheme.surface, Colors.black, 0.12)!
            : Color.lerp(colorScheme.surface, const Color(0xFFA3B1C6), 0.06)!,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.20),
            width: 1.0,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(navItems.length, (index) {
            final item = navItems[index];
            final isActive = _activeNavIndex == index;
            final key = item['key'] as GlobalKey;

            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _buildNeumorphicChip(
                label: item['label'] as String,
                icon: item['icon'] as IconData,
                isActive: isActive,
                isDark: isDark,
                colorScheme: colorScheme,
                onTap: () => _scrollToSection(key, index),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNeumorphicChip({
    required String label,
    required IconData icon,
    required bool isActive,
    required bool isDark,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isActive
              ? (isDark
                  ? [
                      Color.lerp(colorScheme.primaryContainer, Colors.white, 0.02)!,
                      Color.lerp(colorScheme.surfaceContainer, colorScheme.primary, 0.16)!,
                    ]
                  : [
                      Color.lerp(colorScheme.primaryContainer, Colors.white, 0.45)!,
                      Color.lerp(colorScheme.primaryContainer, Colors.black, 0.02)!,
                    ])
              : (isDark
                  ? [
                      Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.02)!,
                      Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.06)!,
                    ]
                  : [
                      Color.lerp(colorScheme.surface, Colors.white, 0.85)!,
                      Color.lerp(colorScheme.surface, const Color(0xFFA3B1C6), 0.08)!,
                    ]),
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: isDark
                      ? colorScheme.primary.withValues(alpha: 0.25)
                      : colorScheme.primary.withValues(alpha: 0.20),
                  offset: const Offset(1.5, 2),
                  blurRadius: 3,
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.02)
                      : Colors.white.withValues(alpha: 0.90),
                  offset: const Offset(-1.5, -1.5),
                  blurRadius: 2.5,
                ),
              ]
            : [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.35)
                      : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
                  offset: const Offset(1.5, 2),
                  blurRadius: 3,
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.02)
                      : Colors.white.withValues(alpha: 0.90),
                  offset: const Offset(-1.5, -1.5),
                  blurRadius: 2.5,
                ),
              ],
        border: Border.all(
          color: isActive
              ? colorScheme.primary.withValues(alpha: isDark ? 0.6 : 0.7)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : Colors.white.withValues(alpha: 0.85)),
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── تخطيط الشاشات الكبيرة (Desktop / Tablet) ──────────────────────────────
  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العمود الرئيسي (بيانات أساسية + تسعير + تنويعات)
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Container(
                key: _basicInfoKey,
                child: ProductBasicInfoSection(
                  controller: controller,
                  selectedCategoryId: _selectedCategoryId,
                  onCategorySelected: (id) =>
                      setState(() => _selectedCategoryId = id),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                key: _pricingKey,
                child: ProductPricingStockSection(controller: controller),
              ),
              const SizedBox(height: 24),
              Container(
                key: _variantsKey,
                child: ProductVariantsSection(controller: controller),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
        const SizedBox(width: 24),

        // العمود الجانبي (معرض الصور + إعدادات النشر)
        SizedBox(
          width: 380,
          child: Column(
            children: [
              Container(
                key: _mediaKey,
                child: Obx(
                  () => ProductMediaSection(
                    controller: controller,
                    imageUrls: controller.imageUrls.toList(),
                    onAddImageUrl: (url) => controller.imageUrls.add(url),
                    onRemoveImage: (i) => controller.imageUrls.removeAt(i),
                    onReorderImage: (oldIdx, newIdx) {
                      final item = controller.imageUrls.removeAt(oldIdx);
                      controller.imageUrls.insert(newIdx, item);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                key: _settingsKey,
                child: ProductSettingsSection(controller: controller),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  // ── تخطيط الشاشات الصغيرة (Mobile) ─────────────────────────────────────────
  Widget _buildMobileLayout() {
    return Column(
      children: [
        Container(
          key: _mediaKey,
          child: Obx(
            () => ProductMediaSection(
              controller: controller,
              imageUrls: controller.imageUrls.toList(),
              onAddImageUrl: (url) => controller.imageUrls.add(url),
              onRemoveImage: (i) => controller.imageUrls.removeAt(i),
              onReorderImage: (oldIdx, newIdx) {
                final item = controller.imageUrls.removeAt(oldIdx);
                controller.imageUrls.insert(newIdx, item);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          key: _basicInfoKey,
          child: ProductBasicInfoSection(
            controller: controller,
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: (id) =>
                setState(() => _selectedCategoryId = id),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          key: _pricingKey,
          child: ProductPricingStockSection(controller: controller),
        ),
        const SizedBox(height: 20),
        Container(
          key: _variantsKey,
          child: ProductVariantsSection(controller: controller),
        ),
        const SizedBox(height: 20),
        Container(
          key: _settingsKey,
          child: ProductSettingsSection(controller: controller),
        ),
        const SizedBox(height: 90),
      ],
    );
  }
}
