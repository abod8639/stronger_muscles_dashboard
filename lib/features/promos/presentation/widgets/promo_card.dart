import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PromoCard extends StatelessWidget {
  final PromoEntity promo;

  const PromoCard({super.key, required this.promo});

  Color _parsePromoColor(BuildContext context) {
    try {
      final hex = promo.backgroundColor.replaceAll('#', '');
      return Color(int.parse(hex.length == 6 ? '0xff$hex' : '0x$hex'));
    } catch (_) {
      return Theme.of(context).colorScheme.primaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = _parsePromoColor(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      color: cardColor,
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: Stack(
          children: [
            // Background Image
            if (promo.imageUrl.isNotEmpty)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.8,
                  child: CachedNetworkImage(
                    imageUrl: promo.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // Gradient Overlay for readability
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.75),
                      Colors.black.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (promo.displaySubtitle.isNotEmpty)
                    Text(
                      promo.displaySubtitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                  if (promo.displaySubtitle.isNotEmpty && promo.displayTitle.isNotEmpty)
                    const SizedBox(height: 6),
                  if (promo.displayTitle.isNotEmpty)
                    Text(
                      promo.displayTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const Spacer(),
                  if (promo.displayButtonText.isNotEmpty)
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        child: Text(
                          promo.displayButtonText,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: cardColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
