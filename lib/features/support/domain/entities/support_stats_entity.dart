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

  factory SupportStatsEntity.empty() => const SupportStatsEntity();
}
