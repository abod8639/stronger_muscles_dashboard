import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

/// حاوية بسطح ناعم موحد (Soft UI) مع دعم اختياري للنقر والضغط المطوّل والتلميح
/// تعتمد على [AppDesignTokens.softSurface] حتى يبقى الشكل متطابقاً في كل الشاشات
class SoftSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final SoftDepth depth;
  final bool compact;
  final bool selected;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? tooltip;

  const SoftSurface({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.depth = SoftDepth.raised,
    this.compact = false,
    this.selected = false,
    this.width,
    this.height,
    this.onTap,
    this.onLongPress,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius =
        borderRadius ??
        (compact ? AppDesignTokens.radiusSmall : AppDesignTokens.radiusLarge);

    Widget content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    if (onTap != null || onLongPress != null) {
      content = Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          onLongPress: onLongPress,
          child: content,
        ),
      );
    }

    Widget surface = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: AppDesignTokens.softSurface(
        theme.colorScheme,
        isDark: theme.brightness == Brightness.dark,
        borderRadius: radius,
        depth: depth,
        compact: compact,
        selected: selected,
      ),
      child: content,
    );

    if (tooltip != null) {
      surface = Tooltip(message: tooltip!, child: surface);
    }
    return surface;
  }
}

/// زر أيقونة صغير بسطح ناعم (تعديل، حذف، إغلاق...)
class SoftIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double size;

  const SoftIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SoftSurface(
      compact: true,
      width: size,
      height: size,
      borderRadius: AppDesignTokens.radiusSmall,
      tooltip: tooltip,
      onTap: onPressed,
      child: Center(
        child: Icon(
          icon,
          size: size / 2,
          color: onPressed == null
              ? colorScheme.onSurface.withValues(alpha: 0.38)
              : (color ?? colorScheme.onSurface),
        ),
      ),
    );
  }
}
