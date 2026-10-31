import 'package:flutter/foundation.dart';

/// Clean Architecture Domain Entity representing a single message within a support ticket chat thread.
@immutable
class SupportChatMessageEntity {
  final int id;
  final int ticketId;
  final int senderId;
  final String senderName;
  final String senderType; // 'admin' | 'user' | 'system'
  final String? senderAvatar;
  final String message;
  final bool isInternalNote;
  final List<String> attachments;
  final DateTime createdAt;
  final bool isOptimistic;
  final bool isFailed;

  const SupportChatMessageEntity({
    required this.id,
    required this.ticketId,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    this.senderAvatar,
    required this.message,
    this.isInternalNote = false,
    this.attachments = const [],
    required this.createdAt,
    this.isOptimistic = false,
    this.isFailed = false,
  });

  bool get isAdmin => senderType == 'admin';
  bool get isUser => senderType == 'user';
  bool get isSystem => senderType == 'system';

  SupportChatMessageEntity copyWith({
    int? id,
    int? ticketId,
    int? senderId,
    String? senderName,
    String? senderType,
    String? senderAvatar,
    String? message,
    bool? isInternalNote,
    List<String>? attachments,
    DateTime? createdAt,
    bool? isOptimistic,
    bool? isFailed,
  }) {
    return SupportChatMessageEntity(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderType: senderType ?? this.senderType,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      message: message ?? this.message,
      isInternalNote: isInternalNote ?? this.isInternalNote,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      isOptimistic: isOptimistic ?? this.isOptimistic,
      isFailed: isFailed ?? this.isFailed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupportChatMessageEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ticketId == other.ticketId &&
          message == other.message &&
          isInternalNote == other.isInternalNote;

  @override
  int get hashCode =>
      id.hashCode ^
      ticketId.hashCode ^
      message.hashCode ^
      isInternalNote.hashCode;
}

