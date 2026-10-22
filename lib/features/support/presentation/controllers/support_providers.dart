import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/controllers/auth_providers.dart';
import '../../data/datasources/support_remote_data_source.dart';
import '../../data/repositories/support_repository_impl.dart';
import '../../domain/repositories/support_repository.dart';
import '../../domain/usecases/support_usecases.dart';
import 'support_controller.dart';

final supportRemoteDataSourceProvider = Provider<SupportRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return SupportRemoteDataSourceImpl(dio: dio);
});

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepositoryImpl(
    remoteDataSource: ref.watch(supportRemoteDataSourceProvider),
  );
});

final getSupportTicketsUseCaseProvider =
    Provider<GetSupportTicketsUseCase>((ref) {
  return GetSupportTicketsUseCase(ref.watch(supportRepositoryProvider));
});

final getSupportTicketDetailUseCaseProvider =
    Provider<GetSupportTicketDetailUseCase>((ref) {
  return GetSupportTicketDetailUseCase(ref.watch(supportRepositoryProvider));
});

final sendSupportMessageUseCaseProvider =
    Provider<SendSupportMessageUseCase>((ref) {
  return SendSupportMessageUseCase(ref.watch(supportRepositoryProvider));
});

final updateTicketStatusUseCaseProvider =
    Provider<UpdateTicketStatusUseCase>((ref) {
  return UpdateTicketStatusUseCase(ref.watch(supportRepositoryProvider));
});

final updateTicketPriorityUseCaseProvider =
    Provider<UpdateTicketPriorityUseCase>((ref) {
  return UpdateTicketPriorityUseCase(ref.watch(supportRepositoryProvider));
});

final assignTicketAdminUseCaseProvider =
    Provider<AssignTicketAdminUseCase>((ref) {
  return AssignTicketAdminUseCase(ref.watch(supportRepositoryProvider));
});

final deleteSupportTicketUseCaseProvider =
    Provider<DeleteSupportTicketUseCase>((ref) {
  return DeleteSupportTicketUseCase(ref.watch(supportRepositoryProvider));
});

final getSupportStatsUseCaseProvider = Provider<GetSupportStatsUseCase>((ref) {
  return GetSupportStatsUseCase(ref.watch(supportRepositoryProvider));
});

final supportControllerProvider = Provider<SupportController>((ref) {
  final controller = SupportController(
    getTicketsUseCase: ref.watch(getSupportTicketsUseCaseProvider),
    getTicketDetailUseCase: ref.watch(getSupportTicketDetailUseCaseProvider),
    sendMessageUseCase: ref.watch(sendSupportMessageUseCaseProvider),
    updateStatusUseCase: ref.watch(updateTicketStatusUseCaseProvider),
    updatePriorityUseCase: ref.watch(updateTicketPriorityUseCaseProvider),
    assignAdminUseCase: ref.watch(assignTicketAdminUseCaseProvider),
    deleteTicketUseCase: ref.watch(deleteSupportTicketUseCaseProvider),
    getStatsUseCase: ref.watch(getSupportStatsUseCaseProvider),
  );
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
