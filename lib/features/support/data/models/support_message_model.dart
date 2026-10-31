import 'dart:convert';

/// Isolated Data Transfer Object (DTO) for support messages.
/// Strictly decoupled from Domain Entities with serialization / deserialization support.
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

  const SupportMessageModel({
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

  factory SupportMessageModel.fromJson(dynamic rawJson) {
    Map<String, dynamic> json;
    if (rawJson is Map) {
      json = Map<String, dynamic>.from(
        rawJson.map((k, v) => MapEntry(k.toString(), v)),
      );
    } else if (rawJson is String) {
      try {
        final decoded = jsonDecode(rawJson);
        if (decoded is Map) {
          json = Map<String, dynamic>.from(
            decoded.map((k, v) => MapEntry(k.toString(), v)),
          );
        } else {
          json = <String, dynamic>{};
        }
      } catch (_) {
        json = <String, dynamic>{};
      }
    } else {
      json = <String, dynamic>{};
    }

    List<String> parsedAttachments = [];
    final rawAttachments = json['attachments'];
    if (rawAttachments is List) {
      parsedAttachments = rawAttachments
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    } else if (rawAttachments is String && rawAttachments.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawAttachments);
        if (decoded is List) {
          parsedAttachments = decoded
              .map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList();
        }
      } catch (_) {}
    }

    return SupportMessageModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      ticketId: json['ticket_id'] is int
          ? json['ticket_id'] as int
          : int.tryParse(json['ticket_id']?.toString() ?? json['ticketId']?.toString() ?? '0') ?? 0,
      senderType: (json['sender_type'] ?? json['senderType'] ?? 'user').toString(),
      senderId: json['sender_id'] is int
          ? json['sender_id'] as int
          : int.tryParse(json['sender_id']?.toString() ?? json['senderId']?.toString() ?? ''),
      senderName: (json['sender_name'] ?? json['senderName'] ?? 'مستخدم').toString(),
      message: (json['message'] ?? '').toString(),
      attachments: parsedAttachments,
      isInternalNote:
          json['is_internal_note'] == true ||
          json['is_internal_note'] == 1 ||
          json['is_internal_note']?.toString() == 'true',
      isRead:
          json['is_read'] == true ||
          json['is_read'] == 1 ||
          json['is_read']?.toString() == 'true',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : (json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'sender_type': senderType,
      'sender_id': senderId,
      'sender_name': senderName,
      'message': message,
      'attachments': attachments,
      'is_internal_note': isInternalNote,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  SupportMessageModel copyWith({
    int? id,
    int? ticketId,
    String? senderType,
    int? senderId,
    String? senderName,
    String? message,
    List<String>? attachments,
    bool? isInternalNote,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return SupportMessageModel(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      senderType: senderType ?? this.senderType,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      attachments: attachments ?? this.attachments,
      isInternalNote: isInternalNote ?? this.isInternalNote,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupportMessageModel &&
        other.id == id &&
        other.ticketId == ticketId &&
        other.senderType == senderType &&
        other.senderId == senderId &&
        other.senderName == senderName &&
        other.message == message &&
        other.isInternalNote == isInternalNote &&
        other.isRead == isRead &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    ticketId,
    senderType,
    senderId,
    senderName,
    message,
    isInternalNote,
    isRead,
    createdAt,
  );
}
