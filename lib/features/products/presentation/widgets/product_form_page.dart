import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_form_mixin.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_form_sections.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 950;
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'تعديل بيانات المنتج' : 'إضافة منتج جديد',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isEditing)
              Text(
                widget.product!.displayName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _buildSectionNavChips(theme),
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

  // ── شريط التنقل السريع وفق معايير Material 3 (FilterChip) ─────────────────────
  Widget _buildSectionNavChips(ThemeData theme) {
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
        color: colorScheme.surfaceContainer,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(navItems.length, (index) {
            final item = navItems[index];
            final isActive = _activeNavIndex == index;
            final key = item['key'] as GlobalKey;

            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: FilterChip(
                selected: isActive,
                avatar: Icon(
                  item['icon'] as IconData,
                  size: 16,
                ),
                label: Text(item['label'] as String),
                onSelected: (_) => _scrollToSection(key, index),
              ),
            );
          }),
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
