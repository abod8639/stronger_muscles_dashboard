import 'dart:convert';
import 'package:stronger_muscles_dashboard/core/storage/app_storage.dart';
import '../models/product_draft_model.dart';

abstract class ProductDraftLocalDataSource {
  Future<List<ProductDraftModel>> getDrafts();
  Future<ProductDraftModel> saveDraft(ProductDraftModel draft);
  Future<void> deleteDraft(String draftId);
  Future<void> clearAllDrafts();
}

class ProductDraftLocalDataSourceImpl implements ProductDraftLocalDataSource {
  static const String _storageKey = 'sm_product_drafts_v1';
  final GetStorage _storage;

  ProductDraftLocalDataSourceImpl({GetStorage? storage})
      : _storage = storage ?? const GetStorage();

  @override
  Future<List<ProductDraftModel>> getDrafts() async {
    try {
      final raw = _storage.read<dynamic>(_storageKey);
      if (raw == null) return [];

      List<dynamic> list;
      if (raw is String) {
        list = jsonDecode(raw) as List<dynamic>;
      } else if (raw is List) {
        list = raw;
      } else {
        return [];
      }

      final drafts = <ProductDraftModel>[];
      for (final item in list) {
        if (item is Map) {
          drafts.add(
            ProductDraftModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }

      // Sort drafts by updatedAt descending (newest first)
      drafts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return drafts;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<ProductDraftModel> saveDraft(ProductDraftModel draft) async {
    final currentDrafts = await getDrafts();
    final index = currentDrafts.indexWhere((d) => d.id == draft.id);

    if (index >= 0) {
      currentDrafts[index] = draft;
    } else {
      currentDrafts.insert(0, draft);
    }

    // Persist as JSON string
    final encoded = jsonEncode(currentDrafts.map((d) => d.toJson()).toList());
    await _storage.write(_storageKey, encoded);
    return draft;
  }

  @override
  Future<void> deleteDraft(String draftId) async {
    final currentDrafts = await getDrafts();
    currentDrafts.removeWhere((d) => d.id == draftId);
    final encoded = jsonEncode(currentDrafts.map((d) => d.toJson()).toList());
    await _storage.write(_storageKey, encoded);
  }

  @override
  Future<void> clearAllDrafts() async {
    await _storage.remove(_storageKey);
  }
}

