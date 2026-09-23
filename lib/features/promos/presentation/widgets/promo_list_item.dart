import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_controller.dart';

/// عنصر قائمة الإعلانات المتوافق مع معايير Material Design 3
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
    final colorScheme = Theme.of(context).colorScheme;

    return Card.outlined(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1.0,
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Image / Color Preview
            _buildImagePreview(context),
            const SizedBox(width: 16),
            // Info
            Expanded(child: _buildInfo(context)),
            // Actions
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color bgColor = colorScheme.surfaceContainerHighest;
    try {
      final hex = promo.backgroundColor.replaceFirst('#', '0xff');
      bgColor = Color(int.parse(hex));
    } catch (_) {}

    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: promo.imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: promo.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => Center(
                child: Icon(
                  Icons.image,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  size: 24,
                ),
              ),
              errorWidget: (_, _, _) => Center(
                child: Icon(
                  Icons.broken_image,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  size: 24,
                ),
              ),
            )
          : Center(
              child: Icon(
                Icons.campaign_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 28,
              ),
            ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Status Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                promo.displayTitle.isNotEmpty ? promo.displayTitle : 'بدون عنوان',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _buildStatusBadge(context),
          ],
        ),
        // Subtitle
        if (promo.displaySubtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            promo.displaySubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 8),
        // Target chip
        _buildTargetChip(context),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isActive = promo.isActive;
    final badgeColor = isActive ? AppColors.success : colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: Text(
        isActive ? 'نشط' : 'غير نشط',
        style: theme.textTheme.labelSmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: badgeColor,
        ),
      ),
    );
  }

  Widget _buildTargetChip(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    IconData icon;
    String label;

    switch (promo.targetType) {
      case 'product':
        icon = Icons.inventory_2_rounded;
        label = promo.targetId != null && promo.targetId!.isNotEmpty
            ? 'منتج: ${promo.targetId}'
            : 'منتج: غير محدد';
        break;
      case 'brand':
        icon = Icons.category_rounded;
        final brandName = Get.isRegistered<PromosController>()
            ? Get.find<PromosController>().getBrandName(promo.targetId)
            : promo.targetId;
        label = promo.targetId != null && promo.targetId!.isNotEmpty
            ? 'ماركة: $brandName'
            : 'ماركة: غير محددة';
        break;
      default:
        icon = Icons.block;
        label = 'بدون توجيه';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.edit_rounded,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
          onPressed: onEdit,
          tooltip: 'تعديل',
        ),
        IconButton(
          icon: Icon(
            Icons.delete_outline_rounded,
            color: colorScheme.error,
            size: 20,
          ),
          onPressed: onDelete,
          tooltip: 'حذف',
        ),
      ],
    );
  }
}
