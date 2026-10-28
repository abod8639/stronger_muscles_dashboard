/// Isolated Data Transfer Object (DTO) for support dashboard metrics.
/// Strictly decoupled from Domain Entities with serialization / deserialization support.
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

  const SupportStatsModel({
    this.total = 0,
    this.open = 0,
    this.inProgress = 0,
    this.waitingUser = 0,
    this.resolved = 0,
    this.closed = 0,
    this.urgent = 0,
    this.resolvedToday = 0,
    this.byCategory = const {},
    this.byPriority = const {},
  });

  factory SupportStatsModel.fromJson(Map<String, dynamic> json) {
    Map<String, int> parseMap(dynamic map) {
      if (map is Map) {
        return map.map((key, value) =>
            MapEntry(key.toString(), (value as num?)?.toInt() ?? 0));
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

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'open': open,
      'in_progress': inProgress,
      'waiting_user': waitingUser,
      'resolved': resolved,
      'closed': closed,
      'urgent': urgent,
      'resolved_today': resolvedToday,
      'by_category': byCategory,
      'by_priority': byPriority,
    };
  }

  SupportStatsModel copyWith({
    int? total,
    int? open,
    int? inProgress,
    int? waitingUser,
    int? resolved,
    int? closed,
    int? urgent,
    int? resolvedToday,
    Map<String, int>? byCategory,
    Map<String, int>? byPriority,
  }) {
    return SupportStatsModel(
      total: total ?? this.total,
      open: open ?? this.open,
      inProgress: inProgress ?? this.inProgress,
      waitingUser: waitingUser ?? this.waitingUser,
      resolved: resolved ?? this.resolved,
      closed: closed ?? this.closed,
      urgent: urgent ?? this.urgent,
      resolvedToday: resolvedToday ?? this.resolvedToday,
      byCategory: byCategory ?? this.byCategory,
      byPriority: byPriority ?? this.byPriority,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupportStatsModel &&
        other.total == total &&
        other.open == open &&
        other.inProgress == inProgress &&
        other.waitingUser == waitingUser &&
        other.resolved == resolved &&
        other.closed == closed &&
        other.urgent == urgent &&
        other.resolvedToday == resolvedToday;
  }

  @override
  int get hashCode => Object.hash(
        total,
        open,
        inProgress,
        waitingUser,
        resolved,
        closed,
        urgent,
        resolvedToday,
      );
}
