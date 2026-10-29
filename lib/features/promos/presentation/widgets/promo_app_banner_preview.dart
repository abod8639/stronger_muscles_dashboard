import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/icon_card_with_shadow.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/promo_locale_toggle.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/promo_card.dart';

/// ويدجت متقدم يحاكي شكل بانر الإعلانات داخل تطبيق المتجر بنسبة 100%
/// مع إمكانية التمرير التلقائي، معاينة اللغتين العربية والإنجليزية، وتنسيق أبعاد شاشة الجوال.
class PromoAppBannerPreview extends StatefulWidget {
  final List<PromoEntity> promos;
  final ValueChanged<PromoEntity>? onPromoTap;

  const PromoAppBannerPreview({
    super.key,
    required this.promos,
    this.onPromoTap,
  });

  @override
  State<PromoAppBannerPreview> createState() => _PromoAppBannerPreviewState();
}

class _PromoAppBannerPreviewState extends State<PromoAppBannerPreview> {
  static const int _initialPage = 10000;
  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentIndex = 0;
  String _selectedLocale = 'ar';
  bool _isExpanded = true;
  bool _showOnlyActive = false;
  bool _isHovered = false;

  /// لون النقاط غير النشطة في سلايدر تطبيق المتجر
  static const Color _storeAppGreyColor = Color(0xFF616161);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(covariant PromoAppBannerPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.promos.length != widget.promos.length) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  List<PromoEntity> get _displayedPromos {
    final list = _showOnlyActive
        ? widget.promos.where((p) => p.isActive).toList()
        : widget.promos;
    return list;
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    final promos = _displayedPromos;
    if (promos.length <= 1) return;

    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_pageController.hasClients || _isHovered) return;
      final nextPage = (_pageController.page?.round() ?? _initialPage) + 1;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _updateCurrentIndex(int index, int length) {
    if (length == 0) return;
    setState(() {
      _currentIndex = index % length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final promos = _displayedPromos;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    return SoftSurface(
      margin: const EdgeInsets.only(bottom: AppDesignTokens.space16),
      child: ClipRRect(
        borderRadius: AppDesignTokens.radiusLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              secondChild: const SizedBox.shrink(),
              firstChild: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Column(
                  children: [
                    _buildControls(),
                    const SizedBox(height: AppDesignTokens.space12),
                    Center(
                      child: ConstrainedBox(
                        // محاكاة عرض شاشة الهاتف للحفاظ على الأبعاد الواقعية
                        constraints: BoxConstraints(
                          maxWidth: isMobile ? double.infinity : 440,
                        ),
                        child: MouseRegion(
                          onEnter: (_) => setState(() => _isHovered = true),
                          onExit: (_) => setState(() => _isHovered = false),
                          child: promos.isEmpty
                              ? _buildEmptyDemoBanner()
                              : _buildLiveCarousel(promos),
                        ),
                      ),
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

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const IconCardWithShadow(
              icon: Icons.smartphone_rounded,
              size: 20,
              iconColor: kStoreAppPrimaryColor,
            ),
            const SizedBox(width: AppDesignTokens.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppDesignTokens.space8,
                    runSpacing: AppDesignTokens.space4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'معاينة البانر في التطبيق',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const InfoPill(
                        label: 'مباشر',
                        icon: Icons.fiber_manual_record_rounded,
                        color: AppColors.success,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDesignTokens.space2),
                  Text(
                    'هكذا يظهر سلايدر الإعلانات للمستخدمين داخل تطبيق المتجر',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: _isExpanded ? 'طي المعاينة' : 'عرض المعاينة',
              icon: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
              ),
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
            ),
          ],
        ),
      ),
    );
  }

  /// لغة المعاينة + فلتر الإعلانات النشطة
  Widget _buildControls() {
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppDesignTokens.space8,
      runSpacing: AppDesignTokens.space8,
      children: [
        if (widget.promos.any((p) => !p.isActive))
          FilterChip(
            label: const Text('النشطة فقط'),
            selected: _showOnlyActive,
            onSelected: (value) => setState(() {
              _showOnlyActive = value;
              _currentIndex = 0;
              _startAutoPlay();
            }),
          ),
        PromoLocaleToggle(
          locale: _selectedLocale,
          onChanged: (locale) => setState(() => _selectedLocale = locale),
        ),
      ],
    );
  }

  /// كارد تجريبي يظهر عند عدم وجود إعلانات بعد
  Widget _buildEmptyDemoBanner() {
    final demoPromo = PromoEntity(
      id: 'demo',
      title: const {'ar': 'إعلان ترويجي تجريبي', 'en': 'Special Demo Offer'},
      subtitle: const {
        'ar': 'هكذا ستظهر إعلاناتك وبانرات العروض الحصرية داخل التطبيق',
        'en': 'Exclusive discounts & special packages for our athletes',
      },
      buttonText: const {'ar': 'تسوق الآن', 'en': 'Shop Now'},
      imageUrl: '',
      backgroundColor: '#1E1E22',
      targetType: 'product',
      targetId: 'demo-target',
      isActive: true,
    );

    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PromoCard(
            promo: demoPromo,
            locale: _selectedLocale,
            margin: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 5,
              width: 15,
              decoration: BoxDecoration(
                color: kStoreAppPrimaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// سلايدر المعاينة المباشر المتطابق 100% مع تطبيق الجوال
  Widget _buildLiveCarousel(List<PromoEntity> promos) {
    final isMultiItem = promos.length > 1;

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            allowImplicitScrolling: false,
            pageSnapping: true,
            controller: _pageController,
            onPageChanged: (index) => _updateCurrentIndex(index, promos.length),
            itemBuilder: (context, index) {
              final promo = promos[index % promos.length];
              return Tooltip(
                message: 'انقر لتعديل هذا الإعلان',
                waitDuration: const Duration(milliseconds: 600),
                child: PromoCard(
                  promo: promo,
                  locale: _selectedLocale,
                  margin: isMultiItem
                      ? const EdgeInsets.symmetric(horizontal: 6)
                      : EdgeInsets.zero,
                  onTap: () {
                    if (widget.onPromoTap != null) {
                      widget.onPromoTap!(promo);
                    }
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            promos.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 5,
              width: _currentIndex == index ? 15 : 5,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? kStoreAppPrimaryColor
                    : _storeAppGreyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
