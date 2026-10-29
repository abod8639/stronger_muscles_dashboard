import 'dart:ui';

/// يحوّل نص لون سداسي إلى [Color]
/// يقبل الصيغ: `#RRGGBB` و `#AARRGGBB` و `0xRRGGBB` (مع أو بدون # أو 0x)
/// ويعيد [fallback] عند كون النص فارغاً أو غير صالح
Color parseHexColor(String hex, {Color fallback = const Color(0xFF1E1E22)}) {
  var clean = hex.trim().replaceAll('#', '');
  if (clean.toLowerCase().startsWith('0x')) clean = clean.substring(2);

  final value = int.tryParse(clean, radix: 16);
  if (value == null) return fallback;

  return switch (clean.length) {
    6 => Color(0xFF000000 | value),
    8 => Color(value),
    _ => fallback,
  };
}
