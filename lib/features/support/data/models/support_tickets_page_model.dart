import 'support_stats_model.dart';
import 'support_ticket_model.dart';

/// Isolated Data Transfer Object (DTO) for paginated ticket list response.
class SupportTicketsPageModel {
  final List<SupportTicketModel> tickets;
  final SupportStatsModel stats;
  final int currentPage;
  final int totalCount;
  final bool hasMore;

  const SupportTicketsPageModel({
    required this.tickets,
    required this.stats,
    this.currentPage = 1,
    this.totalCount = 0,
    this.hasMore = false,
  });

  factory SupportTicketsPageModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> items = json['data'] is List
        ? json['data'] as List
        : (json['tickets'] is List ? json['tickets'] as List : []);

    final tickets = items
        .whereType<Map>()
        .map((j) => SupportTicketModel.fromJson(Map<String, dynamic>.from(j)))
        .toList();

    final statsMap = json['stats'] is Map
        ? Map<String, dynamic>.from(json['stats'] as Map)
        : <String, dynamic>{};
    final stats = SupportStatsModel.fromJson(statsMap);

    final meta = json['meta'] is Map ? json['meta'] as Map : {};
    final currentPage =
        (meta['current_page'] as num?)?.toInt() ??
        (json['current_page'] as num?)?.toInt() ??
        1;
    final lastPage =
        (meta['last_page'] as num?)?.toInt() ??
        (json['last_page'] as num?)?.toInt() ??
        1;
    final total =
        (meta['total'] as num?)?.toInt() ??
        (json['total'] as num?)?.toInt() ??
        tickets.length;

    return SupportTicketsPageModel(
      tickets: tickets,
      stats: stats,
      currentPage: currentPage,
      totalCount: total,
      hasMore: currentPage < lastPage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': tickets.map((t) => t.toJson()).toList(),
      'stats': stats.toJson(),
      'meta': {'current_page': currentPage, 'total': totalCount},
      'has_more': hasMore,
    };
  }
}
