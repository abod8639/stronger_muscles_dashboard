import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';

/// Pure utility class responsible for SKU slugification and variant matrix generation.
/// Adheres to SRP by separating business/formatting algorithms from UI state.
class ProductSkuGenerator {
  const ProductSkuGenerator._();

  /// Formats and sanitizes a string into a standardized, barcode-compliant SKU slug.
  /// Converts common Arabic terms into international SKU tokens.
  static String slugify(String input) {
    final clean = input.trim().replaceAll(RegExp(r'\s+'), '-');
    final hasNonAscii = clean.codeUnits.any((code) => code > 127);
    if (!hasNonAscii) {
      return clean.replaceAll(RegExp(r'[^A-Za-z0-9\-_]'), '').toUpperCase();
    }
    final lower = clean.toLowerCase();
    if (lower.contains('شوكولات') || lower.contains('شكولات')) return 'CHOCO';
    if (lower.contains('فانيلي') || lower.contains('فانيلا')) return 'VANILLA';
    if (lower.contains('فراول')) return 'STRAWBERRY';
    if (lower.contains('موز')) return 'BANANA';
    if (lower.contains('كراميل')) return 'CARAMEL';
    if (lower.contains('كوكيز') || lower.contains('بسكويت')) return 'COOKIES';
    if (lower.contains('قهو') || lower.contains('كافيه')) return 'COFFEE';
    if (lower.contains('بدون') || lower.contains('غير منكه')) {
      return 'UNFLAVORED';
    }

    final hash = (clean.hashCode.abs() % 10000).toString().padLeft(4, '0');
    return 'OPT-$hash';
  }

  /// Generates the combinatorial Cartesian product matrix of variants
  /// from available sizes and flavors.
  static List<ProductVariantEntity> generateMatrix({
    required String rawBaseSku,
    required double basePrice,
    required double? baseDiscount,
    required List<ProductSizeEntity> sizes,
    required List<String> globalFlavors,
    required double Function(String size, double fallbackPrice) resolveSizePrice,
    required double? Function(String size, double? fallbackDiscount)
        resolveSizeDiscount,
    required int Function(String size, int? fallbackStock) resolveSizeStock,
  }) {
    final variants = <ProductVariantEntity>[];
    final baseSku = slugify(
      rawBaseSku.isNotEmpty
          ? rawBaseSku
          : 'PROD-${DateTime.now().millisecondsSinceEpoch % 10000}',
    );

    // Case 1: Both Sizes and Flavors exist
    if (sizes.isNotEmpty && globalFlavors.isNotEmpty) {
      for (final sizeEntity in sizes) {
        final sizePrice = resolveSizePrice(sizeEntity.size, sizeEntity.price);
        final sizeDiscount = resolveSizeDiscount(
          sizeEntity.size,
          sizeEntity.discountPrice,
        );
        final sizeStock = resolveSizeStock(
          sizeEntity.size,
          sizeEntity.stockQuantity,
        );

        final sizeFlavors =
            (sizeEntity.flavors != null && sizeEntity.flavors!.isNotEmpty)
                ? sizeEntity.flavors!
                : globalFlavors;

        final flavorCount = sizeFlavors.length;
        final baseStockPerFlavor =
            flavorCount > 0 ? (sizeStock / flavorCount).floor() : sizeStock;
        int stockRemainder = flavorCount > 0 ? (sizeStock % flavorCount) : 0;

        for (final flavor in sizeFlavors) {
          final cleanFlavor = flavor.contains('|')
              ? flavor.split('|').first.trim()
              : flavor;
          final cleanSize = sizeEntity.size;
          final safeFlavor = slugify(cleanFlavor);
          final safeSize = slugify(cleanSize);
          final sku = '$baseSku-$safeSize-$safeFlavor'
              .replaceAll('--', '-')
              .toUpperCase();
          final effectivePrice = (sizeDiscount != null && sizeDiscount > 0)
              ? sizeDiscount
              : (sizePrice > 0 ? sizePrice : basePrice);

          final itemStock = baseStockPerFlavor + (stockRemainder > 0 ? 1 : 0);
          if (stockRemainder > 0) stockRemainder--;

          variants.add(
            ProductVariantEntity(
              id: 'VAR-${DateTime.now().millisecondsSinceEpoch}-${variants.length}',
              sku: sku,
              price: sizePrice > 0 ? sizePrice : basePrice,
              discountPrice: sizeDiscount ?? baseDiscount,
              effectivePrice: effectivePrice,
              stockQuantity: itemStock,
              attributes: {
                'size': cleanSize,
                'flavor': cleanFlavor,
              },
              isActive: true,
            ),
          );
        }
      }
    } else if (sizes.isNotEmpty) {
      // Case 2: Only Sizes exist
      for (final sizeEntity in sizes) {
        final sizePrice = resolveSizePrice(sizeEntity.size, sizeEntity.price);
        final sizeDiscount = resolveSizeDiscount(
          sizeEntity.size,
          sizeEntity.discountPrice,
        );
        final sizeStock = resolveSizeStock(
          sizeEntity.size,
          sizeEntity.stockQuantity,
        );
        final cleanSize = sizeEntity.size;
        final safeSize = slugify(cleanSize);
        final sku = '$baseSku-$safeSize'.replaceAll('--', '-').toUpperCase();
        final effectivePrice = (sizeDiscount != null && sizeDiscount > 0)
            ? sizeDiscount
            : (sizePrice > 0 ? sizePrice : basePrice);

        variants.add(
          ProductVariantEntity(
            id: 'VAR-${DateTime.now().millisecondsSinceEpoch}-${variants.length}',
            sku: sku,
            price: sizePrice > 0 ? sizePrice : basePrice,
            discountPrice: sizeDiscount ?? baseDiscount,
            effectivePrice: effectivePrice,
            stockQuantity: sizeStock,
            attributes: {'size': cleanSize},
            isActive: true,
          ),
        );
      }
    } else {
      // Case 3: Only Flavors exist
      for (final flavor in globalFlavors) {
        final cleanFlavor = flavor.contains('|')
            ? flavor.split('|').first.trim()
            : flavor;
        final safeFlavor = slugify(cleanFlavor);
        final sku = '$baseSku-$safeFlavor'.replaceAll('--', '-').toUpperCase();
        final effectivePrice = (baseDiscount != null && baseDiscount > 0)
            ? baseDiscount
            : basePrice;

        variants.add(
          ProductVariantEntity(
            id: 'VAR-${DateTime.now().millisecondsSinceEpoch}-${variants.length}',
            sku: sku,
            price: basePrice,
            discountPrice: baseDiscount,
            effectivePrice: effectivePrice,
            stockQuantity: 0,
            attributes: {'flavor': cleanFlavor},
            isActive: true,
          ),
        );
      }
    }

    return variants;
  }
}
