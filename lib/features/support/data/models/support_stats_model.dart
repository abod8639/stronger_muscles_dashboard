import '../../domain/entities/support_stats_entity.dart';

class SupportStatsModel {
  final int total;
  final int open;
  final int inProgress;
  final int waitingUser;
  final int resolved;
  final int closed;
  final int urgent;
  final int resolvedToday;
  final Map<String, int> byCategory;
  final Map<String, int> byPriority;

  SupportStatsModel({
    required this.total,
    required this.open,
    required this.inProgress,
    required this.waitingUser,
    required this.resolved,
    required this.closed,
    required this.urgent,
    required this.resolvedToday,
    required this.byCategory,
    required this.byPriority,
  });

  factory SupportStatsModel.fromJson(Map<String, dynamic> json) {
    Map<String, int> parseMap(dynamic map) {
      if (map is Map) {
        return map.map((key, value) => MapEntry(key.toString(), (value as num).toInt()));
      }
      return {};
    }

    return SupportStatsModel(
      total: (json['total'] as num?)?.toInt() ?? 0,
      open: (json['open'] as num?)?.toInt() ?? 0,
      inProgress: (json['in_progress'] as num?)?.toInt() ?? 0,
      waitingUser: (json['waiting_user'] as num?)?.toInt() ?? 0,
      resolved: (json['resolved'] as num?)?.toInt() ?? 0,
      closed: (json['closed'] as num?)?.toInt() ?? 0,
      urgent: (json['urgent'] as num?)?.toInt() ?? 0,
      resolvedToday: (json['resolved_today'] as num?)?.toInt() ?? 0,
      byCategory: parseMap(json['by_category']),
      byPriority: parseMap(json['by_priority']),
    );
  }

  SupportStatsEntity toEntity() {
    return SupportStatsEntity(
      total: total,
      open: open,
      inProgress: inProgress,
      waitingUser: waitingUser,
      resolved: resolved,
      closed: closed,
      urgent: urgent,
      resolvedToday: resolvedToday,
      byCategory: byCategory,
      byPriority: byPriority,
    );
  }
}
