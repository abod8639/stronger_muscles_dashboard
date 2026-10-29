import 'package:flutter/foundation.dart';
import '../../domain/entities/settings_entity.dart';

/// Immutable presentation state for the Settings module.
@immutable
class SettingsState {
  final bool isLoading;
  final bool isSaving;
  final bool isClearingCache;
  final SettingsEntity settings;
  final String? errorMessage;
  final String? successMessage;

  const SettingsState({
    this.isLoading = false,
    this.isSaving = false,
    this.isClearingCache = false,
    this.settings = const SettingsEntity(),
    this.errorMessage,
    this.successMessage,
  });

  SettingsState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isClearingCache,
    SettingsEntity? settings,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isClearingCache: isClearingCache ?? this.isClearingCache,
      settings: settings ?? this.settings,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsState &&
        other.isLoading == isLoading &&
        other.isSaving == isSaving &&
        other.isClearingCache == isClearingCache &&
        other.settings == settings &&
        other.errorMessage == errorMessage &&
        other.successMessage == successMessage;
  }

  @override
  int get hashCode {
    return Object.hash(
      isLoading,
      isSaving,
      isClearingCache,
      settings,
      errorMessage,
      successMessage,
    );
  }

  @override
  String toString() {
    return 'SettingsState(isLoading: $isLoading, isSaving: $isSaving, settings: $settings)';
  }
}
