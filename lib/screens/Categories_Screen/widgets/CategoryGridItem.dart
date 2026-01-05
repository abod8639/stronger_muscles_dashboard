
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/models/category.dart';

class CategoryGridItem extends StatefulWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryGridItem({super.key, 
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<CategoryGridItem> createState() => _CategoryGridItemState();
}

class _CategoryGridItemState extends State<CategoryGridItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: _isHovered ? 8 : 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onEdit,
            child: Stack(
              children: [
                // صورة الخلفية
                Positioned.fill(
                  child: widget.category.imageUrl != null && widget.category.imageUrl!.isNotEmpty
                    ? Image.network(
                        widget.category.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(isDark),
                      )
                    : _buildPlaceholder(isDark),
                ),

                // طبقة التعتيم المتدرجة
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

                // المحتوى
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.category_rounded,
                        color: Colors.white,
                        size: responsive.largeIconSize - 4,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.category.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.getBodyFontSize() + 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (!widget.category.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'معطل',
                            style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),

                // زر الحذف (يظهر عند الـ hover أو دائماً في الجوال)
                if (_isHovered || responsive.isMobile)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                        onPressed: widget.onDelete,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        padding: EdgeInsets.zero,
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

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.8),
            AppColors.secondary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
