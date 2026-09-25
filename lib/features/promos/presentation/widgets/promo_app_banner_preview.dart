import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
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

  /// ألوان متطابقة مع تطبيق الجوال
  static const Color appPrimaryColor = Color(0xFFD32F2F);
  static const Color appGreyDarkColor = Color(0xFF616161);

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final promos = _displayedPromos;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // شريط الترويسة وأدوات التحكم في المعاينة
          _buildHeader(context, promos.length),

          // محتوى المعاينة التفاعلية القابلة للطي
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            secondChild: const SizedBox.shrink(),
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Center(
                child: ConstrainedBox(
                  // محاكاة عرض شاشة الهاتف الذكي للحفاظ على الأبعاد الواقعية
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? double.infinity : 440,
                  ),
                  child: MouseRegion(
                    onEnter: (_) {
                      setState(() => _isHovered = true);
                    },
                    onExit: (_) {
                      setState(() => _isHovered = false);
                    },
                    child: promos.isEmpty
                        ? _buildEmptyDemoBanner()
                        : _buildLiveCarousel(promos),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int totalCount) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        setState(() => _isExpanded = !_isExpanded);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: appPrimaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.smartphone_rounded,
                size: 20,
                color: appPrimaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'معاينة البانر في التطبيق',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // شارة البث المباشر مع وميض أخضر
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Live',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'هكذا يظهر سلايدر الإعلانات للمستخدمين داخل تطبيق المتجر',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // أزرار التحكم باللغة والفلترة
            if (_isExpanded) ...[
              // محول اللغة
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLanguagePill('ar', 'عربي'),
                    _buildLanguagePill('en', 'EN'),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // فلتر النشط فقط
              if (widget.promos.any((p) => !p.isActive)) ...[
                Tooltip(
                  message: _showOnlyActive
                      ? 'عرض جميع الإعلانات'
                      : 'عرض الإعلانات النشطة فقط',
                  child: IconButton.outlined(
                    iconSize: 18,
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      setState(() {
                        _showOnlyActive = !_showOnlyActive;
                        _currentIndex = 0;
                        _startAutoPlay();
                      });
                    },
                    icon: Icon(
                      _showOnlyActive
                          ? Icons.visibility_rounded
                          : Icons.visibility_outlined,
                      color: _showOnlyActive ? appPrimaryColor : null,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ],

            // زر فتح وإغلاق المعاينة
            IconButton(
              iconSize: 20,
              visualDensity: VisualDensity.compact,
              icon: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
              ),
              onPressed: () {
                setState(() => _isExpanded = !_isExpanded);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguagePill(String code, String label) {
    final isSelected = _selectedLocale == code;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedLocale = code);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? appPrimaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : null,
          ),
        ),
      ),
    );
  }

  /// كارد تجريبي يظهر عند عدم وجود إعلانات بعد
  Widget _buildEmptyDemoBanner() {
    final demoPromo = PromoEntity(
      id: 'demo',
      title: const {
        'ar': 'إعلان ترويجي تجريبي',
        'en': 'Special Demo Offer',
      },
      subtitle: const {
        'ar': 'هكذا ستظهر إعلاناتك وبانرات العروض الحصرية داخل التطبيق',
        'en': 'Exclusive discounts & special packages for our athletes',
      },
      buttonText: const {
        'ar': 'تسوق الآن',
        'en': 'Shop Now',
      },
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
                color: appPrimaryColor,
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
          height: 170,
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
                    ? appPrimaryColor
                    : appGreyDarkColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
