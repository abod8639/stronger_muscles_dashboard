/// Data Transfer Object (DTO) for theme storage and network serialization.
/// Strictly decoupled from Domain Entities with zero entity imports.
class ThemeModel {
  final String mode; // 'light' | 'dark' | 'system'
  final DateTime? updatedAt;

  const ThemeModel({required this.mode, this.updatedAt});

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      mode: json['mode']?.toString() ?? 'dark',
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'mode': mode, 'updated_at': updatedAt?.toIso8601String()};
  }

  static const ThemeModel defaultModel = ThemeModel(mode: 'dark');
}
