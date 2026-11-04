/// Domain entity representing complete AI-generated product specifications.
class AiProductSuggestionEntity {
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

  const AiProductSuggestionEntity({
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

  AiProductSuggestionEntity copyWith({
    String? nameAr,
    String? nameEn,
    String? descAr,
    String? descEn,
    String? brandName,
    String? suggestedCategory,
    String? servingSize,
    int? servingsPerContainer,
    String? calories,
    String? protein,
    String? carbs,
    String? fat,
    String? sugar,
    List<String>? allergens,
    List<String>? tags,
    List<String>? flavors,
    List<Map<String, dynamic>>? suggestedSizes,
    String? skuPrefix,
  }) {
    return AiProductSuggestionEntity(
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descAr: descAr ?? this.descAr,
      descEn: descEn ?? this.descEn,
      brandName: brandName ?? this.brandName,
      suggestedCategory: suggestedCategory ?? this.suggestedCategory,
      servingSize: servingSize ?? this.servingSize,
      servingsPerContainer: servingsPerContainer ?? this.servingsPerContainer,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      sugar: sugar ?? this.sugar,
      allergens: allergens ?? this.allergens,
      tags: tags ?? this.tags,
      flavors: flavors ?? this.flavors,
      suggestedSizes: suggestedSizes ?? this.suggestedSizes,
      skuPrefix: skuPrefix ?? this.skuPrefix,
    );
  }
}

