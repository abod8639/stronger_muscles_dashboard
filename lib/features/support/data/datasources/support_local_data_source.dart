import 'package:hive_ce/hive.dart';
import '../models/support_stats_model.dart';
import '../models/support_ticket_model.dart';
import '../models/support_tickets_page_model.dart';

abstract class SupportLocalDataSource {
  Future<void> cacheTicketsPage(SupportTicketsPageModel page);
  Future<SupportTicketsPageModel?> getCachedTicketsPage();
  Future<void> cacheTicketDetail(SupportTicketModel ticket);
  Future<SupportTicketModel?> getCachedTicketDetail(int ticketId);
  Future<void> cacheStats(SupportStatsModel stats);
  Future<SupportStatsModel?> getCachedStats();
  Future<void> clearCache();
}

/// Hive-backed implementation of [SupportLocalDataSource].
/// Strict Constructor Dependency Injection of [Box] for 100% mockability and testability.
class SupportLocalDataSourceImpl implements SupportLocalDataSource {
  final Box _box;

  static const String _kTicketsPageKey = 'cached_tickets_page';
  static const String _kStatsKey = 'cached_stats';
  static const String _kTicketPrefix = 'cached_ticket_';

  const SupportLocalDataSourceImpl({required Box box}) : _box = box;

  @override
  Future<void> cacheTicketsPage(SupportTicketsPageModel page) async {
    await _box.put(_kTicketsPageKey, page.toJson());
  }

  @override
  Future<SupportTicketsPageModel?> getCachedTicketsPage() async {
    final raw = _box.get(_kTicketsPageKey);
    if (raw == null) return null;
    if (raw is Map) {
      return SupportTicketsPageModel.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  @override
  Future<void> cacheTicketDetail(SupportTicketModel ticket) async {
    await _box.put('$_kTicketPrefix${ticket.id}', ticket.toJson());
  }

  @override
  Future<SupportTicketModel?> getCachedTicketDetail(int ticketId) async {
    final raw = _box.get('$_kTicketPrefix$ticketId');
    if (raw == null) return null;
    if (raw is Map) {
      return SupportTicketModel.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  @override
  Future<void> cacheStats(SupportStatsModel stats) async {
    await _box.put(_kStatsKey, stats.toJson());
  }

  @override
  Future<SupportStatsModel?> getCachedStats() async {
    final raw = _box.get(_kStatsKey);
    if (raw == null) return null;
    if (raw is Map) {
      return SupportStatsModel.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await _box.clear();
  }
}
