import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';
import 'package:stronger_muscles_dashboard/features/support/presentation/controllers/support_providers.dart';
import '../../data/datasources/support_chat_remote_datasource.dart';
import '../../data/repositories/support_chat_repository_impl.dart';
import '../../domain/repositories/support_chat_repository.dart';
import '../../domain/usecases/assign_support_chat_admin_usecase.dart';
import '../../domain/usecases/delete_support_chat_ticket_usecase.dart';
import '../../domain/usecases/get_ticket_chat_detail_usecase.dart';
import '../../domain/usecases/send_support_chat_message_usecase.dart';
import '../../domain/usecases/update_support_chat_priority_usecase.dart';
import '../../domain/usecases/update_support_chat_status_usecase.dart';
import 'support_chat_controller.dart';
import 'support_chat_state.dart';

/// Provider for [SupportChatRemoteDataSource]
final supportChatRemoteDataSourceProvider =
    Provider<SupportChatRemoteDataSource>((ref) {
      final dio = ref.watch(dioProvider);
      return SupportChatRemoteDataSourceImpl(dio: dio);
    });

/// Provider for [SupportChatRepository]
final supportChatRepositoryProvider = Provider<SupportChatRepository>((ref) {
  return SupportChatRepositoryImpl(
    remoteDataSource: ref.watch(supportChatRemoteDataSourceProvider),
  );
});

/// UseCase Providers
final getTicketChatDetailUseCaseProvider =
    Provider<GetTicketChatDetailUseCase>((ref) {
      return GetTicketChatDetailUseCase(ref.watch(supportChatRepositoryProvider));
    });

final sendSupportChatMessageUseCaseProvider =
    Provider<SendSupportChatMessageUseCase>((ref) {
      return SendSupportChatMessageUseCase(
        ref.watch(supportChatRepositoryProvider),
      );
    });

final updateSupportChatStatusUseCaseProvider =
    Provider<UpdateSupportChatStatusUseCase>((ref) {
      return UpdateSupportChatStatusUseCase(
        ref.watch(supportChatRepositoryProvider),
      );
    });

final updateSupportChatPriorityUseCaseProvider =
    Provider<UpdateSupportChatPriorityUseCase>((ref) {
      return UpdateSupportChatPriorityUseCase(
        ref.watch(supportChatRepositoryProvider),
      );
    });

final assignSupportChatAdminUseCaseProvider =
    Provider<AssignSupportChatAdminUseCase>((ref) {
      return AssignSupportChatAdminUseCase(
        ref.watch(supportChatRepositoryProvider),
      );
    });

final deleteSupportChatTicketUseCaseProvider =
    Provider<DeleteSupportChatTicketUseCase>((ref) {
      return DeleteSupportChatTicketUseCase(
        ref.watch(supportChatRepositoryProvider),
      );
    });

/// StateNotifierProvider for [SupportChatNotifier]
final supportChatControllerProvider =
    StateNotifierProvider<SupportChatNotifier, SupportChatState>((ref) {
      return SupportChatNotifier(
        getTicketDetailUseCase: ref.watch(getTicketChatDetailUseCaseProvider),
        sendMessageUseCase: ref.watch(sendSupportChatMessageUseCaseProvider),
        updateStatusUseCase: ref.watch(updateSupportChatStatusUseCaseProvider),
        updatePriorityUseCase: ref.watch(updateSupportChatPriorityUseCaseProvider),
        assignAdminUseCase: ref.watch(assignSupportChatAdminUseCaseProvider),
        deleteTicketUseCase: ref.watch(deleteSupportChatTicketUseCaseProvider),
        realtimeDataSource: ref.watch(supportRealtimeDataSourceProvider),
      );
    });
