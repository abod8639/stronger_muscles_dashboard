import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';
import '../../data/datasources/support_remote_data_source.dart';
import '../../data/repositories/support_repository_impl.dart';
import '../../domain/repositories/support_repository.dart';
import '../../domain/usecases/support_usecases.dart';
import 'support_controller.dart';

class SupportBinding extends Bindings {
  @override
  void dependencies() {
    final apiBase = Get.find<ApiBase>();

    Get.lazyPut<SupportRemoteDataSource>(
      () => SupportRemoteDataSourceImpl(dio: apiBase.dio),
      fenix: true,
    );

    Get.lazyPut<SupportRepository>(
      () => SupportRepositoryImpl(remoteDataSource: Get.find<SupportRemoteDataSource>()),
      fenix: true,
    );

    Get.lazyPut(() => GetSupportTicketsUseCase(Get.find<SupportRepository>()), fenix: true);
    Get.lazyPut(() => GetSupportTicketDetailUseCase(Get.find<SupportRepository>()), fenix: true);
    Get.lazyPut(() => SendSupportMessageUseCase(Get.find<SupportRepository>()), fenix: true);
    Get.lazyPut(() => UpdateTicketStatusUseCase(Get.find<SupportRepository>()), fenix: true);
    Get.lazyPut(() => UpdateTicketPriorityUseCase(Get.find<SupportRepository>()), fenix: true);
    Get.lazyPut(() => AssignTicketAdminUseCase(Get.find<SupportRepository>()), fenix: true);
    Get.lazyPut(() => DeleteSupportTicketUseCase(Get.find<SupportRepository>()), fenix: true);
    Get.lazyPut(() => GetSupportStatsUseCase(Get.find<SupportRepository>()), fenix: true);

    Get.lazyPut(
      () => SupportController(
        getTicketsUseCase: Get.find<GetSupportTicketsUseCase>(),
        getTicketDetailUseCase: Get.find<GetSupportTicketDetailUseCase>(),
        sendMessageUseCase: Get.find<SendSupportMessageUseCase>(),
        updateStatusUseCase: Get.find<UpdateTicketStatusUseCase>(),
        updatePriorityUseCase: Get.find<UpdateTicketPriorityUseCase>(),
        assignAdminUseCase: Get.find<AssignTicketAdminUseCase>(),
        deleteTicketUseCase: Get.find<DeleteSupportTicketUseCase>(),
        getStatsUseCase: Get.find<GetSupportStatsUseCase>(),
      ),
      fenix: true,
    );
  }
}
