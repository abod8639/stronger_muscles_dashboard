import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/admin_notification_entity.dart';
import '../../domain/entities/notifications_result_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/notification_usecases.dart';

/// موفر مصدر بيانات الإشعارات البعيد
final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return NotificationRemoteDataSourceImpl(dio: dio);
});

/// موفر مستودع الإشعارات
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final remoteDataSource = ref.watch(notificationRemoteDataSourceProvider);
  return NotificationRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// موفرات حالات الاستخدام
final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((ref) {
  return GetNotificationsUseCase(ref.watch(notificationRepositoryProvider));
});

final sendNotificationUseCaseProvider = Provider<SendNotificationUseCase>((ref) {
  return SendNotificationUseCase(ref.watch(notificationRepositoryProvider));
});

final deleteNotificationUseCaseProvider = Provider<DeleteNotificationUseCase>((ref) {
  return DeleteNotificationUseCase(ref.watch(notificationRepositoryProvider));
});

/// موفر نص البحث في الإشعارات
class NotificationsSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final notificationsSearchQueryProvider =
    NotifierProvider<NotificationsSearchQueryNotifier, String>(
  NotificationsSearchQueryNotifier.new,
);

/// موفر نوع الفلترة المحدد (all, general, promo, order, system)
class NotificationsFilterTypeNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setType(String type) => state = type;
}

final notificationsFilterTypeProvider =
    NotifierProvider<NotificationsFilterTypeNotifier, String>(
  NotificationsFilterTypeNotifier.new,
);

/// موفر التحكم الرئيسي بحالة الإشعارات عبر [AsyncNotifier] مع إدارة الإلغاء ومنع تسريب الموارد
class NotificationsNotifier extends AsyncNotifier<NotificationsResultEntity> {
  CancelToken? _cancelToken;

  @override
  Future<NotificationsResultEntity> build() async {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('Notifications notifier rebuild');
    }
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    ref.onDispose(() {
      if (!cancelToken.isCancelled) {
        cancelToken.cancel('Notifications page disposed');
      }
    });

    final useCase = ref.watch(getNotificationsUseCaseProvider);
    final result = await useCase(cancelToken: cancelToken);

    return result.fold(
      (failure) => throw failure,
      (data) => data,
    );
  }

  /// إعادة جلب وتحديث قائمة الإشعارات
  Future<void> refreshNotifications() async {
    state = const AsyncValue.loading();
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('Refresh requested');
    }
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    final useCase = ref.read(getNotificationsUseCaseProvider);
    final result = await useCase(cancelToken: cancelToken);

    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (data) => AsyncValue.data(data),
    );
  }

  /// إرسال إشعار جديد وتحديث الحالة محلياً وفورياً
  Future<Either<Failure, AdminNotificationEntity>> sendNotification(
    Map<String, dynamic> payload,
  ) async {
    final useCase = ref.read(sendNotificationUseCaseProvider);
    final result = await useCase(payload);

    result.fold(
      (failure) {},
      (newNotification) {
        final current = state.value ?? NotificationsResultEntity.initial();
        final updatedList = [newNotification, ...current.notifications];
        final isBroadcast = newNotification.targetType == 'all';

        final updated = current.copyWith(
          notifications: updatedList,
          totalCount: current.totalCount + 1,
          todayCount: current.todayCount + 1,
          broadcastCount: isBroadcast
              ? current.broadcastCount + 1
              : current.broadcastCount,
          targetedCount: isBroadcast
              ? current.targetedCount
              : current.targetedCount + 1,
        );

        state = AsyncValue.data(updated);
      },
    );

    return result;
  }

  /// حذف إشعار وتحديث الحالة
  Future<Either<Failure, void>> deleteNotification(String id) async {
    final useCase = ref.read(deleteNotificationUseCaseProvider);
    final result = await useCase(id);

    result.fold(
      (failure) {},
      (_) {
        final current = state.value ?? NotificationsResultEntity.initial();
        final updatedList =
            current.notifications.where((n) => n.id != id).toList();

        final updated = current.copyWith(
          notifications: updatedList,
          totalCount: (current.totalCount - 1).clamp(0, 999999),
        );

        state = AsyncValue.data(updated);
      },
    );

    return result;
  }
}

final notificationsControllerProvider =
    AsyncNotifierProvider<NotificationsNotifier, NotificationsResultEntity>(
  NotificationsNotifier.new,
);

/// موفر قائمة الإشعارات المفلترة تلقائياً بحسب نوع التبويب والبحث
final filteredNotificationsListProvider =
    Provider<List<AdminNotificationEntity>>((ref) {
  final asyncState = ref.watch(notificationsControllerProvider);
  final query = ref.watch(notificationsSearchQueryProvider).toLowerCase().trim();
  final filterType = ref.watch(notificationsFilterTypeProvider);

  return asyncState.maybeWhen(
    data: (data) {
      var list = data.notifications;

      if (filterType != 'all') {
        list = list.where((n) => n.type == filterType).toList();
      }

      if (query.isNotEmpty) {
        list = list.where((n) {
          final titleMatch = n.title.toLowerCase().contains(query);
          final bodyMatch = n.body.toLowerCase().contains(query);
          final userMatch = n.userName?.toLowerCase().contains(query) ?? false;
          return titleMatch || bodyMatch || userMatch;
        }).toList();
      }

      return list;
    },
    orElse: () => const [],
  );
});
