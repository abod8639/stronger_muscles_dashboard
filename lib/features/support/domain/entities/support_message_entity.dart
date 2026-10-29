/// 100% Pure Dart Domain Entity representing a single message within a support ticket thread.
/// Adheres strictly to Clean Architecture: Zero dependencies on Flutter UI, Dio, Hive, or 3rd-party SDKs.
class SupportMessageEntity {
  final int id;
  final int ticketId;
  final String senderType; // 'user', 'admin', 'system'
  final int? senderId;
  final String senderName;
  final String message;
  final List<String> attachments;
  final bool isInternalNote;
  final bool isRead;
  final DateTime createdAt;

  const SupportMessageEntity({
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

  bool get isUser => senderType == 'user';
  bool get isAdmin => senderType == 'admin';
  bool get isSystem => senderType == 'system';

  SupportMessageEntity copyWith({
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
    return SupportMessageEntity(
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
    return other is SupportMessageEntity &&
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

  @override
  String toString() =>
      'SupportMessageEntity(id: $id, ticketId: $ticketId, sender: $senderName, type: $senderType)';
}
