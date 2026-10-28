import 'dart:core';

/// Pure Dart domain entity representing a promotional banner / advertisement.
/// Strictly decoupled from any database, UI, or network framework (100% Pure Dart).
class PromoEntity {
  final String id;
  final Map<String, dynamic>? title;
  final Map<String, dynamic>? subtitle;
  final Map<String, dynamic>? buttonText;
  final String imageUrl;
  final String backgroundColor; // Hex color string (e.g. #FFFFFF)
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

  PromoEntity copyWith({
    String? id,
    Map<String, dynamic>? title,
    Map<String, dynamic>? subtitle,
    Map<String, dynamic>? buttonText,
    String? imageUrl,
    String? backgroundColor,
    String? targetType,
    String? targetId,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return PromoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      buttonText: buttonText ?? this.buttonText,
      imageUrl: imageUrl ?? this.imageUrl,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PromoEntity &&
        other.id == id &&
        _mapEquals(other.title, title) &&
        _mapEquals(other.subtitle, subtitle) &&
        _mapEquals(other.buttonText, buttonText) &&
        other.imageUrl == imageUrl &&
        other.backgroundColor == backgroundColor &&
        other.targetType == targetType &&
        other.targetId == targetId &&
        other.isActive == isActive &&
        other.createdAt == createdAt;
  }

  static bool _mapEquals(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      imageUrl,
      backgroundColor,
      targetType,
      targetId,
      isActive,
      createdAt,
    );
  }

  @override
  String toString() {
    return 'PromoEntity(id: $id, title: $displayTitle, targetType: $targetType, isActive: $isActive)';
  }
}
