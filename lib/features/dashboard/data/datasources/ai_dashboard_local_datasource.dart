import 'dart:convert';
import 'package:stronger_muscles_dashboard/core/storage/app_storage.dart';
import '../models/ai_executive_briefing_model.dart';

abstract class AiDashboardLocalDataSource {
  Future<AiExecutiveBriefingModel?> getCachedBriefing({
    Duration maxAge = const Duration(hours: 2),
  });
  Future<void> cacheBriefing(AiExecutiveBriefingModel briefing);
  Future<void> clearCache();
}

class AiDashboardLocalDataSourceImpl implements AiDashboardLocalDataSource {
  static const String _storageKey = 'sm_ai_executive_briefing_cache';
  final GetStorage _storage;

  AiDashboardLocalDataSourceImpl({GetStorage? storage})
      : _storage = storage ?? const GetStorage();

  @override
  Future<AiExecutiveBriefingModel?> getCachedBriefing({
    Duration maxAge = const Duration(hours: 2),
  }) async {
    try {
      final raw = _storage.read<dynamic>(_storageKey);
      if (raw == null) return null;

      Map<String, dynamic> data;
      if (raw is String) {
        data = jsonDecode(raw) as Map<String, dynamic>;
      } else if (raw is Map) {
        data = Map<String, dynamic>.from(raw);
      } else {
        return null;
      }

      final model = AiExecutiveBriefingModel.fromJson(data);
      final age = DateTime.now().difference(model.generatedAt);
      if (age > maxAge) {
        // Cache expired
        return null;
      }
      return model;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheBriefing(AiExecutiveBriefingModel briefing) async {
    final encoded = jsonEncode(briefing.toJson());
    await _storage.write(_storageKey, encoded);
  }

  @override
  Future<void> clearCache() async {
    await _storage.remove(_storageKey);
  }
}

