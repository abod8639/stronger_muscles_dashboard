import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/chip_item.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_providers.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_form_mixin.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_form_sections.dart';

/// قسم في نموذج المنتج: يظهر في شريط التنقل السريع وفي التخطيط
class _FormSection {
  final String label;
  final IconData icon;
  final GlobalKey key;

  /// يُستدعى في كل بناء حتى تنعكس تغييرات الحالة (مثل القسم المختار)
  final WidgetBuilder builder;

  /// يوضع في العمود الجانبي على الشاشات العريضة
  final bool isSide;

  _FormSection({
    required this.label,
    required this.icon,
    required this.builder,
    this.isSide = false,
  }) : key = GlobalKey();
}

/// صفحة نموذج إضافة / تعديل المنتج
class ProductFormPage extends ConsumerStatefulWidget {
  final ProductEntity? product;
  const ProductFormPage({super.key, this.product});

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage>
    with ProductFormMixin {
  /// العرض الذي يبدأ عنده تخطيط العمودين (رئيسي + جانبي)
  static const double _wideBreakpoint = 950;
  static const double _sideColumnWidth = 380;

  final _formKey = GlobalKey<FormState>();

  @override
  ProductsController get controller => ref.read(productsUIControllerProvider);

  @override
  ProductEntity? get product => widget.product;

  String? _selectedCategoryId;
  int _activeNavIndex = 0;
  late final List<_FormSection> _sections = _buildSections();

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = getInitialCategoryId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeProductFields();
      controller.imageUrls
        ..clear()
        ..addAll(getInitialImageUrls());
      _attachDirtyListeners();
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _onFieldChanged() {
    controller.markFormDirty();
  }

  void _attachDirtyListeners() {
    for (final c in controller.textcontrollers.values) {
      c.addListener(_onFieldChanged);
    }
  }

  void _detachDirtyListeners() {
    for (final c in controller.textcontrollers.values) {
      c.removeListener(_onFieldChanged);
    }
  }

  @override
  void dispose() {
    _detachDirtyListeners();
    disposeProductControllers();
    super.dispose();
  }

  List<_FormSection> _buildSections() {
    final ctrl = controller;
    return [
      _FormSection(
        label: 'البيانات الأساسية',
        icon: Icons.edit_note_rounded,
        builder: (_) => ProductBasicInfoSection(controller: ctrl),
      ),
      _FormSection(
        label: 'القسم والتصنيف',
        icon: Icons.category_rounded,
        builder: (_) => ProductCategorySection(
          controller: ctrl,
          selectedCategoryId: _selectedCategoryId,
          onCategorySelected: (id) {
            ctrl.markFormDirty();
            setState(() => _selectedCategoryId = id);
          },
        ),
      ),
      _FormSection(
        label: 'الوسائط والصور',
        icon: Icons.photo_library_outlined,
        isSide: true,
        builder: (_) => ListenableBuilder(
          listenable: ctrl,
          builder: (context, _) => ProductMediaSection(
            controller: ctrl,
            imageUrls: ctrl.imageUrls.toList(),
            onAddImageUrl: ctrl.addImageUrl,
            onRemoveImage: ctrl.removeImageUrl,
            onReorderImage: ctrl.reorderImageUrl,
          ),
        ),
      ),
      _FormSection(
        label: 'التسعير والمخزون',
        icon: Icons.payments_outlined,
        builder: (_) => ProductPricingStockSection(controller: ctrl),
      ),
      _FormSection(
        label: 'الأحجام والتنويعات',
        icon: Icons.tune_rounded,
        builder: (_) => ProductVariantsSection(controller: ctrl),
      ),
      _FormSection(
        label: 'إعدادات النشر',
        icon: Icons.toggle_on_outlined,
        isSide: true,
        builder: (_) => ProductSettingsSection(controller: ctrl),
      ),
    ];
  }

  void _scrollToSection(int index) {
    setState(() => _activeNavIndex = index);
    final sectionContext = _sections[index].key.currentContext;
    if (sectionContext != null) {
      Scrollable.ensureVisible(
        sectionContext,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        alignment: 0.05,
      );
    }
  }

  void _onSave() async {
    final success = await controller.saveProduct(
      existingProduct: widget.product,
      formKey: _formKey,
      categoryId: _selectedCategoryId ?? '',
      productImages: controller.imageUrls.toList(),
    );
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _showDiscardConfirmDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: colorScheme.error,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('تجاهل التغييرات؟'),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من مغادرة هذه الصفحة؟ قد تفقد كافة البيانات والتعديلات غير المحفوظة.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('البقاء في الصفحة'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('مغادرة بدون حفظ'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.watch(productsUIControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;
    final isWide = responsive.screenWidth >= _wideBreakpoint;
    final isEditing = widget.product != null;

    return PopScope(
      canPop: !ctrl.isFormDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLeave = await _showDiscardConfirmDialog(context);
        if (shouldLeave && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          scrolledUnderElevation: 0,
          leading: BackButton(
            onPressed: () async {
              if (ctrl.isFormDirty) {
                final shouldLeave = await _showDiscardConfirmDialog(context);
                if (shouldLeave && context.mounted) {
                  Navigator.of(context).pop();
                }
              } else {
                Navigator.of(context).pop();
              }
            },
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
            child: _buildSectionNav(colorScheme),
          ),
        ),
        bottomNavigationBar: ProductStickyBottomBar(
          controller: ctrl,
          onSave: _onSave,
          isEditing: isEditing,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide
                  ? AppDesignTokens.space32
                  : AppDesignTokens.space16,
              vertical: AppDesignTokens.space24,
            ),
            child: isWide ? _buildWideLayout() : _buildColumn(_sections),
          ),
        ),
      ),
    );
  }

  /// شريط التنقل السريع بين أقسام النموذج
  Widget _buildSectionNav(ColorScheme colorScheme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: SizedBox(
        height: 56,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.space16,
          ),
          itemCount: _sections.length,
          itemBuilder: (context, index) => ChipItem(
            index: index,
            label: _sections[index].label,
            icon: _sections[index].icon,
            isSelected: _activeNavIndex == index,
            onTap: () => _scrollToSection(index),
          ),
        ),
      ),
    );
  }

  /// الشاشات العريضة: عمود رئيسي + عمود جانبي (الصور والإعدادات)
  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildColumn(_sections.where((s) => !s.isSide).toList()),
        ),
        const SizedBox(width: AppDesignTokens.space24),
        SizedBox(
          width: _sideColumnWidth,
          child: _buildColumn(_sections.where((s) => s.isSide).toList()),
        ),
      ],
    );
  }

  Widget _buildColumn(List<_FormSection> sections) {
    final gap = context.isMobile
        ? AppDesignTokens.space20
        : AppDesignTokens.space24;
    return Column(
      children: [
        for (final section in sections) ...[
          KeyedSubtree(key: section.key, child: section.builder(context)),
          SizedBox(height: gap),
        ],
        // مساحة إضافية فوق الشريط السفلي الثابت
        const SizedBox(height: 64),
      ],
    );
  }
}
