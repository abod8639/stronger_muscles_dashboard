import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/theme/data/mappers/theme_mapper.dart';
import 'package:stronger_muscles_dashboard/features/theme/data/models/theme_model.dart';
import 'package:stronger_muscles_dashboard/features/theme/domain/entities/app_theme_mode.dart';
import 'package:stronger_muscles_dashboard/features/theme/domain/entities/theme_entity.dart';
import 'package:stronger_muscles_dashboard/features/theme/presentation/controllers/theme_state.dart';

void main() {
  group('AppThemeMode & ThemeEntity Tests', () {
    test('AppThemeMode enum properties and parsing', () {
      expect(AppThemeMode.light.isLight, isTrue);
      expect(AppThemeMode.dark.isDark, isTrue);
      expect(AppThemeMode.system.isSystem, isTrue);

      expect(AppThemeMode.fromString('light'), AppThemeMode.light);
      expect(AppThemeMode.fromString('dark'), AppThemeMode.dark);
      expect(AppThemeMode.fromString('system'), AppThemeMode.system);
      expect(AppThemeMode.fromString('unknown'), AppThemeMode.dark);
    });

    test('ThemeEntity equality, hashCode, and copyWith', () {
      final now = DateTime(2026, 1, 1);
      final t1 = ThemeEntity(mode: AppThemeMode.dark, updatedAt: now);
      final t2 = ThemeEntity(mode: AppThemeMode.dark, updatedAt: now);
      final t3 = t1.copyWith(mode: AppThemeMode.light);

      expect(t1, equals(t2));
      expect(t1.hashCode, equals(t2.hashCode));
      expect(t1, isNot(equals(t3)));
      expect(t3.mode, AppThemeMode.light);
    });

    test('ThemeState maps AppThemeMode correctly to Flutter ThemeMode', () {
      const darkState = ThemeState(theme: ThemeEntity(mode: AppThemeMode.dark));
      expect(darkState.flutterThemeMode, ThemeMode.dark);

      const lightState = ThemeState(theme: ThemeEntity(mode: AppThemeMode.light));
      expect(lightState.flutterThemeMode, ThemeMode.light);

      const systemState = ThemeState(theme: ThemeEntity(mode: AppThemeMode.system));
      expect(systemState.flutterThemeMode, ThemeMode.system);
    });
  });

  group('ThemeModel & Mapper Tests', () {
    test('ThemeModel serialization and bidirectional mapping', () {
      final json = {'mode': 'light', 'updated_at': '2026-03-01T10:00:00.000'};
      final model = ThemeModel.fromJson(json);

      expect(model.mode, 'light');
      expect(model.updatedAt, DateTime.parse('2026-03-01T10:00:00.000'));

      final entity = model.toEntity();
      expect(entity.mode, AppThemeMode.light);

      final backToModel = entity.toModel();
      expect(backToModel.mode, 'light');
      expect(backToModel.toJson()['mode'], 'light');
    });
  });
}
