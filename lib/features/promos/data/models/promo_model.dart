import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';

class PromoModel {
  final String id;
  final Map<String, dynamic>? title;
  final Map<String, dynamic>? subtitle;
  final Map<String, dynamic>? buttonText;
  final String imageUrl;
  final String backgroundColor;
  final String? targetUrl;
  final bool isActive;
  final DateTime? createdAt;

  PromoModel({
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

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] is Map ? Map<String, dynamic>.from(json['title']) : null,
      subtitle: json['subtitle'] is Map ? Map<String, dynamic>.from(json['subtitle']) : null,
      buttonText: json['button_text'] is Map ? Map<String, dynamic>.from(json['button_text']) : null,
      imageUrl: json['image_url'] ?? '',
      backgroundColor: json['background_color'] ?? '#FFFFFF',
      targetUrl: json['target_url'],
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
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
      'target_url': targetUrl,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  PromoEntity toEntity() {
    return PromoEntity(
      id: id,
      title: title,
      subtitle: subtitle,
      buttonText: buttonText,
      imageUrl: imageUrl,
      backgroundColor: backgroundColor,
      targetUrl: targetUrl,
      isActive: isActive,
      createdAt: createdAt,
    );
  }

  factory PromoModel.fromEntity(PromoEntity entity) {
    return PromoModel(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      buttonText: entity.buttonText,
      imageUrl: entity.imageUrl,
      backgroundColor: entity.backgroundColor,
      targetUrl: entity.targetUrl,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }
}
