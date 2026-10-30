import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/config/api_config.dart';
import '../models/support_chat_message_model.dart';
import '../models/support_chat_ticket_model.dart';

abstract class SupportChatRemoteDataSource {
  Future<SupportChatTicketModel> getTicketChatDetail(int ticketId);

  Future<SupportChatMessageModel> sendMessage({
    required int ticketId,
    required String message,
    bool isInternalNote = false,
    String? status,
    List<String>? attachments,
  });

  Future<SupportChatTicketModel> updateStatus(int ticketId, String status);

  Future<SupportChatTicketModel> updatePriority(int ticketId, String priority);

  Future<SupportChatTicketModel> assignAdmin(int ticketId, int? adminId);

  Future<void> deleteTicket(int ticketId);
}

class SupportChatRemoteDataSourceImpl implements SupportChatRemoteDataSource {
  final Dio dio;

  const SupportChatRemoteDataSourceImpl({required this.dio});

  @override
  Future<SupportChatTicketModel> getTicketChatDetail(int ticketId) async {
    final response = await dio.get(
      ApiConfig.adminSupportTicketDetail(ticketId),
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return SupportChatTicketModel.fromJson(
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
  Future<SupportChatMessageModel> sendMessage({
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
        if (status != null) 'status': status,
        if (attachments != null) 'attachments': attachments,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data['data'] ?? response.data;
      return SupportChatMessageModel.fromJson(
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
  Future<SupportChatTicketModel> updateStatus(
    int ticketId,
    String status,
  ) async {
    final response = await dio.patch(
      ApiConfig.adminSupportTicketStatus(ticketId),
      data: {'status': status},
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return SupportChatTicketModel.fromJson(
        Map<String, dynamic>.from(data as Map),
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'فشل في تحديث حالة التذكرة',
      );
    }
  }

  @override
  Future<SupportChatTicketModel> updatePriority(
    int ticketId,
    String priority,
  ) async {
    final response = await dio.patch(
      ApiConfig.adminSupportTicketPriority(ticketId),
      data: {'priority': priority},
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return SupportChatTicketModel.fromJson(
        Map<String, dynamic>.from(data as Map),
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'فشل في تعديل أولوية التذكرة',
      );
    }
  }

  @override
  Future<SupportChatTicketModel> assignAdmin(int ticketId, int? adminId) async {
    final response = await dio.post(
      ApiConfig.adminSupportTicketAssign(ticketId),
      data: {'admin_id': adminId},
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return SupportChatTicketModel.fromJson(
        Map<String, dynamic>.from(data as Map),
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'فشل في تعيين المشرف',
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
        error: 'فشل في حذف التذكرة',
      );
    }
  }
}
