import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/build_image_shimmer.dart';

Widget buildEnhancedOrderImages(OrderEntity order, bool isHovered) {
  return EnhancedOrderImages(order: order, isHovered: isHovered);
}

class EnhancedOrderImages extends StatelessWidget {
  final OrderEntity order;
  final bool isHovered;

  const EnhancedOrderImages({
    super.key,
    required this.order,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    final items = order.items;
    if (items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;

    final imageSize = isMobile ? 44.0 : 60.0;
    final overlapOffset = isMobile ? 14.0 : 18.0;
    final displayCount = items.length > 3 ? 3 : items.length;
    final hasMore = items.length > 3;

    // Dynamically calculate container width so it is strictly responsive
    final containerWidth = imageSize +
        ((displayCount - 1) * overlapOffset) +
        (hasMore ? (isMobile ? 12.0 : 16.0) : 0);

    return SizedBox(
      width: containerWidth,
      height: imageSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Image stack
          ...List.generate(displayCount, (index) {
            final item = items[index];
            return Positioned(
              right: index * overlapOffset,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200 + (index * 40)),
                curve: Curves.easeOutCubic,
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
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
                      blurRadius: isHovered ? 8 : 4,
                      offset: Offset(0, isHovered ? 3 : 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isMobile ? 9 : 11),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (_, _) => buildImageShimmer(),
                    errorWidget: (_, _, _) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: isMobile ? 16 : 18,
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
            Positioned(
              right: (displayCount - 1) * overlapOffset + (isMobile ? 24.0 : 28.0),
              top: -3,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 5 : 6,
                  vertical: isMobile ? 2 : 2.5,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '+${items.length - 3}',
                  style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: isMobile ? 9.5 : 10.5,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onPrimary,
                        height: 1,
                      ) ??
                      TextStyle(
                        fontSize: isMobile ? 9.5 : 10.5,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onPrimary,
                        height: 1,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
