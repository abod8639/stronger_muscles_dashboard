import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/theme/data/datasources/theme_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/theme/data/datasources/theme_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/theme/data/models/theme_model.dart';
import 'package:stronger_muscles_dashboard/features/theme/data/repositories/theme_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/theme/domain/entities/app_theme_mode.dart';

class MockThemeLocalDataSource implements ThemeLocalDataSource {
  ThemeModel? storedModel;
  Exception? exceptionToThrow;

  @override
  Future<ThemeModel?> getCachedTheme() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return storedModel;
  }

  @override
  Future<void> cacheTheme(ThemeModel theme) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    storedModel = theme;
  }

  @override
  Future<void> clearCache() async {
    storedModel = null;
  }
}

class MockThemeRemoteDataSource implements ThemeRemoteDataSource {
  ThemeModel? remoteModel;
  Exception? exceptionToThrow;

  @override
  Future<ThemeModel?> getRemoteTheme() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return remoteModel;
  }

  @override
  Future<void> updateRemoteTheme(ThemeModel theme) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    remoteModel = theme;
  }
}

void main() {
  late MockThemeLocalDataSource mockLocal;
  late MockThemeRemoteDataSource mockRemote;
  late ThemeRepositoryImpl repository;

  setUp(() {
    mockLocal = MockThemeLocalDataSource();
    mockRemote = MockThemeRemoteDataSource();
    repository = ThemeRepositoryImpl(
      localDataSource: mockLocal,
      remoteDataSource: mockRemote,
    );
  });

  group('ThemeRepositoryImpl.getTheme', () {
    test('returns cached theme when available in local Hive cache', () async {
      mockLocal.storedModel = const ThemeModel(mode: 'light');

      final result = await repository.getTheme();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.mode, AppThemeMode.light);
        },
      );
    });

    test('checks remote and caches in Hive when local cache is empty', () async {
      mockLocal.storedModel = null;
      mockRemote.remoteModel = const ThemeModel(mode: 'system');

      final result = await repository.getTheme();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.mode, AppThemeMode.system);
        },
      );
      expect(mockLocal.storedModel?.mode, 'system');
    });

    test('defaults to dark mode when both local and remote are empty', () async {
      mockLocal.storedModel = null;
      mockRemote.remoteModel = null;

      final result = await repository.getTheme();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.mode, AppThemeMode.dark);
        },
      );
    });

    test('returns Left(Failure) when local cache throws an unexpected error', () async {
      mockLocal.exceptionToThrow = CacheException(message: 'Disk error');

      final result = await repository.getTheme();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (_) => fail('Expected Left'),
      );
    });
  });

  group('ThemeRepositoryImpl.setTheme & toggleTheme', () {
    test('setTheme updates local Hive cache and remote sync', () async {
      final result = await repository.setTheme(AppThemeMode.light);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.mode, AppThemeMode.light);
        },
      );
      expect(mockLocal.storedModel?.mode, 'light');
      expect(mockRemote.remoteModel?.mode, 'light');
    });

    test('toggleTheme toggles from dark to light', () async {
      mockLocal.storedModel = const ThemeModel(mode: 'dark');

      final result = await repository.toggleTheme();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.mode, AppThemeMode.light);
        },
      );
      expect(mockLocal.storedModel?.mode, 'light');
    });
  });
}
