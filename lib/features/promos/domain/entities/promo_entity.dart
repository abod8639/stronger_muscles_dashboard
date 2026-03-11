class PromoEntity {
  final String id;
  final Map<String, dynamic>? title;
  final Map<String, dynamic>? subtitle;
  final Map<String, dynamic>? buttonText;
  final String imageUrl;
  final String backgroundColor; // Hex color string
  final String? targetUrl;
  final bool isActive;
  final DateTime? createdAt;

  const PromoEntity({
    required this.id,
    this.title,
    this.subtitle,
    this.buttonText,
    required this.imageUrl,
    required this.backgroundColor,
    this.targetUrl,
    required this.isActive,
    this.createdAt,
  });

  String get displayTitle => _getLocalizedText(title);
  String get displaySubtitle => _getLocalizedText(subtitle);
  String get displayButtonText => _getLocalizedText(buttonText);

  String _getLocalizedText(Map<String, dynamic>? textMap) {
    if (textMap == null) return '';
    // Assuming Arabic is primary, then fallback to English
    if (textMap.containsKey('ar') && textMap['ar'] != null && textMap['ar'].toString().isNotEmpty) {
      return textMap['ar'].toString();
    }
    if (textMap.containsKey('en') && textMap['en'] != null && textMap['en'].toString().isNotEmpty) {
      return textMap['en'].toString();
    }
    return '';
  }
}

