import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PromoCard extends StatelessWidget {
  final PromoEntity promo;

  const PromoCard({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Here we would use the targetUrl if we were in the customer app.
        // In the dashboard, we might just show a toast.
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Color(int.parse(promo.backgroundColor.replaceFirst('#', '0xff'))),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Image
            if (promo.imageUrl.isNotEmpty)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.8, // Slight opacity to make text readable
                  child: CachedNetworkImage(
                    imageUrl: promo.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
            // Gradient Overlay for better text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
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
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (promo.displayTitle.isNotEmpty)
                    Text(
                      promo.displayTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const Spacer(),
                  if (promo.displayButtonText.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        promo.displayButtonText,
                        style: TextStyle(
                          color: Color(int.parse(promo.backgroundColor.replaceFirst('#', '0xff'))),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
