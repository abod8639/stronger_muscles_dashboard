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
          // Image / color preview
          _buildImagePreview(),
          const SizedBox(width: 16),
          // Info
          Expanded(child: _buildInfo()),
          // Actions
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    Color bgColor = Colors.white;
    try {
      final hex = promo.backgroundColor.replaceFirst('#', '0xff');
      bgColor = Color(int.parse(hex));
    } catch (_) {}

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColorsExtended.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: promo.imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: promo.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => const Icon(Icons.image, color: Colors.white54),
              errorWidget: (_, _, _) => const Icon(Icons.broken_image, color: Colors.white54),
            )
          : const Icon(Icons.campaign, color: Colors.white),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row
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
            _buildStatusBadge(),
          ],
        ),
        // Subtitle
        if (promo.displaySubtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            promo.displaySubtitle,
            style: const TextStyle(
              fontSize: 13,
              color: AppColorsExtended.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 8),
        // Target chip
        _buildTargetChip(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (promo.isActive ? Colors.green : Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        promo.isActive ? 'نشط' : 'غير نشط',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: promo.isActive ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  Widget _buildTargetChip() {
    IconData icon;
    Color chipColor;
    String label;

    switch (promo.targetType) {
      case 'product':
        icon = Icons.inventory_2_rounded;
        chipColor = AppColorsExtended.purpleAccent;
        label = promo.targetId != null && promo.targetId!.isNotEmpty
            ? 'منتج: ${promo.targetId}'
            : 'منتج: غير محدد';
        break;
      case 'brand':
        icon = Icons.category_rounded;
        chipColor = Colors.orange;
        label = promo.targetId != null && promo.targetId!.isNotEmpty
            ? 'ماركة: ${promo.targetId}'
            : 'ماركة: غير محددة';
        break;
      default:
        icon = Icons.block;
        chipColor = AppColorsExtended.textSecondary;
        label = 'بدون توجيه';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: chipColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: 11, color: chipColor, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

  }

  Widget _buildActions() {
    return Column(
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
    );
  }

}
