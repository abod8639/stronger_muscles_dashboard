import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/usecases/clear_app_cache_usecase.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';
import 'settings_providers.dart';
import 'settings_state.dart';

/// Presentation state controller for managing application & store settings.
/// Strictly adheres to:
/// - Immutable states
/// - Zero raw try-catch blocks (pure fpdart functional error handling)
/// - Guard clauses against duplicate mutations
/// - 100% unit testable via constructor dependency injection
class SettingsController extends Notifier<SettingsState> {
  final GetSettingsUseCase? _injectedGetSettingsUseCase;
  final UpdateSettingsUseCase? _injectedUpdateSettingsUseCase;
  final ClearAppCacheUseCase? _injectedClearAppCacheUseCase;

  SettingsController({
    GetSettingsUseCase? getSettingsUseCase,
    UpdateSettingsUseCase? updateSettingsUseCase,
    ClearAppCacheUseCase? clearAppCacheUseCase,
  }) : _injectedGetSettingsUseCase = getSettingsUseCase,
       _injectedUpdateSettingsUseCase = updateSettingsUseCase,
       _injectedClearAppCacheUseCase = clearAppCacheUseCase;

  GetSettingsUseCase get _getSettingsUseCase =>
      _injectedGetSettingsUseCase ?? ref.read(getSettingsUseCaseProvider);

  UpdateSettingsUseCase get _updateSettingsUseCase =>
      _injectedUpdateSettingsUseCase ?? ref.read(updateSettingsUseCaseProvider);

  ClearAppCacheUseCase get _clearAppCacheUseCase =>
      _injectedClearAppCacheUseCase ?? ref.read(clearAppCacheUseCaseProvider);

  @override
  SettingsState build() {
    // Automatically load settings on build
    Future.microtask(() => fetchSettings());
    return const SettingsState(isLoading: true);
  }

  Future<void> fetchSettings() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getSettingsUseCase.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.toMessage(),
        );
      },
      (settings) {
        state = state.copyWith(
          isLoading: false,
          settings: settings,
          clearError: true,
        );
      },
    );
  }

  Future<bool> saveSettings(SettingsEntity updatedSettings) async {
    // Guard clause against concurrent submissions
    if (state.isSaving) return false;

    state = state.copyWith(
      isSaving: true,
      clearError: true,
      clearSuccess: true,
    );

    final result = await _updateSettingsUseCase.call(updatedSettings);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: failure.toMessage(),
        );
        AppFeedback.showError(failure.toMessage());
        return false;
      },
      (savedSettings) {
        state = state.copyWith(
          isSaving: false,
          settings: savedSettings,
          successMessage: 'تم حفظ إعدادات المتجر بنجاح',
          clearError: true,
        );
        AppFeedback.showSuccess('تم حفظ إعدادات المتجر بنجاح');
        return true;
      },
    );
  }

  Future<bool> toggleStoreOpen(bool isOpen) async {
    final updated = state.settings.copyWith(isStoreOpen: isOpen);
    return await saveSettings(updated);
  }

  Future<bool> toggleMaintenanceMode(bool isMaintenance) async {
    final updated = state.settings.copyWith(maintenanceMode: isMaintenance);
    return await saveSettings(updated);
  }

  Future<bool> toggleOrderNotifications(bool isEnabled) async {
    final updated = state.settings.copyWith(
      orderNotificationsEnabled: isEnabled,
    );
    return await saveSettings(updated);
  }

  Future<bool> clearCache() async {
    if (state.isClearingCache) return false;

    state = state.copyWith(isClearingCache: true, clearError: true);

    final result = await _clearAppCacheUseCase.call();

    return result.fold(
      (failure) {
        state = state.copyWith(
          isClearingCache: false,
          errorMessage: failure.toMessage(),
        );
        AppFeedback.showError(failure.toMessage());
        return false;
      },
      (_) {
        state = state.copyWith(
          isClearingCache: false,
          successMessage: 'تم تفريغ ذاكرة التخزين المؤقت بنجاح',
          clearError: true,
        );
        AppFeedback.showSuccess('تم تفريغ ذاكرة التخزين المؤقت بنجاح');
        return true;
      },
    );
  }
}
