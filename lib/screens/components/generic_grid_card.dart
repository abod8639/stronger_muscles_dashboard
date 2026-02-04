import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class GenericGridCard<T> extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final Widget? imageWidget;
  final Widget? statusWidget;
  final List<Widget>? actions;
  final VoidCallback? onTap;
  final T? data;
  final Color? baseColor;
  final IconData? icon;

  const GenericGridCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.imageWidget,
    this.statusWidget,
    this.actions,
    this.onTap,
    this.data,
    this.baseColor,
    this.icon,
  });

  @override
  State<GenericGridCard<T>> createState() => _GenericGridCardState<T>();
}

class _GenericGridCardState<T> extends State<GenericGridCard<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveLayout(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: _isHovered ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.imageUrl!,
                          fit: BoxFit.cover,
                          cacheManager: CustomCacheManager.instance,
                          errorWidget: (_, __, ___) => _buildPlaceholder(isDark),
                          placeholder: (_, __) => _buildPlaceholder(isDark),
                        )
                      : widget.imageWidget ?? _buildPlaceholder(isDark),
                ),

                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null)
                        Icon(
                          widget.icon,
                          color: Colors.white,
                          size: responsive.largeIconSize - 4,
                        ),
                      if (widget.icon != null) const SizedBox(height: 8),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.getBodyFontSize() + 1,
                        ),
                      ),
                      if (widget.subtitle != null) ...[
                         const SizedBox(height: 2),
                         Text(
                            widget.subtitle!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                         ),
                      ],
                      if (widget.statusWidget != null) ...[
                        const SizedBox(height: 4),
                        widget.statusWidget!,
                      ],
                    ],
                  ),
                ),

                // Actions (Delete/Edit) - Show on Hover or Mobile
                if ((_isHovered || responsive.isMobile) && widget.actions != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.actions!.map((action) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Material(
                            color: Colors.black.withValues(alpha: 0.3),
                            shape: const CircleBorder(),
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child: action,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (widget.baseColor ?? AppColors.primary).withValues(alpha: 0.8),
            AppColors.warning.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white.withValues(alpha: 0.5),
          size: 40,
        ),
      ),
    );
  }
}
