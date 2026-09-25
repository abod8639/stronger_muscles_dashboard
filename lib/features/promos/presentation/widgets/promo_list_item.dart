import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_controller.dart';

/// عنصر قائمة الإعلانات بتصميم Neumorphism / Soft UI
/// يتميز بأسطح لمسية ناعمة، شارة حالة نقطية مجسمة، وأزرار تحكم بارزة بدون أنيميشن
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.02)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.06)!,
                ]
              : [
                  Color.lerp(colorScheme.surface, Colors.white, 0.85)!,
                  Color.lerp(colorScheme.surface, const Color(0xFFA3B1C6), 0.08)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.28),
            offset: const Offset(2, 2.5),
            blurRadius: 4,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.90),
            offset: const Offset(-2, -2),
            blurRadius: 3.5,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.white.withValues(alpha: 0.85),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // معاينة صورة / لون الإعلان
            _buildImagePreview(colorScheme, isDark),
            const SizedBox(width: 16),
            // بيانات الإعلان
            Expanded(child: _buildInfo(context, colorScheme, isDark)),
            const SizedBox(width: 12),
            // أزرار العمليات (تعديل وحذف)
            _buildActions(colorScheme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(ColorScheme colorScheme, bool isDark) {
    Color bgColor = isDark
        ? colorScheme.surfaceContainerHighest
        : colorScheme.surfaceContainerHigh;
    try {
      final hex = promo.backgroundColor.replaceFirst('#', '0xff');
      bgColor = Color(int.parse(hex));
    } catch (_) {}

    return Container(
      width: 150,
      height: 76,
      decoration: BoxDecoration(
        color: bgColor,
        // borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
            offset: const Offset(1.5, 2),
            blurRadius: 3,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.90),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 2.5,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: promo.imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: promo.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: Icon(
                  Icons.image,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  size: 24,
                ),
              ),
              errorWidget: (context, url, error) => Center(
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

  Widget _buildInfo(BuildContext context, ColorScheme colorScheme, bool isDark) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الصف الأول: العنوان وشارة الحالة
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
            _buildStatusBadge(context, colorScheme, isDark),
          ],
        ),
        // الوصف الفرعي
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
        // نوع التوجيه (Target chip)
        _buildTargetChip(context, colorScheme, isDark),
      ],
    );
  }

  Widget _buildStatusBadge(
    BuildContext context,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final isActive = promo.isActive;
    final badgeColor = isActive ? AppColors.success : colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.02)!,
                  Color.lerp(colorScheme.surfaceContainer, badgeColor, 0.12)!,
                ]
              : [
                  Color.lerp(colorScheme.surface, Colors.white, 0.85)!,
                  Color.lerp(badgeColor, Colors.white, 0.85)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.30)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.20),
            offset: const Offset(1, 1.5),
            blurRadius: 2.5,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.90),
            offset: const Offset(-1, -1),
            blurRadius: 2,
          ),
        ],
        border: Border.all(
          color: badgeColor.withValues(alpha: isDark ? 0.35 : 0.45),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isActive ? 'نشط' : 'غير نشط',
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetChip(
    BuildContext context,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final theme = Theme.of(context);
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
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainerLowest, Colors.white, 0.02)!,
                  Color.lerp(colorScheme.surfaceContainerLowest, Colors.black, 0.06)!,
                ]
              : [
                  Color.lerp(colorScheme.surfaceContainerLow, Colors.white, 0.70)!,
                  Color.lerp(colorScheme.surfaceContainerLow, const Color(0xFFA3B1C6), 0.06)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.18),
            offset: const Offset(1, 1),
            blurRadius: 2,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.015)
                : Colors.white.withValues(alpha: 0.85),
            offset: const Offset(-1, -1),
            blurRadius: 2,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.white.withValues(alpha: 0.85),
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

  Widget _buildActions(ColorScheme colorScheme, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: Icons.edit_rounded,
          color: colorScheme.onSurfaceVariant,
          onTap: onEdit,
          tooltip: 'تعديل',
          isDark: isDark,
          colorScheme: colorScheme,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.delete_outline_rounded,
          color: colorScheme.error,
          onTap: onDelete,
          tooltip: 'حذف',
          isDark: isDark,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
    required bool isDark,
    required ColorScheme colorScheme,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.02)!,
                    Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.06)!,
                  ]
                : [
                    Color.lerp(colorScheme.surface, Colors.white, 0.85)!,
                    Color.lerp(colorScheme.surface, const Color(0xFFA3B1C6), 0.08)!,
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.35)
                  : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
              offset: const Offset(1.5, 2),
              blurRadius: 3,
            ),
            BoxShadow(
              color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.90),
              offset: const Offset(-1.5, -1.5),
              blurRadius: 2.5,
            ),
          ],
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : Colors.white.withValues(alpha: 0.85),
            width: 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Center(
              child: Icon(
                icon,
                color: color,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
