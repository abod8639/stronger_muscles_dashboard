import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

class ActionButtonConfig {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const ActionButtonConfig({
    required this.icon,
    required this.color,
    required this.onPressed,
  });
}

class GenericListCard<T> extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? metadata;
  final String? imageUrl;
  final Widget? imageWidget;
  final IconData? fallbackIcon;
  final Widget? statusWidget;
  final List<ActionButtonConfig> actions;
  final VoidCallback? onTap;
  final T? data;
  final int index;

  const GenericListCard({
    super.key,
    required this.title,
    this.subtitle,
    this.metadata,
    this.imageUrl,
    this.imageWidget,
    this.fallbackIcon,
    this.statusWidget,
    this.actions = const [],
    this.onTap,
    this.data,
    this.index = 0,
  });

  @override
  State<GenericListCard<T>> createState() => _GenericListCardState<T>();
}

class _GenericListCardState<T> extends State<GenericListCard<T>>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = context.responsive;

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
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : Colors.transparent,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: GlassContainer(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Image/Icon
                  _buildLeadingWidget(isDark),
                  const SizedBox(width: 16),

                  // Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.getBodyFontSize() + 1,
                            color: isDark ? Colors.white : AppColors.textMuted,
                          ),
                        ),
                        if (widget.metadata != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.metadata!,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white54
                                  : Colors.grey.shade600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle!,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        if (widget.statusWidget != null) ...[
                          const SizedBox(height: 6),
                          widget.statusWidget!,
                        ],
                      ],
                    ),
                  ),

                  // Action Buttons
                  if (widget.actions.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.actions.map((action) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: buildActionButton(
                            icon: action.icon,
                            color: action.color,
                            onPressed: action.onPressed,
                            isDark: isDark,
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingWidget(bool isDark) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl!,
                cacheManager: CustomCacheManager.instance,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Icon(
                  widget.fallbackIcon ?? Icons.image_outlined,
                  color: AppColors.primary,
                ),
              ),
            )
          : widget.imageWidget ??
                Icon(
                  widget.fallbackIcon ?? Icons.image_outlined,
                  color: AppColors.primary,
                ),
    );
  }

  Widget buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: color),
        constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
