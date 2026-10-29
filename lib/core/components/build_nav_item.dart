import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/features/navigation/navigation_feature.dart';

/// عنصر التنقل الجانبي بأسلوب Neumorphism / Soft UI مدعوم بالكامل بـ Riverpod
class NavItemTile extends ConsumerStatefulWidget {
  final bool isDrawer;
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItemTile({
    super.key,
    required this.isDrawer,
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  @override
  ConsumerState<NavItemTile> createState() => _NavItemTileState();
}

class _NavItemTileState extends ConsumerState<NavItemTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currentIndex = ref.watch(currentNavigationIndexProvider);
    final isSelected = currentIndex == widget.index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              ref
                  .read(navigationControllerProvider.notifier)
                  .selectTab(widget.index);
              if (widget.isDrawer) {
                Navigator.of(context).pop();
              }
            },
            borderRadius: BorderRadius.circular(16),
            splashColor: colorScheme.primary.withValues(alpha: 0.08),
            highlightColor: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                Color.lerp(
                                  colorScheme.surfaceContainerHigh,
                                  Colors.white,
                                  0.04,
                                )!,
                                Color.lerp(
                                  colorScheme.surfaceContainer,
                                  Colors.black,
                                  0.1,
                                )!,
                              ]
                            : [
                                Colors.white,
                                Color.lerp(
                                  colorScheme.surfaceContainer,
                                  Colors.black,
                                  0.03,
                                )!,
                              ],
                      )
                    : (_isHovered
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [
                                      Color.lerp(
                                        colorScheme.surfaceContainer,
                                        Colors.white,
                                        0.02,
                                      )!,
                                      colorScheme.surfaceContainer,
                                    ]
                                  : [
                                      Colors.white.withValues(alpha: 0.6),
                                      colorScheme.surfaceContainer,
                                    ],
                            )
                          : null),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.45)
                              : const Color(0xFFA3B1C6).withValues(alpha: 0.4),
                          offset: const Offset(3, 4),
                          blurRadius: 7,
                        ),
                        BoxShadow(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.white.withValues(alpha: 0.9),
                          offset: const Offset(-2, -2),
                          blurRadius: 5,
                        ),
                      ]
                    : (_isHovered
                          ? [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withValues(alpha: 0.25)
                                    : const Color(
                                        0xFFA3B1C6,
                                      ).withValues(alpha: 0.2),
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ]
                          : null),
                border: isSelected
                    ? Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white.withValues(alpha: 0.8),
                        width: 1.0,
                      )
                    : (_isHovered
                          ? Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.03)
                                  : Colors.black.withValues(alpha: 0.04),
                              width: 1.0,
                            )
                          : null),
              ),
              child: Row(
                children: [
                  if (isSelected) ...[
                    Container(
                      width: 3.5,
                      height: 16,
                      margin: const EdgeInsets.only(right: 10),
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
                  ],
                  Icon(
                    isSelected ? widget.activeIcon : widget.icon,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
