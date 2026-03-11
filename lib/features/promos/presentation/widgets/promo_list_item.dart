import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PromoListItem extends StatelessWidget {
  final PromoEntity promo;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PromoListItem({
    super.key,
    required this.promo,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsExtended.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColorsExtended.softShadow,
        border: Border.all(color: AppColorsExtended.borderColor, width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Image / Color preview
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Color(int.parse(promo.backgroundColor.replaceFirst('#', '0xff'))),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColorsExtended.borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: promo.imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: promo.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Icon(Icons.image, color: Colors.white54),
                    errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.white54),
                  )
                : const Icon(Icons.campaign, color: Colors.white),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        promo.displayTitle.isNotEmpty ? promo.displayTitle : 'بدون عنوان',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColorsExtended.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: promo.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        promo.isActive ? 'نشط' : 'غير نشط',
                        style: TextStyle(
                          fontSize: 12,
                          color: promo.isActive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (promo.displaySubtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    promo.displaySubtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColorsExtended.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.link, size: 16, color: AppColorsExtended.purpleAccent),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        promo.targetUrl ?? 'بدون رابط توجيه',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColorsExtended.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Actions
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.edit_rounded, color: AppColorsExtended.purpleAccent),
                onPressed: onEdit,
                tooltip: 'تعديل',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                onPressed: onDelete,
                tooltip: 'حذف',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
