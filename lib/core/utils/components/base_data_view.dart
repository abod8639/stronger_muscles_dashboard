import 'dart:math';
import 'package:flutter/material.dart';
import '../../../config/responsive.dart';

/// مكون عرض البيانات العام بأسلوب Neumorphism / Soft UI
class BaseDataView<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final VoidCallback? onSeeAll;
  final int? showCount;

  final int? crossAxisCount;
  final double? mainAxisExtent;
  final double? childAspectRatio;
  final bool useListView;

  const BaseDataView({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.onSeeAll,
    this.crossAxisCount,
    this.mainAxisExtent,
    this.childAspectRatio,
    this.useListView = false,
    this.showCount,
  });

  int get _displayCount =>
      showCount != null ? min(showCount!, items.length) : items.length;

  List<T> get _displayItems => items.take(_displayCount).toList();

  @override
  Widget build(BuildContext context) {
    final res = ResponsiveLayout(context);

    final int effectiveCrossAxisCount =
        crossAxisCount ?? (res.isMobile ? 1 : res.getGridColumns());

    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: res.defaultPadding.left),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, res),
            _NeumorphicEmptyView(title: title),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, res),
        useListView
            ? _buildListView(res)
            : _buildGridView(res, effectiveCrossAxisCount, res.itemSpacing),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ResponsiveLayout res) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: res.defaultPadding.left,
        vertical: res.defaultPadding.top / 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: res.getTitleFontSize(),
                  color: colorScheme.onSurface,
                  letterSpacing: 0.3,
                ),
              ),
              if (items.isNotEmpty) ...[
                const SizedBox(width: 10),
                _NeumorphicCountBadge(count: items.length),
              ],
            ],
          ),
          if (onSeeAll != null &&
              (showCount == null || items.length > showCount!))
            _NeumorphicSeeAllButton(
              onTap: onSeeAll!,
              fontSize: res.getBodyFontSize() - 1,
            ),
        ],
      ),
    );
  }

  Widget _buildListView(ResponsiveLayout res) {
    final displayList = _displayItems;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayList.length,
      padding: EdgeInsets.symmetric(horizontal: res.defaultPadding.left),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: itemBuilder(context, displayList[index], index),
      ),
    );
  }

  Widget _buildGridView(ResponsiveLayout res, int columns, double spacing) {
    final displayList = _displayItems;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: res.defaultPadding.left,
        vertical: spacing / 2,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        mainAxisExtent: mainAxisExtent,
        childAspectRatio: childAspectRatio ?? res.getCardAspectRatio(),
      ),
      itemCount: displayList.length,
      itemBuilder: (context, index) =>
          itemBuilder(context, displayList[index], index),
    );
  }
}

/// زر "عرض الكل" بتصميم ناعم ومجسم مع استجابة ملموسة عند التفاعل
class _NeumorphicSeeAllButton extends StatefulWidget {
  final VoidCallback onTap;
  final double fontSize;

  const _NeumorphicSeeAllButton({
    required this.onTap,
    required this.fontSize,
  });

  @override
  State<_NeumorphicSeeAllButton> createState() => _NeumorphicSeeAllButtonState();
}

class _NeumorphicSeeAllButtonState extends State<_NeumorphicSeeAllButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isPressed
                  ? (isDark
                      ? [
                          Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.15)!,
                          Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
                        ]
                      : [
                          Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.06)!,
                          Colors.white,
                        ])
                  : (isDark
                      ? [
                          Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, _isHovered ? 0.06 : 0.03)!,
                          Color.lerp(colorScheme.surfaceContainer, Colors.black, _isHovered ? 0.05 : 0.1)!,
                        ]
                      : [
                          Color.lerp(colorScheme.surfaceContainer, Colors.white, _isHovered ? 0.8 : 0.6)!,
                          Color.lerp(colorScheme.surfaceContainer, Colors.black, _isHovered ? 0.01 : 0.03)!,
                        ]),
            ),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: _isHovered ? 0.55 : 0.45)
                          : const Color(0xFFA3B1C6).withValues(alpha: _isHovered ? 0.5 : 0.38),
                      offset: const Offset(2.5, 3),
                      blurRadius: _isHovered ? 7 : 5,
                    ),
                    BoxShadow(
                      color: isDark
                          ? Colors.white.withValues(alpha: _isHovered ? 0.06 : 0.04)
                          : Colors.white.withValues(alpha: _isHovered ? 1.0 : 0.9),
                      offset: const Offset(-2, -2),
                      blurRadius: _isHovered ? 6 : 4,
                    ),
                  ],
            border: Border.all(
              color: isDark
                  ? (_isHovered
                      ? colorScheme.primary.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.06))
                  : (_isHovered
                      ? colorScheme.primary.withValues(alpha: 0.35)
                      : Colors.white.withValues(alpha: 0.8)),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'عرض الكل',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: widget.fontSize,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: widget.fontSize - 1,
                color: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// شارة مجسمة لعرض عدد العناصر
class _NeumorphicCountBadge extends StatelessWidget {
  final int count;

  const _NeumorphicCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainerHighest, Colors.white, 0.04)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.12)!,
                ]
              : [
                  Colors.white,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.05)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.3),
            offset: const Offset(1.5, 2),
            blurRadius: 3,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.white.withValues(alpha: 0.8),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 3,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.8),
          width: 1.0,
        ),
      ),
      child: Text(
        '$count',
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}

/// واجهة الحالة الفارغة بأسلوب Soft UI
class _NeumorphicEmptyView extends StatelessWidget {
  final String title;

  const _NeumorphicEmptyView({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.02)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.08)!,
                ]
              : [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.5)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.03)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.45)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
            offset: const Offset(4, 5),
            blurRadius: 12,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.white.withValues(alpha: 0.9),
            offset: const Offset(-3, -3),
            blurRadius: 10,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.8),
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.04)!,
                        Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.12)!,
                      ]
                    : [
                        Colors.white,
                        Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.05)!,
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.4)
                      : const Color(0xFFA3B1C6).withValues(alpha: 0.3),
                  offset: const Offset(2.5, 3),
                  blurRadius: 6,
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.white.withValues(alpha: 0.85),
                  offset: const Offset(-2, -2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.inbox_rounded,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'لا توجد $title متاحة حالياً',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
