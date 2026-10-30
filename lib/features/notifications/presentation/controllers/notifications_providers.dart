import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';
import '../../data/datasources/notification_local_datasource.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/admin_notification_entity.dart';
import '../../domain/entities/notifications_result_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/notification_usecases.dart';
import 'notifications_notifier.dart';

export 'notifications_notifier.dart';

// ==================== Data Layer Scoped Providers ====================

/// Scoped provider for Notifications Hive Cache Box
final notificationHiveBoxProvider = Provider<Box>((ref) {
  return Hive.box('notifications_cache');
});

/// Scoped provider for [NotificationLocalDataSource]
final notificationLocalDataSourceProvider =
    Provider<NotificationLocalDataSource>((ref) {
      final box = ref.watch(notificationHiveBoxProvider);
      return NotificationLocalDataSourceImpl(box: box);
    });

/// Scoped provider for [NotificationRemoteDataSource]
final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
      final dio = ref.watch(dioProvider);
      return NotificationRemoteDataSourceImpl(dio: dio);
    });

// ==================== Domain Layer Scoped Providers ====================

/// Scoped provider for [NotificationRepository] acting as Single Source of Truth
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    remoteDataSource: ref.watch(notificationRemoteDataSourceProvider),
    localDataSource: ref.watch(notificationLocalDataSourceProvider),
  );
});

/// Scoped provider for [GetNotificationsUseCase]
final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((
  ref,
) {
  return GetNotificationsUseCase(ref.watch(notificationRepositoryProvider));
});

/// Scoped provider for [SendNotificationUseCase]
final sendNotificationUseCaseProvider = Provider<SendNotificationUseCase>((
  ref,
) {
  return SendNotificationUseCase(ref.watch(notificationRepositoryProvider));
});

/// Scoped provider for [DeleteNotificationUseCase]
final deleteNotificationUseCaseProvider = Provider<DeleteNotificationUseCase>((
  ref,
) {
  return DeleteNotificationUseCase(ref.watch(notificationRepositoryProvider));
});

// ==================== Presentation Layer Scoped Providers ====================

/// Notifier managing notification text search query
class NotificationsSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final notificationsSearchQueryProvider =
    NotifierProvider<NotificationsSearchQueryNotifier, String>(
      NotificationsSearchQueryNotifier.new,
    );

/// Notifier managing active filter category ('all', 'general', 'promo', 'order', 'system')
class NotificationsFilterTypeNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setType(String type) => state = type;
}

final notificationsFilterTypeProvider =
    NotifierProvider<NotificationsFilterTypeNotifier, String>(
      NotificationsFilterTypeNotifier.new,
    );

/// Main state controller provider managing notifications lifecycle
final notificationsControllerProvider =
    AsyncNotifierProvider<NotificationsNotifier, NotificationsResultEntity>(
      NotificationsNotifier.new,
    );

/// Type definition for notification statistics counts
typedef NotificationStatsRecord = ({
  int total,
  int today,
  int broadcast,
  int targeted,
});

/// Selective provider for notifications statistics, avoiding rebuilds when searching
final notificationsStatsProvider = Provider<NotificationStatsRecord>((ref) {
  return ref.watch(
    notificationsControllerProvider.select((asyncVal) {
      final val = asyncVal.value;
      return (
        total: val?.totalCount ?? 0,
        today: val?.todayCount ?? 0,
        broadcast: val?.broadcastCount ?? 0,
        targeted: val?.targetedCount ?? 0,
      );
    }),
  );
});

/// Provider filtering notification list in-memory based on query and selected category
final filteredNotificationsListProvider =
    Provider<List<AdminNotificationEntity>>((ref) {
      final asyncState = ref.watch(notificationsControllerProvider);
      final query = ref
          .watch(notificationsSearchQueryProvider)
          .toLowerCase()
          .trim();
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
              final userMatch =
                  n.userName?.toLowerCase().contains(query) ?? false;
              return titleMatch || bodyMatch || userMatch;
            }).toList();
          }

          return groupTicketNotifications(list);
        },
        orElse: () => const [],
      );
    });

/// Groups multiple notifications for the same support ticket into a single consolidated item.
List<AdminNotificationEntity> groupTicketNotifications(
  List<AdminNotificationEntity> list,
) {
  final Map<int, List<AdminNotificationEntity>> ticketGroups = {};
  final List<AdminNotificationEntity> otherNotifications = [];

  for (final n in list) {
    if (n.isTicket && n.ticketId != null) {
      ticketGroups.putIfAbsent(n.ticketId!, () => []).add(n);
    } else {
      otherNotifications.add(n);
    }
  }

  final List<AdminNotificationEntity> result = List.from(otherNotifications);

  for (final entry in ticketGroups.entries) {
    final group = entry.value;
    group.sort((a, b) {
      final da = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final db = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da);
    });

    final latest = group.first;
    final totalMessages = group.length;

    final avatar = group
        .map((e) => e.userAvatar)
        .firstWhere((a) => a != null && a.isNotEmpty, orElse: () => null);

    final userName = group
        .map((e) => e.userName)
        .firstWhere((u) => u != null && u.isNotEmpty, orElse: () => null);

    final userEmail = group
        .map((e) => e.userEmail)
        .firstWhere((e) => e != null && e.isNotEmpty, orElse: () => null);

    final consolidated = latest.copyWith(
      userAvatar: avatar ?? latest.userAvatar,
      userName: userName ?? latest.userName,
      userEmail: userEmail ?? latest.userEmail,
      messagesCount: totalMessages,
      groupedNotificationIds: group.map((g) => g.id).toList(),
    );

    result.add(consolidated);
  }

  result.sort((a, b) {
    final da = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final db = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return db.compareTo(da);
  });

  return result;
}
