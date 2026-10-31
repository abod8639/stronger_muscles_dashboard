import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:stronger_muscles_dashboard/core/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';
import '../../data/datasources/support_local_data_source.dart';
import '../../data/datasources/support_realtime_data_source.dart';
import '../../data/datasources/support_remote_data_source.dart';
import '../../data/repositories/support_repository_impl.dart';
import '../../domain/repositories/support_repository.dart';
import '../../domain/usecases/assign_ticket_admin_usecase.dart';
import '../../domain/usecases/delete_support_ticket_usecase.dart';
import '../../domain/usecases/get_support_stats_usecase.dart';
import '../../domain/usecases/get_support_ticket_detail_usecase.dart';
import '../../domain/usecases/get_support_tickets_usecase.dart';
import '../../domain/usecases/send_support_message_usecase.dart';
import '../../domain/usecases/update_ticket_priority_usecase.dart';
import '../../domain/usecases/update_ticket_status_usecase.dart';
import 'support_controller.dart';
import 'support_state.dart';

/// Provider for the Hive cache Box dedicated to the support feature.
final supportBoxProvider = Provider<Box>((ref) {
  return Hive.box('support_cache');
});

/// Provider for [SupportLocalDataSource].
final supportLocalDataSourceProvider = Provider<SupportLocalDataSource>((ref) {
  return SupportLocalDataSourceImpl(box: ref.watch(supportBoxProvider));
});

/// Provider for [SupportRemoteDataSource] backed by centralized [dioProvider].
final supportRemoteDataSourceProvider = Provider<SupportRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return SupportRemoteDataSourceImpl(dio: dio);
});

/// Provider for [SupportRealtimeDataSource] WebSocket client.
final supportRealtimeDataSourceProvider = Provider<SupportRealtimeDataSource>((
  ref,
) {
  final host = ApiConfigController().ip;
  final realtimeSource = SupportRealtimeDataSourceImpl(host: host);
  ref.onDispose(() {
    realtimeSource.disconnect();
  });
  return realtimeSource;
});

/// Provider for [SupportRepository] as the Single Source of Truth (SSOT).
final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepositoryImpl(
    remoteDataSource: ref.watch(supportRemoteDataSourceProvider),
    localDataSource: ref.watch(supportLocalDataSourceProvider),
    realtimeDataSource: ref.watch(supportRealtimeDataSourceProvider),
  );
});

/// Providers for Domain UseCases
final getSupportTicketsUseCaseProvider = Provider<GetSupportTicketsUseCase>((
  ref,
) {
  return GetSupportTicketsUseCase(ref.watch(supportRepositoryProvider));
});

final getSupportTicketDetailUseCaseProvider =
    Provider<GetSupportTicketDetailUseCase>((ref) {
      return GetSupportTicketDetailUseCase(
        ref.watch(supportRepositoryProvider),
      );
    });

final sendSupportMessageUseCaseProvider = Provider<SendSupportMessageUseCase>((
  ref,
) {
  return SendSupportMessageUseCase(ref.watch(supportRepositoryProvider));
});

final updateTicketStatusUseCaseProvider = Provider<UpdateTicketStatusUseCase>((
  ref,
) {
  return UpdateTicketStatusUseCase(ref.watch(supportRepositoryProvider));
});

final updateTicketPriorityUseCaseProvider =
    Provider<UpdateTicketPriorityUseCase>((ref) {
      return UpdateTicketPriorityUseCase(ref.watch(supportRepositoryProvider));
    });

final assignTicketAdminUseCaseProvider = Provider<AssignTicketAdminUseCase>((
  ref,
) {
  return AssignTicketAdminUseCase(ref.watch(supportRepositoryProvider));
});

final deleteSupportTicketUseCaseProvider = Provider<DeleteSupportTicketUseCase>(
  (ref) {
    return DeleteSupportTicketUseCase(ref.watch(supportRepositoryProvider));
  },
);

final getSupportStatsUseCaseProvider = Provider<GetSupportStatsUseCase>((ref) {
  return GetSupportStatsUseCase(ref.watch(supportRepositoryProvider));
});

/// Central NotifierProvider for Support UI State Management.
final supportControllerProvider =
    NotifierProvider<SupportNotifier, SupportState>(SupportNotifier.new);
