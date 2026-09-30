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

    Get.lazyPut<NotificationRemoteDataSource>(() => NotificationRemoteDataSourceImpl(dio: dio));
    Get.lazyPut<NotificationRepository>(() => NotificationRepositoryImpl(remoteDataSource: Get.find()));

    Get.lazyPut(() => GetNotificationsUseCase(Get.find()));
    Get.lazyPut(() => SendNotificationUseCase(Get.find()));
    Get.lazyPut(() => DeleteNotificationUseCase(Get.find()));

    Get.lazyPut(() => NotificationsController(
          getNotificationsUseCase: Get.find(),
          sendNotificationUseCase: Get.find(),
          deleteNotificationUseCase: Get.find(),
        ));
  }
}
