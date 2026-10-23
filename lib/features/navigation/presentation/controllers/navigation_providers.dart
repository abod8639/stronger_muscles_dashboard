import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import '../../data/datasources/navigation_remote_datasource.dart';
import '../../data/repositories/navigation_repository_impl.dart';
import '../../domain/entities/navigation_badges_entity.dart';
import '../../domain/repositories/navigation_repository.dart';
import '../../domain/usecases/get_navigation_badges_usecase.dart';

/// موفر مصدر بيانات التنقل البعيد
final navigationRemoteDataSourceProvider =
    Provider<NavigationRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return NavigationRemoteDataSourceImpl(dio);
});

/// موفر مستودع التنقل
final navigationRepositoryProvider = Provider<NavigationRepository>((ref) {
  final remoteDataSource = ref.watch(navigationRemoteDataSourceProvider);
  return NavigationRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// موفر حالة استخدام جلب شارات التنقل
final getNavigationBadgesUseCaseProvider =
    Provider<GetNavigationBadgesUseCase>((ref) {
  return GetNavigationBadgesUseCase(ref.watch(navigationRepositoryProvider));
});

/// كائن حالة التنقل العام
class NavigationState {
  final int selectedIndex;
  final bool isDrawerOpen;
  final NavigationBadgesEntity badges;
  final String userRole;

  const NavigationState({
    required this.selectedIndex,
    required this.isDrawerOpen,
    required this.badges,
    required this.userRole,
  });

  factory NavigationState.initial({String userRole = 'admin'}) => NavigationState(
        selectedIndex: 0,
        isDrawerOpen: false,
        badges: NavigationBadgesEntity.initial(),
        userRole: userRole,
      );

  NavigationState copyWith({
    int? selectedIndex,
    bool? isDrawerOpen,
    NavigationBadgesEntity? badges,
    String? userRole,
  }) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
      badges: badges ?? this.badges,
      userRole: userRole ?? this.userRole,
    );
  }
}

/// موفر التحكم بحالة التنقل الرئيسي عبر [AsyncNotifier]
class NavigationNotifier extends AsyncNotifier<NavigationState> {
  CancelToken? _cancelToken;

  @override
  Future<NavigationState> build() async {
    _cancelToken?.cancel('Navigation rebuild');
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    ref.onDispose(() {
      cancelToken.cancel('Navigation page disposed');
    });

    final role = ref.read(authServiceProvider).getUserRole();

    final useCase = ref.watch(getNavigationBadgesUseCaseProvider);
    final badgesResult = await useCase(cancelToken: cancelToken);

    final badges = badgesResult.fold(
      (failure) {
        debugPrint('Navigation badges fallback applied: ${failure.toMessage()}');
        return NavigationBadgesEntity.initial();
      },
      (data) => data,
    );

    return NavigationState(
      selectedIndex: 0,
      isDrawerOpen: false,
      badges: badges,
      userRole: role,
    );
  }

  /// تغيير التبويب بأمان مع حصر المؤشر لتفادي أي انهيار للشاشة
  void selectTab(int index) {
    final current = state.value ?? NavigationState.initial();
    final safeIndex = index.clamp(0, 8);
    state = AsyncValue.data(current.copyWith(selectedIndex: safeIndex));
  }

  /// فتح / إغلاق القائمة الجانبية
  void setDrawerOpen(bool isOpen) {
    final current = state.value ?? NavigationState.initial();
    state = AsyncValue.data(current.copyWith(isDrawerOpen: isOpen));
  }

  /// تحديث الشارات في الخلفية دون إسقاط كامل الشاشة
  Future<void> refreshBadges() async {
    _cancelToken?.cancel('Refresh requested');
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    final useCase = ref.read(getNavigationBadgesUseCaseProvider);
    final result = await useCase(cancelToken: cancelToken);

    result.fold(
      (failure) {
        debugPrint('Refresh navigation badges error: ${failure.toMessage()}');
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

final navigationControllerProvider =
    AsyncNotifierProvider<NavigationNotifier, NavigationState>(
  NavigationNotifier.new,
);

/// موفر مباشر للمؤشر الحالي النشط
final currentNavigationIndexProvider = Provider<int>((ref) {
  final state = ref.watch(navigationControllerProvider);
  return state.value?.selectedIndex ?? 0;
});
