import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_controller.dart';

/// قسم إدارة ومعاينة صورة التصنيف الترويجية بنمط Material Design 3
class CategoryImageSection extends StatefulWidget {
  final CategoriesController controller;

  const CategoryImageSection({super.key, required this.controller});

  @override
  State<CategoryImageSection> createState() => _CategoryImageSectionState();
}

class _CategoryImageSectionState extends State<CategoryImageSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ModernTextField(
          controller: widget.controller.imageController,
          label: 'رابط الصورة (URL)',
          icon: Icons.link_rounded,
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.controller.imageController,
          builder: (context, value, _) {
            final url = value.text.trim();
            if (url.isEmpty) {
              return _buildEmptyPlaceholder(context);
            }
            return _buildLivePreview(context, url);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.2,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 32,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'أدخل رابط صورة التصنيف أعلاه',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'ستظهر المعاينة المباشرة هنا فور إدخال الرابط',
              style: TextStyle(
                color: colorScheme.outline,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLivePreview(BuildContext context, String imageUrl) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              errorWidget: (_, _, _) => Container(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_rounded,
                      size: 36,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'تعذر تحميل الصورة من الرابط',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    color: Colors.white,
                    tooltip: 'إعادة تحميل الصورة',
                    splashRadius: 18,
                    onPressed: () => setState(() {}),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    color: Colors.redAccent,
                    tooltip: 'حذف الرابط',
                    splashRadius: 18,
                    onPressed: () {
                      widget.controller.imageController.clear();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
