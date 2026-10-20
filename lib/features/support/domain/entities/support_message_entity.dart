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
}
