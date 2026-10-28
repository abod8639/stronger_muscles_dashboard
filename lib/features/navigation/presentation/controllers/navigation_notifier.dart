import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/features/navigation/domain/entities/navigation_badges_entity.dart';
import 'package:stronger_muscles_dashboard/features/navigation/domain/usecases/get_navigation_badges_usecase.dart';
import 'navigation_providers.dart';

/// State Notifier orchestrating navigation selection, drawer toggling, and badge lifecycle.
/// Adheres to Clean Architecture:
/// - Pure constructor dependency injection (100% testable without global singletons)
/// - Zero try-catch blocks (functional Either handling via fpdart)
class NavigationNotifier extends AsyncNotifier<NavigationState> {
  final GetNavigationBadgesUseCase? _injectedUseCase;
  final AuthService? _injectedAuthService;

  NavigationNotifier([this._injectedUseCase, this._injectedAuthService]);

  @override
  Future<NavigationState> build() async {
    final authService = _injectedAuthService ?? AuthService.instance;
    final role = authService.getUserRole();

    final GetNavigationBadgesUseCase useCase =
        _injectedUseCase ?? ref.watch(getNavigationBadgesUseCaseProvider);

    final badgesResult = await useCase();

    final badges = badgesResult.fold(
      (failure) => const NavigationBadgesEntity.initial(),
      (data) => data,
    );

    return NavigationState(
      selectedIndex: 0,
      isDrawerOpen: false,
      badges: badges,
      userRole: role,
    );
  }

  /// Changes active tab safely within [0, 8] range to prevent crashes
  void selectTab(int index) {
    final current = state.value ?? NavigationState.initial();
    final safeIndex = index.clamp(0, 8);
    state = AsyncValue.data(current.copyWith(selectedIndex: safeIndex));
  }

  /// Opens or closes the sidebar drawer
  void setDrawerOpen(bool isOpen) {
    final current = state.value ?? NavigationState.initial();
    state = AsyncValue.data(current.copyWith(isDrawerOpen: isOpen));
  }

  /// Silently refreshes badge counts in the background without dropping page state
  Future<void> refreshBadges() async {
    final GetNavigationBadgesUseCase useCase =
        _injectedUseCase ?? ref.read(getNavigationBadgesUseCaseProvider);

    final result = await useCase(forceRefresh: true);

    result.fold(
      (failure) {
        // Retain current badges gracefully on failure
      },
      (badges) {
        if (ref.mounted) {
          final current = state.value ?? NavigationState.initial();
          state = AsyncValue.data(current.copyWith(badges: badges));
        }
      },
    );
  }
}
