import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import '../models/support_message_model.dart';
import '../models/support_stats_model.dart';
import '../models/support_ticket_model.dart';

abstract class SupportRemoteDataSource {
  Future<Map<String, dynamic>> getTickets({
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

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  final Dio dio;

  SupportRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getTickets({
    String? status,
    String? priority,
    String? category,
    String? search,
    int? adminId,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
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
        final data = response.data;
        final List<dynamic> items = data['data'] ?? [];
        final tickets = items
            .whereType<Map>()
            .map((json) => SupportTicketModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();

        final statsJson = data['stats'] is Map ? Map<String, dynamic>.from(data['stats']) : <String, dynamic>{};
        final stats = SupportStatsModel.fromJson(statsJson);

        return {
          'tickets': tickets,
          'stats': stats,
        };
      } else {
        throw Exception('فشل في جلب تذاكر الدعم والشكاوى');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<SupportTicketModel> getTicketDetail(int ticketId) async {
    try {
      final response = await dio.get(ApiConfig.adminSupportTicketDetail(ticketId));
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return SupportTicketModel.fromJson(Map<String, dynamic>.from(data));
      } else {
        throw Exception('تعذر تحميل تفاصيل التذكرة');
      }
    } catch (e) {
      throw Exception(e.toString());
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
    try {
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
        return SupportMessageModel.fromJson(Map<String, dynamic>.from(data));
      } else {
        throw Exception('فشل في إرسال الرد');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<SupportTicketModel> updateStatus(int ticketId, String status) async {
    try {
      final response = await dio.patch(
        ApiConfig.adminSupportTicketStatus(ticketId),
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return SupportTicketModel.fromJson(Map<String, dynamic>.from(data));
      } else {
        throw Exception('تعذر تحديث حالة التذكرة');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<SupportTicketModel> updatePriority(int ticketId, String priority) async {
    try {
      final response = await dio.patch(
        ApiConfig.adminSupportTicketPriority(ticketId),
        data: {'priority': priority},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return SupportTicketModel.fromJson(Map<String, dynamic>.from(data));
      } else {
        throw Exception('تعذر تعديل الأولوية');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<SupportTicketModel> assignAdmin(int ticketId, int? adminId) async {
    try {
      final response = await dio.patch(
        ApiConfig.adminSupportTicketAssign(ticketId),
        data: {'admin_id': adminId},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return SupportTicketModel.fromJson(Map<String, dynamic>.from(data));
      } else {
        throw Exception('تعذر تعيين المشرف');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteTicket(int ticketId) async {
    try {
      final response = await dio.delete(ApiConfig.adminSupportTicketDetail(ticketId));
      if (response.statusCode != 200) {
        throw Exception('تعذر حذف التذكرة');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<SupportStatsModel> getStats() async {
    try {
      final response = await dio.get(ApiConfig.adminSupportStats);
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return SupportStatsModel.fromJson(Map<String, dynamic>.from(data));
      } else {
        throw Exception('تعذر تحميل إحصائيات الدعم');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
