import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

/// بطاقة عرض التصنيف في القائمة الرأسية (Mobile ListView) بنمط Material Design 3
class CategoryListItem extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryListItem({
    super.key,
    required this.category,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final hasImage = category.imageUrl != null && category.imageUrl!.isNotEmpty;

    final Color statusColor = category.isActive
        ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A))
        : (isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626));

    final Color statusBg = statusColor.withValues(alpha: isDark ? 0.18 : 0.12);

    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // صورة التصنيف
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: hasImage
                    ? CachedNetworkImage(
                        imageUrl: category.imageUrl!,
                        fit: BoxFit.cover,
                        cacheManager: CustomCacheManager.instance,
                        errorWidget: (_, _, _) => Icon(
                          Icons.category_rounded,
                          color: colorScheme.primary,
                          size: 26,
                        ),
                      )
                    : Icon(
                        Icons.category_rounded,
                        color: colorScheme.primary,
                        size: 26,
                      ),
              ),
              const SizedBox(width: 14),

              // التفاصيل والاسم
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.displayName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: statusColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            category.isActive ? 'نشط' : 'معطل',
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'ID: ${category.id}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (category.descriptionAr != null && category.descriptionAr!.isNotEmpty) ...[
                      const SizedBox(height: 2),
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

              const SizedBox(width: 8),

              // أزرار الإجراءات
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_outlined, size: 20, color: colorScheme.primary),
                    tooltip: 'تعديل',
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded, size: 20, color: colorScheme.error),
                    tooltip: 'حذف',
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
