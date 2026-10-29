/// 100% Pure Dart Domain Entity representing aggregated customer support statistics.
/// Adheres strictly to Clean Architecture: Zero dependencies on Flutter UI, Dio, Hive, or 3rd-party SDKs.
class SupportStatsEntity {
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

  const SupportStatsEntity({
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

  const factory SupportStatsEntity.empty() = _EmptySupportStatsEntity;

  SupportStatsEntity copyWith({
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
    return SupportStatsEntity(
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
    return other is SupportStatsEntity &&
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

  @override
  String toString() =>
      'SupportStatsEntity(total: $total, open: $open, inProgress: $inProgress, urgent: $urgent, resolved: $resolved)';
}

class _EmptySupportStatsEntity extends SupportStatsEntity {
  const _EmptySupportStatsEntity() : super();
}
