import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/build_image_shimmer.dart';

Widget buildEnhancedOrderImages(
  OrderEntity order,
  bool isHovered, {
  double? size,
}) {
  return EnhancedOrderImages(order: order, isHovered: isHovered, size: size);
}

class EnhancedOrderImages extends StatelessWidget {
  final OrderEntity order;
  final bool isHovered;
  final double? size;

  const EnhancedOrderImages({
    super.key,
    required this.order,
    this.isHovered = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final items = order.items;
    if (items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;

    final imageSize = size ?? (isMobile ? 38.0 : (context.isTablet ? 42.0 : 46.0));
    final overlapOffset = (imageSize * 0.32).clamp(11.0, 15.0);
    final displayCount = items.length > 3 ? 3 : items.length;
    final hasMore = items.length > 3;

    // Dynamically calculate container width so it is strictly responsive
    final containerWidth = imageSize +
        ((displayCount - 1) * overlapOffset) +
        (hasMore ? (imageSize * 0.32) : 0);

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerEnd,
      child: SizedBox(
        width: containerWidth,
        height: imageSize + 6,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.centerEnd,
          children: [
            // Image stack
            ...List.generate(displayCount, (index) {
              final item = items[index];
              return PositionedDirectional(
                start: index * overlapOffset,
                bottom: 2,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200 + (index * 40)),
                  curve: Curves.easeOutCubic,
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                    border: Border.all(
                      color: isHovered
                          ? colorScheme.primary.withValues(alpha: 0.5)
                          : colorScheme.outlineVariant.withValues(alpha: 0.6),
                      width: isHovered ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: isHovered ? 0.25 : 0.1),
                        blurRadius: isHovered ? 6 : 3,
                        offset: Offset(0, isHovered ? 2 : 1),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(isMobile ? 7 : 9),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl ?? '',
                      fit: BoxFit.cover,
                      placeholder: (_, _) => buildImageShimmer(),
                      errorWidget: (_, _, _) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: isMobile ? 14 : 16,
                          color:
                              colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Count badge if more items
            if (hasMore)
              PositionedDirectional(
                start: (displayCount - 1) * overlapOffset + (imageSize * 0.45),
                top: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 4.5 : 5.5,
                    vertical: isMobile ? 1.5 : 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: colorScheme.surface,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.35),
                        blurRadius: 4,
                        offset: const Offset(0, 1.5),
                      ),
                    ],
                  ),
                  child: Text(
                    '+${items.length - 3}',
                    style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: isMobile ? 8.5 : 9.5,
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onPrimary,
                          height: 1,
                        ) ??
                        TextStyle(
                          fontSize: isMobile ? 8.5 : 9.5,
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onPrimary,
                          height: 1,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
