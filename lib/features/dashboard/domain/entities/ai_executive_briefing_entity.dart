/// Pure Dart Domain Entity representing a single stock radar alert item.
class StockRadarAlertEntity {
  final String productId;
  final String productName;
  final int currentStock;
  final String riskLevel; // 'out_of_stock' | 'critical' | 'warning'
  final String suggestedAction;
  final String? categoryName;

  const StockRadarAlertEntity({
    required this.productId,
    required this.productName,
    required this.currentStock,
    required this.riskLevel,
    required this.suggestedAction,
    this.categoryName,
  });

  bool get isOutOfStock => riskLevel == 'out_of_stock' || currentStock <= 0;
  bool get isCritical => riskLevel == 'critical' || (currentStock > 0 && currentStock <= 5);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockRadarAlertEntity &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          currentStock == other.currentStock &&
          riskLevel == other.riskLevel;

  @override
  int get hashCode => productId.hashCode ^ currentStock.hashCode ^ riskLevel.hashCode;
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

