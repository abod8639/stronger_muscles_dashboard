import 'support_stats_entity.dart';
import 'support_ticket_entity.dart';

/// 100% Pure Dart Domain Entity representing a paginated list of support tickets with stats.
/// Adheres strictly to Clean Architecture: Zero dependencies on Flutter UI, Dio, Hive, or 3rd-party SDKs.
class SupportTicketsPageEntity {
  final List<SupportTicketEntity> tickets;
  final SupportStatsEntity stats;
  final int currentPage;
  final int totalCount;
  final bool hasMore;

  const SupportTicketsPageEntity({
    required this.tickets,
    required this.stats,
    this.currentPage = 1,
    this.totalCount = 0,
    this.hasMore = false,
  });

  SupportTicketsPageEntity copyWith({
    List<SupportTicketEntity>? tickets,
    SupportStatsEntity? stats,
    int? currentPage,
    int? totalCount,
    bool? hasMore,
  }) {
    return SupportTicketsPageEntity(
      tickets: tickets ?? this.tickets,
      stats: stats ?? this.stats,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupportTicketsPageEntity &&
        other.stats == stats &&
        other.currentPage == currentPage &&
        other.totalCount == totalCount &&
        other.hasMore == hasMore &&
        _listEquals(other.tickets, tickets);
  }

  static bool _listEquals(
    List<SupportTicketEntity> a,
    List<SupportTicketEntity> b,
  ) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(tickets),
    stats,
    currentPage,
    totalCount,
    hasMore,
  );

  @override
  String toString() =>
      'SupportTicketsPageEntity(tickets: ${tickets.length}, stats: $stats, page: $currentPage, hasMore: $hasMore)';
}
