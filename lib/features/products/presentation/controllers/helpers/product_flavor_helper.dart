import 'package:stronger_muscles_dashboard/features/products/domain/entities/flavor_item.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';

/// Central helper for managing and strictly enforcing existing store flavors.
/// Guarantees that only valid, registered store flavors with images are used.
class ProductFlavorHelper {
  const ProductFlavorHelper._();

  /// Returns the complete list of unique existing flavors:
  /// Combines default store presets with any existing flavors already saved in products.
  static List<FlavorItem> getAvailableStoreFlavors({
    List<ProductEntity>? existingProducts,
  }) {
    final Map<String, FlavorItem> map = {};

    // 1. Always start with the system presets (these have verified store images)
    for (final preset in FlavorItem.defaultPresets) {
      map[preset.name.toLowerCase().trim()] = preset;
    }

    // 2. Add any custom flavors already saved across products in the database
    if (existingProducts != null) {
      for (final p in existingProducts) {
        final list = p.flavors;
        if (list != null) {
          for (final raw in list) {
            final item = FlavorItem.fromRaw(raw);
            final key = item.name.toLowerCase().trim();
            if (key.isNotEmpty && !map.containsKey(key)) {
              map[key] = item;
            }
          }
        }
      }
    }

    return map.values.toList();
  }

  /// Maps any flavor string (Arabic, English, or compound name)
  /// to the exact existing FlavorItem from the store.
  /// Returns null if the flavor does not match any existing store flavor.
  static FlavorItem? matchToExistingFlavor(
    String raw,
    List<FlavorItem> availableFlavors,
  ) {
    final clean = raw.contains('|') ? raw.split('|').first.trim() : raw.trim();
    if (clean.isEmpty) return null;

    final lower = clean.toLowerCase();

    // 1. Direct case-insensitive match
    for (final flavor in availableFlavors) {
      if (flavor.name.toLowerCase() == lower) {
        return flavor;
      }
    }

    // 2. Arabic translations & synonyms mapping to standard preset names
    final arabicMapped = _mapArabicOrSynonym(lower);
    if (arabicMapped != null) {
      for (final flavor in availableFlavors) {
        if (flavor.name.toLowerCase() == arabicMapped.toLowerCase()) {
          return flavor;
        }
      }
    }

    // 3. Substring match (e.g. "Double Rich Chocolate" -> "Chocolate")
    for (final flavor in availableFlavors) {
      final flavorLower = flavor.name.toLowerCase();
      if (flavorLower != 'no flavor' && lower.contains(flavorLower)) {
        return flavor;
      }
    }

    return null;
  }

  /// Filters a list of raw flavor strings so that ONLY existing store flavors are returned.
  /// Converts each valid flavor to its canonical rawValue (including the preset image URL).
  static List<String> filterOnlyExistingFlavors(
    List<String> rawFlavors,
    List<FlavorItem> availableFlavors,
  ) {
    final List<String> result = [];
    final Set<String> seenNames = {};

    for (final raw in rawFlavors) {
      final matched = matchToExistingFlavor(raw, availableFlavors);
      if (matched != null) {
        final key = matched.name.toLowerCase();
        if (!seenNames.contains(key)) {
          seenNames.add(key);
          result.add(matched.rawValue);
        }
      }
    }

    return result;
  }

  static String? _mapArabicOrSynonym(String lower) {
    if (lower.contains('شوكولات') || lower.contains('شكولات') || lower.contains('choco')) {
      return 'Chocolate';
    }
    if (lower.contains('فانيلي') || lower.contains('فانيلا') || lower.contains('vanilla')) {
      return 'Vanilla';
    }
    if (lower.contains('فراول') || lower.contains('strawberr')) {
      return 'Strawberry';
    }
    if (lower.contains('موز') || lower.contains('banana')) {
      return 'Banana';
    }
    if (lower.contains('مانج') || lower.contains('مانغ') || lower.contains('mango')) {
      return 'Mango';
    }
    if (lower.contains('كراميل') || lower.contains('caramel') || lower.contains('toffee')) {
      return 'Caramel';
    }
    if (lower.contains('كوكيز') || lower.contains('بسكويت') || lower.contains('cookie')) {
      return 'Cookies';
    }
    if (lower.contains('توت') || lower.contains('berry') || lower.contains('blueberr')) {
      return 'Berry';
    }
    if (lower.contains('قهو') || lower.contains('كافيه') || lower.contains('coffee') || lower.contains('mocha')) {
      return 'Coffee';
    }
    if (lower.contains('كولا') || lower.contains('cola')) {
      return 'Cola';
    }
    if (lower.contains('فول سوداني') || lower.contains('peanut')) {
      return 'Peanut';
    }
    if (lower.contains('بطيخ') || lower.contains('حبحب') || lower.contains('watermelon')) {
      return 'Watermelon';
    }
    if (lower.contains('ليمون') || lower.contains('lemon')) {
      return 'Lemon';
    }
    if (lower.contains('بدون نكهة') || lower.contains('غير منكه') || lower.contains('unflavored') || lower.contains('plain')) {
      return 'No Flavor';
    }
    return null;
  }
}
