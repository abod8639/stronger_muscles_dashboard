import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

/// بطاقة شبكية لعرض التصنيف متوافقة بالكامل مع معايير Material Design 3
class CategoryGridCard extends StatefulWidget {
  final CategoryEntity category;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryGridCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<CategoryGridCard> createState() => _CategoryGridCardState();
}

class _CategoryGridCardState extends State<CategoryGridCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final category = widget.category;

    final hasImage = category.imageUrl != null && category.imageUrl!.isNotEmpty;

    // ألوان شارة الحالة (Active/Inactive) وفق M3
    final Color statusColor = category.isActive
        ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A))
        : (isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626));

    final Color statusBg = statusColor.withValues(alpha: isDark ? 0.18 : 0.12);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.015 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: Card.outlined(
          margin: EdgeInsets.zero,
          elevation: _isHovered ? 4 : 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: _isHovered
                  ? colorScheme.primary.withValues(alpha: 0.55)
                  : colorScheme.outlineVariant.withValues(alpha: 0.50),
              width: _isHovered ? 1.5 : 1.0,
            ),
          ),
          color: _isHovered
              ? colorScheme.surfaceContainer
              : colorScheme.surfaceContainerLow,
          child: InkWell(
            onTap: widget.onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. منطقة الصورة والوسائط مع الأزرار العائمة
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (hasImage)
                        CachedNetworkImage(
                          imageUrl: category.imageUrl!,
                          fit: BoxFit.cover,
                          cacheManager: CustomCacheManager.instance,
                          placeholder: (_, _) => Container(
                            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          errorWidget: (_, _, _) => _buildFallbackImage(colorScheme),
                        )
                      else
                        _buildFallbackImage(colorScheme),

                      // تدرج خفيف لتحسين وضوح الأزرار والشارات
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // شارة الحالة (نشط / معطل)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: statusColor.withValues(alpha: 0.35),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                category.isActive ? 'نشط' : 'معطل',
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // أزرار الإجراءات السريعة (تعديل وحذف)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCircleActionButton(
                              icon: Icons.edit_outlined,
                              color: colorScheme.primary,
                              tooltip: 'تعديل',
                              onPressed: widget.onEdit,
                            ),
                            const SizedBox(width: 6),
                            _buildCircleActionButton(
                              icon: Icons.delete_outline_rounded,
                              color: colorScheme.error,
                              tooltip: 'حذف',
                              onPressed: widget.onDelete,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. منطقة البيانات والنصوص
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category.displayName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.tag_rounded,
                              size: 13,
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                category.id,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (category.descriptionAr != null && category.descriptionAr!.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            category.descriptionAr!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.outline,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackImage(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.category_rounded,
            size: 32,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, color: color, size: 16),
          ),
        ),
      ),
    );
  }
}
