/// Utility for enforcing and standardizing metric weights (g - kg).
/// Ensures pounds (lb/lbs) and ounces (oz) are automatically converted
/// to metric units and formats weight strings consistently.
class WeightUnitHelper {
  const WeightUnitHelper._();

  static final RegExp _poundRegex = RegExp(
    r'(\d+(?:\.\d+)?)\s*(?:lbs?|pound|باوند|رطل)',
    caseSensitive: false,
  );

  static final RegExp _ounceRegex = RegExp(
    r'(\d+(?:\.\d+)?)\s*(?:oz|ounce|أونصة)',
    caseSensitive: false,
  );

  static final RegExp _metricRegex = RegExp(
    r'(\d+(?:\.\d+)?)\s*(kg|g|كيلو|كيلوغرام|جرام|غرام)',
    caseSensitive: false,
  );

  /// Converts any weight or size string to standardized metric format (g or kg).
  /// Examples:
  /// - "5 lbs" -> "2.27kg"
  /// - "2 lb" -> "907g"
  /// - "10 lbs" -> "4.54kg"
  /// - "1 lb" -> "454g"
  /// - "16 oz" -> "454g"
  /// - "1000g" -> "1kg"
  /// - "2.0kg" -> "2kg"
  /// - "500g" -> "500g"
  static String normalizeToMetric(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return trimmed;

    // Check for pounds
    final lbMatch = _poundRegex.firstMatch(trimmed);
    if (lbMatch != null) {
      final value = double.tryParse(lbMatch.group(1) ?? '');
      if (value != null && value > 0) {
        return _convertPoundsToMetric(value);
      }
    }

    // Check for ounces
    final ozMatch = _ounceRegex.firstMatch(trimmed);
    if (ozMatch != null) {
      final value = double.tryParse(ozMatch.group(1) ?? '');
      if (value != null && value > 0) {
        final grams = value * 28.3495;
        return _formatGrams(grams);
      }
    }

    // Check for standard metric strings and clean them up
    final metricMatch = _metricRegex.firstMatch(trimmed);
    if (metricMatch != null) {
      final numStr = metricMatch.group(1) ?? '';
      final unit = metricMatch.group(2)?.toLowerCase() ?? '';
      final val = double.tryParse(numStr);
      if (val != null) {
        if (unit == 'kg' || unit == 'كيلو' || unit == 'كيلوغرام') {
          return _formatKg(val);
        } else {
          // unit is g/grams
          if (val >= 1000 && val % 100 == 0) {
            return _formatKg(val / 1000);
          }
          return '${_cleanDouble(val)}g';
        }
      }
    }

    return trimmed;
  }

  /// Converts pound value to standardized g or kg
  static String _convertPoundsToMetric(double pounds) {
    // Common fitness supplement specific exact standards:
    if ((pounds - 5.0).abs() < 0.05) return '2.27kg';
    if ((pounds - 2.0).abs() < 0.05) return '907g';
    if ((pounds - 10.0).abs() < 0.05) return '4.54kg';
    if ((pounds - 1.0).abs() < 0.05) return '454g';
    if ((pounds - 2.2).abs() < 0.05) return '1kg';
    if ((pounds - 4.4).abs() < 0.05) return '2kg';
    if ((pounds - 3.0).abs() < 0.05) return '1.36kg';
    if ((pounds - 6.0).abs() < 0.05) return '2.72kg';

    final grams = pounds * 453.59237;
    return _formatGrams(grams);
  }

  static String _formatGrams(double grams) {
    if (grams >= 1000) {
      final kg = grams / 1000;
      return _formatKg(kg);
    }
    return '${grams.round()}g';
  }

  static String _formatKg(double kg) {
    if ((kg - kg.roundToDouble()).abs() < 0.001) {
      return '${kg.toInt()}kg';
    }
    // Round to 2 decimal places max, avoiding trailing zeros
    final rounded = (kg * 100).round() / 100;
    return '${_cleanDouble(rounded)}kg';
  }

  static String _cleanDouble(double val) {
    if (val == val.toInt()) {
      return val.toInt().toString();
    }
    return val.toString().replaceAll(RegExp(r'\.?0+$'), '');
  }
}

