import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_providers.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/repositories/order_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/repositories/order_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/data/datasources/product_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/products/data/repositories/product_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/repositories/product_repository.dart';
import 'package:stronger_muscles_dashboard/features/users/data/datasources/user_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/users/data/repositories/user_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/users/domain/repositories/user_repository.dart';
import 'package:stronger_muscles_dashboard/core/network/api/user_service.dart';

/// موفر مستودع الطلبات مع دعم التوافق مع GetX
final dashboardOrderRepositoryProvider = Provider<OrderRepository>((ref) {
  if (Get.isRegistered<OrderRepository>()) {
    return Get.find<OrderRepository>();
  }
  final dio = ref.watch(dioProvider);
  return OrderRepositoryImpl(remoteDataSource: OrderRemoteDataSourceImpl(dio));
});

/// موفر مستودع المنتجات مع دعم التوافق مع GetX
final dashboardProductRepositoryProvider = Provider<ProductRepository>((ref) {
  if (Get.isRegistered<ProductRepository>()) {
    return Get.find<ProductRepository>();
  }
  final dio = ref.watch(dioProvider);
  return ProductRepositoryImpl(remoteDataSource: ProductRemoteDataSourceImpl(dio));
});

/// موفر مستودع المستخدمين مع دعم التوافق مع GetX
final dashboardUserRepositoryProvider = Provider<UserRepository>((ref) {
  if (Get.isRegistered<UserRepository>()) {
    return Get.find<UserRepository>();
  }
  final userService = Get.isRegistered<UserService>() ? Get.find<UserService>() : UserService();
  return UserRepositoryImpl(UserRemoteDataSourceImpl(userService));
});

/// موفر مستودع لوحة التحكم الرئيسي
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    orderRepository: ref.watch(dashboardOrderRepositoryProvider),
    productRepository: ref.watch(dashboardProductRepositoryProvider),
    categoryRepository: ref.watch(categoryRepositoryProvider),
    userRepository: ref.watch(dashboardUserRepositoryProvider),
  );
});

/// موفر حالة استخدام جلب بيانات لوحة التحكم
final getDashboardDataUseCaseProvider = Provider<GetDashboardDataUseCase>((ref) {
  return GetDashboardDataUseCase(ref.watch(dashboardRepositoryProvider));
});

/// موفر فترة العرض المحددة (week / month / year)
class DashboardPeriodNotifier extends Notifier<String> {
  @override
  String build() => 'week';

  void setPeriod(String period) => state = period;
}

final dashboardPeriodProvider =
    NotifierProvider<DashboardPeriodNotifier, String>(DashboardPeriodNotifier.new);

/// موفر حالة لوحة التحكم الرئيسي عبر [AsyncNotifier] مع إدارة الإلغاء ومنع تسريب الموارد
class DashboardStatsNotifier extends AsyncNotifier<DashboardStatsEntity> {
  CancelToken? _cancelToken;

  @override
  Future<DashboardStatsEntity> build() async {
    _cancelToken?.cancel('Dashboard notifier disposed or reinitialized');
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    ref.onDispose(() {
      cancelToken.cancel('Dashboard page closed');
    });

    final useCase = ref.watch(getDashboardDataUseCaseProvider);
    final result = await useCase(cancelToken: cancelToken);

    return result.fold(
      (failure) => throw failure,
      (stats) => stats,
    );
  }

  /// إعادة تحميل بيانات لوحة التحكم
  Future<void> refreshDashboard() async {
    state = const AsyncValue.loading();
    _cancelToken?.cancel('User requested refresh');
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    final useCase = ref.read(getDashboardDataUseCaseProvider);
    final result = await useCase(cancelToken: cancelToken);

    if (ref.exists(dashboardStatsNotifierProvider)) {
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (stats) => AsyncValue.data(stats),
      );
    }
  }
}

final dashboardStatsNotifierProvider =
    AsyncNotifierProvider<DashboardStatsNotifier, DashboardStatsEntity>(
  DashboardStatsNotifier.new,
);
