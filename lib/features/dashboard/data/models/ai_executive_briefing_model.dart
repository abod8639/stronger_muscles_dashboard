import '../../domain/entities/ai_executive_briefing_entity.dart';

class StockRadarAlertModel {
  final String productId;
  final String productName;
  final int currentStock;
  final String riskLevel;
  final String suggestedAction;
  final String? categoryName;

  const StockRadarAlertModel({
    required this.productId,
    required this.productName,
    required this.currentStock,
    required this.riskLevel,
    required this.suggestedAction,
    this.categoryName,
  });

  factory StockRadarAlertModel.fromJson(Map<String, dynamic> json) {
    return StockRadarAlertModel(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? 'منتج غير معروف',
      currentStock: int.tryParse(json['current_stock']?.toString() ?? '0') ?? 0,
      riskLevel: json['risk_level']?.toString() ?? 'warning',
      suggestedAction: json['suggested_action']?.toString() ?? 'مراجعة المخزون',
      categoryName: json['category_name']?.toString(),
    );
  }

  factory StockRadarAlertModel.fromEntity(StockRadarAlertEntity entity) {
    return StockRadarAlertModel(
      productId: entity.productId,
      productName: entity.productName,
      currentStock: entity.currentStock,
      riskLevel: entity.riskLevel,
      suggestedAction: entity.suggestedAction,
      categoryName: entity.categoryName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'current_stock': currentStock,
      'risk_level': riskLevel,
      'suggested_action': suggestedAction,
      if (categoryName != null) 'category_name': categoryName,
    };
  }

  StockRadarAlertEntity toEntity() {
    return StockRadarAlertEntity(
      productId: productId,
      productName: productName,
      currentStock: currentStock,
      riskLevel: riskLevel,
      suggestedAction: suggestedAction,
      categoryName: categoryName,
    );
  }
}

class AiExecutiveBriefingModel {
  final String summary;
  final String sentiment;
  final List<String> keyInsights;
  final List<String> actionableRecommendations;
  final List<StockRadarAlertModel> stockAlerts;
  final DateTime generatedAt;
  final String modelUsed;

  const AiExecutiveBriefingModel({
    required this.summary,
    required this.sentiment,
    required this.keyInsights,
    required this.actionableRecommendations,
    required this.stockAlerts,
    required this.generatedAt,
    required this.modelUsed,
  });

  factory AiExecutiveBriefingModel.fromJson(
    Map<String, dynamic> json, {
    String? modelUsed,
    DateTime? generatedAt,
  }) {
    final insightsRaw = json['key_insights'] ?? json['keyInsights'];
    final recommendationsRaw = json['recommendations'] ??
        json['actionable_recommendations'] ??
        json['actionableRecommendations'];
    final alertsRaw = json['stock_alerts'] ?? json['stockAlerts'];

    return AiExecutiveBriefingModel(
      summary: json['summary']?.toString() ?? 'لا يوجد ملخص متاح حالياً.',
      sentiment: json['sentiment']?.toString() ?? 'neutral',
      keyInsights: (insightsRaw as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      actionableRecommendations: (recommendationsRaw as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      stockAlerts: (alertsRaw as List<dynamic>?)
              ?.filter((e) => e is Map)
              .map((e) => StockRadarAlertModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList() ??
          const [],
      generatedAt: json['generated_at'] != null
          ? DateTime.tryParse(json['generated_at'].toString()) ??
              generatedAt ??
              DateTime.now()
          : generatedAt ?? DateTime.now(),
      modelUsed: json['model_used']?.toString() ?? modelUsed ?? 'gemini-3.5-flash',
    );
  }

  factory AiExecutiveBriefingModel.fromEntity(AiExecutiveBriefingEntity entity) {
    return AiExecutiveBriefingModel(
      summary: entity.summary,
      sentiment: entity.sentiment,
      keyInsights: List<String>.from(entity.keyInsights),
      actionableRecommendations:
          List<String>.from(entity.actionableRecommendations),
      stockAlerts: entity.stockAlerts
          .map((a) => StockRadarAlertModel.fromEntity(a))
          .toList(),
      generatedAt: entity.generatedAt,
      modelUsed: entity.modelUsed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'sentiment': sentiment,
      'key_insights': keyInsights,
      'recommendations': actionableRecommendations,
      'stock_alerts': stockAlerts.map((a) => a.toJson()).toList(),
      'generated_at': generatedAt.toIso8601String(),
      'model_used': modelUsed,
    };
  }

  AiExecutiveBriefingEntity toEntity() {
    return AiExecutiveBriefingEntity(
      summary: summary,
      sentiment: sentiment,
      keyInsights: keyInsights,
      actionableRecommendations: actionableRecommendations,
      stockAlerts: stockAlerts.map((a) => a.toEntity()).toList(),
      generatedAt: generatedAt,
      modelUsed: modelUsed,
    );
  }
}

extension _IterableFilter<T> on Iterable<T> {
  Iterable<T> filter(bool Function(T) test) sync* {
    for (final element in this) {
      if (test(element)) yield element;
    }
  }
}

