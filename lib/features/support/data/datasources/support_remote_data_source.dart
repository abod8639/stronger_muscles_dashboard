import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/config/api_config.dart';
import '../models/support_message_model.dart';
import '../models/support_stats_model.dart';
import '../models/support_ticket_model.dart';
import '../models/support_tickets_page_model.dart';

abstract class SupportRemoteDataSource {
  Future<SupportTicketsPageModel> getTickets({
    String? status,
    String? priority,
    String? category,
    String? search,
    int? adminId,
    int page = 1,
    int perPage = 15,
  });

  Future<SupportTicketModel> getTicketDetail(int ticketId);

  Future<SupportMessageModel> sendMessage({
    required int ticketId,
    required String message,
    bool isInternalNote = false,
    String? status,
    List<String>? attachments,
  });

  Future<SupportTicketModel> updateStatus(int ticketId, String status);

  Future<SupportTicketModel> updatePriority(int ticketId, String priority);

  Future<SupportTicketModel> assignAdmin(int ticketId, int? adminId);

  Future<void> deleteTicket(int ticketId);

  Future<SupportStatsModel> getStats();
}

/// Dio-backed implementation of [SupportRemoteDataSource].
/// Strict Constructor Dependency Injection of [Dio] for testability.
class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  final Dio dio;

  const SupportRemoteDataSourceImpl({required this.dio});

  @override
  Future<SupportTicketsPageModel> getTickets({
    String? status,
    String? priority,
    String? category,
    String? search,
    int? adminId,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await dio.get(
      ApiConfig.adminSupportTickets,
      queryParameters: {
        if (status != null && status != 'all') 'status': status,
        if (priority != null && priority != 'all') 'priority': priority,
        if (category != null && category != 'all') 'category': category,
        if (search != null && search.isNotEmpty) 'search': search,
        'admin_id': ?adminId,
        'page': page,
        'per_page': perPage,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      return SupportTicketsPageModel.fromJson(data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'فشل في جلب تذاكر الدعم والشكاوى',
      );
    }
  }

  @override
  Future<SupportTicketModel> getTicketDetail(int ticketId) async {
    final response = await dio.get(
      ApiConfig.adminSupportTicketDetail(ticketId),
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return SupportTicketModel.fromJson(
        Map<String, dynamic>.from(data as Map),
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'تعذر تحميل تفاصيل التذكرة',
      );
    }
  }

  @override
  Future<SupportMessageModel> sendMessage({
    required int ticketId,
    required String message,
    bool isInternalNote = false,
    String? status,
    List<String>? attachments,
  }) async {
    final response = await dio.post(
      ApiConfig.adminSupportTicketMessages(ticketId),
      data: {
        'message': message,
        'is_internal_note': isInternalNote,
        'status': ?status,
        'attachments': ?attachments,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data['data'] ?? response.data;
      return SupportMessageModel.fromJson(
        Map<String, dynamic>.from(data as Map),
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'فشل في إرسال الرد',
      );
    }
  }

  @override
  Future<SupportTicketModel> updateStatus(int ticketId, String status) async {
    final response = await dio.patch(
      ApiConfig.adminSupportTicketStatus(ticketId),
      data: {'status': status},
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return SupportTicketModel.fromJson(
        Map<String, dynamic>.from(data as Map),
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'تعذر تحديث حالة التذكرة',
      );
    }
  }

  @override
  Future<SupportTicketModel> updatePriority(
    int ticketId,
    String priority,
  ) async {
    final response = await dio.patch(
      ApiConfig.adminSupportTicketPriority(ticketId),
      data: {'priority': priority},
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return SupportTicketModel.fromJson(
        Map<String, dynamic>.from(data as Map),
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'تعذر تعديل الأولوية',
      );
    }
  }

  @override
  Future<SupportTicketModel> assignAdmin(int ticketId, int? adminId) async {
    final response = await dio.patch(
      ApiConfig.adminSupportTicketAssign(ticketId),
      data: {'admin_id': adminId},
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return SupportTicketModel.fromJson(
        Map<String, dynamic>.from(data as Map),
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'تعذر تعيين المشرف',
      );
    }
  }

  @override
  Future<void> deleteTicket(int ticketId) async {
    final response = await dio.delete(
      ApiConfig.adminSupportTicketDetail(ticketId),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'تعذر حذف التذكرة',
      );
    }
  }

  @override
  Future<SupportStatsModel> getStats() async {
    final response = await dio.get(ApiConfig.adminSupportStats);

    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return SupportStatsModel.fromJson(Map<String, dynamic>.from(data as Map));
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'تعذر تحميل إحصائيات الدعم',
      );
    }
  }
}
