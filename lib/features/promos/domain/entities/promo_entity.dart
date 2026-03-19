class PromoEntity {
  final String id;
  final Map<String, dynamic>? title;
  final Map<String, dynamic>? subtitle;
  final Map<String, dynamic>? buttonText;
  final String imageUrl;
  final String backgroundColor; // Hex color string
  /// 'none' | 'product' | 'brand'
  final String targetType;
  /// The ID of the target (product ID or brand ID)
  final String? targetId;
  final bool isActive;
  final DateTime? createdAt;

  const PromoEntity({
    required this.id,
    this.title,
    this.subtitle,
    this.buttonText,
    required this.imageUrl,
    required this.backgroundColor,
    this.targetType = 'none',
    this.targetId,
    required this.isActive,
    this.createdAt,
  });

  String get displayTitle => _getLocalizedText(title);
  String get displaySubtitle => _getLocalizedText(subtitle);
  String get displayButtonText => _getLocalizedText(buttonText);

  String get displayTarget {
    if (targetType == 'none' || targetId == null || targetId!.isEmpty) {
      return 'بدون توجيه';
    }
    if (targetType == 'product') return 'منتج: $targetId';
    if (targetType == 'brand') return 'ماركة: $targetId';
    return targetId!;
  }

  String _getLocalizedText(Map<String, dynamic>? textMap) {
    if (textMap == null) return '';
    if (textMap.containsKey('ar') && textMap['ar'] != null && textMap['ar'].toString().isNotEmpty) {
      return textMap['ar'].toString();
    }
    if (textMap.containsKey('en') && textMap['en'] != null && textMap['en'].toString().isNotEmpty) {
      return textMap['en'].toString();
    }
    return '';
  }
}
