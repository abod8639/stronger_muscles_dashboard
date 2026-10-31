import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Modern, cross-platform local storage implementation backed by [SharedPreferences]
/// with an automatic in-memory fallback for testing environments.
/// 100% compatible with Flutter Web (including WebAssembly / WASM), Desktop, and Mobile.
class GetStorage {
  final String? container;
  const GetStorage([this.container]);

  static SharedPreferences? _prefs;
  static final Map<String, dynamic> _memoryFallback = {};
  static bool _useMemoryFallback = false;

  static Future<void> init([String? container]) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
    } catch (_) {
      _useMemoryFallback = true;
    }
  }

  static SharedPreferences? get prefs => _prefs;

  T? read<T>(String key) {
    if (_useMemoryFallback || _prefs == null) {
      final val = _memoryFallback[key];
      if (val is T) return val;
      return null;
    }

    final val = _prefs!.get(key);
    if (val == null) return null;
    if (val is T) return val as T;
    if (T == Map || T == (Map<String, dynamic>)) {
      if (val is String) {
        try {
          final decoded = jsonDecode(val);
          if (decoded is T) return decoded;
          return null;
        } catch (_) {
          return null;
        }
      }
    }
    return null;
  }

  Future<void> write(String key, dynamic value) async {
    if (_useMemoryFallback || _prefs == null) {
      _memoryFallback[key] = value;
      return;
    }

    try {
      if (value is String) {
        await _prefs!.setString(key, value);
      } else if (value is int) {
        await _prefs!.setInt(key, value);
      } else if (value is double) {
        await _prefs!.setDouble(key, value);
      } else if (value is bool) {
        await _prefs!.setBool(key, value);
      } else if (value is List<String>) {
        await _prefs!.setStringList(key, value);
      } else {
        await _prefs!.setString(key, jsonEncode(value));
      }
    } catch (_) {
      _memoryFallback[key] = value;
    }
  }

  Future<void> remove(String key) async {
    _memoryFallback.remove(key);
    try {
      await _prefs?.remove(key);
    } catch (_) {}
  }

  Future<void> erase() async {
    _memoryFallback.clear();
    try {
      await _prefs?.clear();
    } catch (_) {}
  }
}
