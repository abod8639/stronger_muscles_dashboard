/// Pure Dart Domain Entity representing a single stock radar alert item.
class StockRadarAlertEntity {
  final String productId;
  final String productName;
  final int currentStock;
  final int unitsSold; // Verified actual units sold across non-cancelled orders
  final String riskLevel; // 'out_of_stock' | 'critical' | 'warning'
  final String suggestedAction;
  final String? categoryName;

  const StockRadarAlertEntity({
    required this.productId,
    required this.productName,
    required this.currentStock,
    this.unitsSold = 0,
    required this.riskLevel,
    required this.suggestedAction,
    this.categoryName,
  });

  bool get isOutOfStock => riskLevel == 'out_of_stock' || currentStock <= 0;
  bool get isCritical => riskLevel == 'critical' || (currentStock > 0 && currentStock <= 5);
  bool get hasActualSales => unitsSold > 0;

  StockRadarAlertEntity copyWith({
    String? productId,
    String? productName,
    int? currentStock,
    int? unitsSold,
    String? riskLevel,
    String? suggestedAction,
    String? categoryName,
  }) {
    return StockRadarAlertEntity(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      currentStock: currentStock ?? this.currentStock,
      unitsSold: unitsSold ?? this.unitsSold,
      riskLevel: riskLevel ?? this.riskLevel,
      suggestedAction: suggestedAction ?? this.suggestedAction,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockRadarAlertEntity &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          currentStock == other.currentStock &&
          unitsSold == other.unitsSold &&
          riskLevel == other.riskLevel;

  @override
  int get hashCode =>
      productId.hashCode ^
      currentStock.hashCode ^
      unitsSold.hashCode ^
      riskLevel.hashCode;
}

/// Pure Dart Domain Entity representing an AI-generated Executive Briefing & Stock Radar.
class AiExecutiveBriefingEntity {
  final String summary;
  final String sentiment; // 'positive' | 'neutral' | 'needs_attention'
  final List<String> keyInsights;
  final List<String> actionableRecommendations;
  final List<StockRadarAlertEntity> stockAlerts;
  final DateTime generatedAt;
  final String modelUsed;

  const AiExecutiveBriefingEntity({
    required this.summary,
    required this.sentiment,
    required this.keyInsights,
    required this.actionableRecommendations,
    required this.stockAlerts,
    required this.generatedAt,
    required this.modelUsed,
  });

  int get criticalAlertsCount =>
      stockAlerts.where((a) => a.isOutOfStock || a.isCritical).length;

  AiExecutiveBriefingEntity copyWith({
    String? summary,
    String? sentiment,
    List<String>? keyInsights,
    List<String>? actionableRecommendations,
    List<StockRadarAlertEntity>? stockAlerts,
    DateTime? generatedAt,
    String? modelUsed,
  }) {
    return AiExecutiveBriefingEntity(
      summary: summary ?? this.summary,
      sentiment: sentiment ?? this.sentiment,
      keyInsights: keyInsights ?? this.keyInsights,
      actionableRecommendations:
          actionableRecommendations ?? this.actionableRecommendations,
      stockAlerts: stockAlerts ?? this.stockAlerts,
      generatedAt: generatedAt ?? this.generatedAt,
      modelUsed: modelUsed ?? this.modelUsed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiExecutiveBriefingEntity &&
          runtimeType == other.runtimeType &&
          summary == other.summary &&
          generatedAt == other.generatedAt;

  @override
  int get hashCode => summary.hashCode ^ generatedAt.hashCode;
}

