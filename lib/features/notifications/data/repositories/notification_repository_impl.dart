import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/admin_notification_entity.dart';
import '../../domain/entities/notifications_result_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';
import '../datasources/notification_remote_datasource.dart';
import '../mappers/notification_mapper.dart';

/// Production implementation of [NotificationRepository] acting as Single Source of Truth.
/// Orchestrates calls between Hive local cache and Dio remote datasource.
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, NotificationsResultEntity>> getNotifications({
    String? search,
    String? type,
    int page = 1,
    bool forceRefresh = false,
  }) async {
    final isFilteredQuery =
        (search != null && search.isNotEmpty) || (type != null && type != 'all') || page > 1;

    // Check Hive cache first for default initial query if not forced
    if (!forceRefresh && !isFilteredQuery) {
      try {
        final isCacheValid = await localDataSource.isCacheValid();
        if (isCacheValid) {
          final cachedModel = await localDataSource.getCachedNotifications();
          if (cachedModel != null) {
            return Right(cachedModel.toEntity());
          }
        }
      } catch (e) {
        debugPrint('NotificationRepositoryImpl: cache read error: $e');
      }
    }

    try {
      final remoteModel = await remoteDataSource.getNotifications(
        search: search,
        type: type,
        page: page,
      );

      // Cache fresh data for default unpaginated query
      if (!isFilteredQuery) {
        try {
          await localDataSource.cacheNotifications(remoteModel);
        } catch (e) {
          debugPrint('NotificationRepositoryImpl: cache write error: $e');
        }
      }

      return Right(remoteModel.toEntity());
    } catch (e, stackTrace) {
      debugPrint('NotificationRepositoryImpl (getNotifications) Exception: $e');

      // Fallback to cached data when offline or network fails for base list
      if (!isFilteredQuery) {
        try {
          final cachedModel = await localDataSource.getCachedNotifications();
          if (cachedModel != null) {
            return Right(cachedModel.toEntity());
          }
        } catch (_) {}
      }

      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, AdminNotificationEntity>> sendNotification(
    Map<String, dynamic> data,
  ) async {
    try {
      final model = await remoteDataSource.sendNotification(data);
      // Invalidate local cache on creation
      try {
        await localDataSource.clearCache();
      } catch (_) {}
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint('NotificationRepositoryImpl (sendNotification) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(
    String id,
  ) async {
    try {
      await remoteDataSource.deleteNotification(id);
      // Invalidate local cache on deletion
      try {
        await localDataSource.clearCache();
      } catch (_) {}
      return const Right(null);
    } catch (e, stackTrace) {
      debugPrint('NotificationRepositoryImpl (deleteNotification) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }
}
