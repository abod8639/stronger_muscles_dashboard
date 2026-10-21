import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/notification_usecases.dart';
import 'notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    final dio = Get.isRegistered<ApiBase>() ? Get.find<ApiBase>().dio : Dio();

    if (!Get.isRegistered<NotificationRemoteDataSource>()) {
      Get.lazyPut<NotificationRemoteDataSource>(
        () => NotificationRemoteDataSourceImpl(dio: dio),
        fenix: true,
      );
    }

    if (!Get.isRegistered<NotificationRepository>()) {
      Get.lazyPut<NotificationRepository>(
        () => NotificationRepositoryImpl(remoteDataSource: Get.find()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<GetNotificationsUseCase>()) {
      Get.lazyPut(() => GetNotificationsUseCase(Get.find()), fenix: true);
    }

    if (!Get.isRegistered<SendNotificationUseCase>()) {
      Get.lazyPut(() => SendNotificationUseCase(Get.find()), fenix: true);
    }

    if (!Get.isRegistered<DeleteNotificationUseCase>()) {
      Get.lazyPut(() => DeleteNotificationUseCase(Get.find()), fenix: true);
    }

    if (!Get.isRegistered<NotificationsController>()) {
      Get.lazyPut(
        () => NotificationsController(
          getNotificationsUseCase: Get.find(),
          sendNotificationUseCase: Get.find(),
          deleteNotificationUseCase: Get.find(),
        ),
        fenix: true,
      );
    }
  }
}
