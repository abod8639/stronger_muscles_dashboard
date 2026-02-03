import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';
import 'glass_container.dart';

class GenericListTile<T> extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget? subtitleWidget; // For more complex subtitles (e.g. Price + Stock)
  final String? imageUrl;
  final Widget? imageWidget; // Custom image widget if needed (e.g. Icon)
  final List<Widget>? tags;
  final Widget? statusWidget;
  final List<Widget>? actions;
  final VoidCallback? onTap;
  final T? data;
  final double? height;
  final Color? baseColor;
  final bool isSelected;

  const GenericListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleWidget,
    this.imageUrl,
    this.imageWidget,
    this.tags,
    this.statusWidget,
    this.actions,
    this.onTap,
    this.data,
    this.height,
    this.baseColor,
    this.isSelected = false,
  });

  @override
  State<GenericListTile<T>> createState() => _GenericListTileState<T>();
}

class _GenericListTileState<T> extends State<GenericListTile<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = ResponsiveLayout(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? (widget.baseColor ?? AppColors.primary).withValues(alpha: 0.2)
                  : Colors.transparent,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: GlassContainer(
          height: widget.height,
          padding: const EdgeInsets.all(12),
          opacity: _isHovered ? 0.1 : 0.05,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.onTap,
            child: Row(
              children: [
                // Leading Image / Widget
                _buildLeading(isDark, responsive),
                
                const SizedBox(width: 16),

                // Main Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.getBodyFontSize() + 1,
                          color: isDark ? Colors.white : AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.subtitleWidget != null) ...[
                        const SizedBox(height: 4),
                        widget.subtitleWidget!,
                      ] else if (widget.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle!,
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.grey.shade600,
                            fontSize: 11,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (widget.tags != null && widget.tags!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: widget.tags!,
                        ),
                      ],
                      if (widget.statusWidget != null) ...[
                        const SizedBox(height: 6),
                        widget.statusWidget!,
                      ],
                    ],
                  ),
                ),

                // Trailing Actions
                if (widget.actions != null && widget.actions!.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.actions!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(bool isDark, ResponsiveLayout responsive) {
    if (widget.imageWidget != null) return widget.imageWidget!;

    // Default Image Box
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (widget.baseColor ?? AppColors.primary).withValues(alpha: 0.1),
        ),
      ),
      child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl!,
                cacheManager: CustomCacheManager.instance,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.primary,
                ),
              ),
            )
          : Icon(
              Icons.dashboard_customize_rounded,
              color: widget.baseColor ?? AppColors.primary,
            ),
    );
  }
}
