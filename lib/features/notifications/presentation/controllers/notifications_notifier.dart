import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../../domain/entities/admin_notification_entity.dart';
import '../../domain/entities/notifications_result_entity.dart';
import '../../domain/usecases/notification_usecases.dart';
import 'notifications_providers.dart';

/// State Notifier orchestrating notifications state, pagination, creation, and deletion.
/// Adheres strictly to Clean Architecture:
/// - Constructor Dependency Injection for 100% unit testability
/// - Zero try-catch blocks (Functional error handling via fpdart Either)
class NotificationsNotifier extends AsyncNotifier<NotificationsResultEntity> {
  final GetNotificationsUseCase? _injectedGetUseCase;
  final SendNotificationUseCase? _injectedSendUseCase;
  final DeleteNotificationUseCase? _injectedDeleteUseCase;

  NotificationsNotifier({
    GetNotificationsUseCase? getNotificationsUseCase,
    SendNotificationUseCase? sendNotificationUseCase,
    DeleteNotificationUseCase? deleteNotificationUseCase,
  }) : _injectedGetUseCase = getNotificationsUseCase,
       _injectedSendUseCase = sendNotificationUseCase,
       _injectedDeleteUseCase = deleteNotificationUseCase;

  @override
  Future<NotificationsResultEntity> build() async {
    final GetNotificationsUseCase useCase =
        _injectedGetUseCase ?? ref.watch(getNotificationsUseCaseProvider);
    final result = await useCase();

    return result.fold((failure) => throw failure, (data) => data);
  }

  /// Refreshes the notifications list by bypassing local cache.
  Future<void> refreshNotifications() async {
    state = const AsyncValue.loading();
    final GetNotificationsUseCase useCase =
        _injectedGetUseCase ?? ref.read(getNotificationsUseCaseProvider);
    final result = await useCase(forceRefresh: true);

    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (data) => AsyncValue.data(data),
    );
  }

  /// Sends a new administrative notification and optimistically updates local state.
  Future<Either<Failure, AdminNotificationEntity>> sendNotification(
    Map<String, dynamic> payload,
  ) async {
    final SendNotificationUseCase useCase =
        _injectedSendUseCase ?? ref.read(sendNotificationUseCaseProvider);
    final result = await useCase(payload);

    result.fold((failure) {}, (newNotification) {
      final current = state.value ?? const NotificationsResultEntity.initial();
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
    });

    return result;
  }

  /// Deletes a notification and removes it from the current state.
  Future<Either<Failure, void>> deleteNotification(String id) async {
    final DeleteNotificationUseCase useCase =
        _injectedDeleteUseCase ?? ref.read(deleteNotificationUseCaseProvider);
    final result = await useCase(id);

    result.fold((failure) {}, (_) {
      final current = state.value ?? const NotificationsResultEntity.initial();
      final updatedList = current.notifications
          .where((n) => n.id != id)
          .toList();

      final updated = current.copyWith(
        notifications: updatedList,
        totalCount: (current.totalCount - 1).clamp(0, 999999),
      );

      state = AsyncValue.data(updated);
    });

    return result;
  }
}
