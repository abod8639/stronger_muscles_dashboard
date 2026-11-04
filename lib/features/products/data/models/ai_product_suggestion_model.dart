import '../../domain/entities/ai_product_suggestion_entity.dart';

/// Data model representing AI-generated product specifications from Gemini JSON.
class AiProductSuggestionModel {
  final String nameAr;
  final String nameEn;
  final String descAr;
  final String descEn;
  final String? brandName;
  final String? suggestedCategory;
  final String? servingSize;
  final int? servingsPerContainer;
  final String? calories;
  final String? protein;
  final String? carbs;
  final String? fat;
  final String? sugar;
  final List<String> allergens;
  final List<String> tags;
  final List<String> flavors;
  final List<Map<String, dynamic>> suggestedSizes;
  final String? skuPrefix;

  const AiProductSuggestionModel({
    required this.nameAr,
    required this.nameEn,
    required this.descAr,
    required this.descEn,
    this.brandName,
    this.suggestedCategory,
    this.servingSize,
    this.servingsPerContainer,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.sugar,
    this.allergens = const [],
    this.tags = const [],
    this.flavors = const [],
    this.suggestedSizes = const [],
    this.skuPrefix,
  });

  factory AiProductSuggestionModel.fromJson(Map<String, dynamic> json) {
    List<String> parseStringList(dynamic value) {
      if (value is List) {
        return value
            .map((e) => e.toString().trim())
            .where((s) => s.isNotEmpty)
            .toList();
      }
      return [];
    }

    List<Map<String, dynamic>> parseSizesList(dynamic value) {
      if (value is List) {
        return value
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
      return [];
    }

    final nutrition = json['nutrition_facts'] is Map
        ? json['nutrition_facts'] as Map<String, dynamic>
        : <String, dynamic>{};

    return AiProductSuggestionModel(
      nameAr: json['name_ar']?.toString().trim() ?? '',
      nameEn: json['name_en']?.toString().trim() ?? '',
      descAr: json['desc_ar']?.toString().trim() ?? '',
      descEn: json['desc_en']?.toString().trim() ?? '',
      brandName: json['brand']?.toString().trim(),
      suggestedCategory: json['suggested_category']?.toString().trim(),
      servingSize: json['serving_size']?.toString().trim(),
      servingsPerContainer:
          int.tryParse(json['servings_per_container']?.toString() ?? ''),
      calories:
          nutrition['calories']?.toString() ?? json['calories']?.toString(),
      protein: nutrition['protein']?.toString() ?? json['protein']?.toString(),
      carbs: nutrition['carbs']?.toString() ?? json['carbs']?.toString(),
      fat: nutrition['fat']?.toString() ?? json['fat']?.toString(),
      sugar: nutrition['sugar']?.toString() ?? json['sugar']?.toString(),
      allergens: parseStringList(json['allergens']),
      tags: parseStringList(json['tags']),
      flavors: parseStringList(json['flavors']),
      suggestedSizes: parseSizesList(json['suggested_sizes']),
      skuPrefix: json['sku_prefix']?.toString().trim(),
    );
  }

  AiProductSuggestionEntity toEntity() {
    return AiProductSuggestionEntity(
      nameAr: nameAr,
      nameEn: nameEn,
      descAr: descAr,
      descEn: descEn,
      brandName: brandName,
      suggestedCategory: suggestedCategory,
      servingSize: servingSize,
      servingsPerContainer: servingsPerContainer,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      sugar: sugar,
      allergens: allergens,
      tags: tags,
      flavors: flavors,
      suggestedSizes: suggestedSizes,
      skuPrefix: skuPrefix,
    );
  }
}

