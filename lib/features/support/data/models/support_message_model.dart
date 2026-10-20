import '../../domain/entities/support_message_entity.dart';

class SupportMessageModel {
  final int id;
  final int ticketId;
  final String senderType;
  final int? senderId;
  final String senderName;
  final String message;
  final List<String> attachments;
  final bool isInternalNote;
  final bool isRead;
  final DateTime createdAt;

  SupportMessageModel({
    required this.id,
    required this.ticketId,
    required this.senderType,
    this.senderId,
    required this.senderName,
    required this.message,
    this.attachments = const [],
    this.isInternalNote = false,
    this.isRead = false,
    required this.createdAt,
  });

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedAttachments = [];
    if (json['attachments'] is List) {
      parsedAttachments = (json['attachments'] as List).map((e) => e.toString()).toList();
    }

    return SupportMessageModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      ticketId: json['ticket_id'] is int
          ? json['ticket_id'] as int
          : int.tryParse(json['ticket_id']?.toString() ?? '0') ?? 0,
      senderType: json['sender_type']?.toString() ?? 'user',
      senderId: json['sender_id'] is int
          ? json['sender_id'] as int
          : int.tryParse(json['sender_id']?.toString() ?? ''),
      senderName: json['sender_name']?.toString() ?? 'مستخدم',
      message: json['message']?.toString() ?? '',
      attachments: parsedAttachments,
      isInternalNote: json['is_internal_note'] == true || json['is_internal_note'] == 1,
      isRead: json['is_read'] == true || json['is_read'] == 1,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  SupportMessageEntity toEntity() {
    return SupportMessageEntity(
      id: id,
      ticketId: ticketId,
      senderType: senderType,
      senderId: senderId,
      senderName: senderName,
      message: message,
      attachments: attachments,
      isInternalNote: isInternalNote,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}
