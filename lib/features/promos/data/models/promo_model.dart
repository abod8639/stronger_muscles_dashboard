/// Isolated DTO model for promotional banners.
/// Strictly decoupled from Domain Entities with zero entity imports.
class PromoModel {
  final String id;
  final Map<String, dynamic>? title;
  final Map<String, dynamic>? subtitle;
  final Map<String, dynamic>? buttonText;
  final String imageUrl;
  final String backgroundColor;
  final String targetType;
  final String? targetId;
  final bool isActive;
  final DateTime? createdAt;

  const PromoModel({
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

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] is Map ? Map<String, dynamic>.from(json['title'] as Map) : null,
      subtitle: json['subtitle'] is Map ? Map<String, dynamic>.from(json['subtitle'] as Map) : null,
      buttonText: json['button_text'] is Map ? Map<String, dynamic>.from(json['button_text'] as Map) : null,
      imageUrl: json['image_url']?.toString() ?? '',
      backgroundColor: json['background_color']?.toString() ?? '#FFFFFF',
      targetType: json['target_type']?.toString() ?? 'none',
      targetId: json['target_id']?.toString(),
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'button_text': buttonText,
      'image_url': imageUrl,
      'background_color': backgroundColor,
      'target_type': targetType,
      'target_id': targetId,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// Compute parser functions for compute isolate execution
List<PromoModel> parsePromoListCompute(dynamic data) {
  if (data is List) {
    return data
        .whereType<Map>()
        .map((json) => PromoModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  } else if (data is Map && data['data'] is List) {
    return (data['data'] as List)
        .whereType<Map>()
        .map((json) => PromoModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }
  return const [];
}

PromoModel parsePromoCompute(dynamic data) {
  if (data is Map) {
    final map = data['data'] is Map ? data['data'] as Map : data;
    return PromoModel.fromJson(Map<String, dynamic>.from(map));
  }
  return const PromoModel(
    id: '',
    imageUrl: '',
    backgroundColor: '#FFFFFF',
    isActive: false,
  );
}
