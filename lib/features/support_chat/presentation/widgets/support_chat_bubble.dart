import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import '../../domain/entities/support_chat_message_entity.dart';

class SupportChatBubble extends StatelessWidget {
  final SupportChatMessageEntity message;
  final bool isDark;

  const SupportChatBubble({
    super.key,
    required this.message,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeStr = DateFormat('MM/dd • h:mm a').format(message.createdAt);

    if (message.isInternalNote) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: isDark ? 0.12 : 0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.amber.shade700.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lock_rounded,
                  size: 14,
                  color: Colors.amber.shade800,
                ),
                const SizedBox(width: 6),
                Text(
                  'ملاحظة داخلية للمشرفين',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                const Spacer(),
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SelectableText(
              message.message,
              style: TextStyle(fontSize: 13, color: colorScheme.onSurface),
            ),
          ],
        ),
      );
    }

    final isUser = message.isUser;
    final isMobile = context.isMobile;

    return Align(
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * (isMobile ? 0.84 : 0.52),
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser
              ? colorScheme.surfaceContainerHigh
              : colorScheme.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 2 : 18),
            bottomRight: Radius.circular(isUser ? 18 : 2),
          ),
          border: isUser ? Border.all(color: colorScheme.outlineVariant) : null,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              offset: const Offset(2, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isUser) ...[
                  Icon(
                    Icons.support_agent_rounded,
                    size: 14,
                    color: colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    message.senderName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ] else ...[
                  Icon(
                    Icons.person_rounded,
                    size: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    message.senderName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            SelectableText(
              message.message,
              style: TextStyle(
                fontSize: 13.5,
                color: isUser ? colorScheme.onSurface : colorScheme.onPrimary,
                height: 1.35,
              ),
            ),
            if (message.attachments.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: message.attachments.map((url) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        width: 120,
                        height: 120,
                        color: Colors.black12,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, _, _) => Container(
                        width: 120,
                        height: 120,
                        color: Colors.black12,
                        child: const Icon(Icons.broken_image_rounded),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.isOptimistic) ...[
                  SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: isUser
                          ? colorScheme.primary
                          : colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 10,
                    color: isUser
                        ? colorScheme.onSurface.withValues(alpha: 0.6)
                        : colorScheme.onPrimary.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

