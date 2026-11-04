import 'dart:convert';
import 'package:stronger_muscles_dashboard/core/storage/app_storage.dart';
import '../models/ai_executive_briefing_model.dart';

abstract class AiDashboardLocalDataSource {
  Future<AiExecutiveBriefingModel?> getCachedBriefing({
    String focus = 'comprehensive',
    Duration maxAge = const Duration(hours: 2),
  });
  Future<void> cacheBriefing(
    AiExecutiveBriefingModel briefing, {
    String focus = 'comprehensive',
  });
  Future<void> clearCache({String? focus});
}

class AiDashboardLocalDataSourceImpl implements AiDashboardLocalDataSource {
  static const String _storageKey = 'sm_ai_executive_briefing_cache';
  final GetStorage _storage;

  AiDashboardLocalDataSourceImpl({GetStorage? storage})
      : _storage = storage ?? const GetStorage();

  String _getKey(String focus) => '${_storageKey}_$focus';

  @override
  Future<AiExecutiveBriefingModel?> getCachedBriefing({
    String focus = 'comprehensive',
    Duration maxAge = const Duration(hours: 2),
  }) async {
    try {
      final key = _getKey(focus);
      var raw = _storage.read<dynamic>(key);

      // Backward compatibility fallback for default comprehensive key
      if (raw == null && focus == 'comprehensive') {
        raw = _storage.read<dynamic>(_storageKey);
      }

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
  Future<void> cacheBriefing(
    AiExecutiveBriefingModel briefing, {
    String focus = 'comprehensive',
  }) async {
    final encoded = jsonEncode(briefing.toJson());
    await _storage.write(_getKey(focus), encoded);
    if (focus == 'comprehensive') {
      await _storage.write(_storageKey, encoded);
    }
  }

  @override
  Future<void> clearCache({String? focus}) async {
    if (focus != null) {
      await _storage.remove(_getKey(focus));
      if (focus == 'comprehensive') {
        await _storage.remove(_storageKey);
      }
    } else {
      await _storage.remove(_storageKey);
      await _storage.remove(_getKey('comprehensive'));
      await _storage.remove(_getKey('inventory'));
      await _storage.remove(_getKey('sales'));
      await _storage.remove(_getKey('operations'));
    }
  }
}

