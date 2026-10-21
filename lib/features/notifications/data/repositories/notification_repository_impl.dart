import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/admin_notification_entity.dart';
import '../../domain/entities/notifications_result_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, NotificationsResultEntity>> getNotifications({
    String? search,
    String? type,
    int page = 1,
    CancelToken? cancelToken,
  }) async {
    try {
      final model = await remoteDataSource.getNotifications(
        search: search,
        type: type,
        page: page,
        cancelToken: cancelToken,
      );
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint('NotificationRepositoryImpl (getNotifications) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, AdminNotificationEntity>> sendNotification(
    Map<String, dynamic> data, {
    CancelToken? cancelToken,
  }) async {
    try {
      final model = await remoteDataSource.sendNotification(
        data,
        cancelToken: cancelToken,
      );
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint('NotificationRepositoryImpl (sendNotification) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      await remoteDataSource.deleteNotification(
        id,
        cancelToken: cancelToken,
      );
      return const Right(null);
    } catch (e, stackTrace) {
      debugPrint('NotificationRepositoryImpl (deleteNotification) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }
}
