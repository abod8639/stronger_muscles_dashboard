import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/support_chat_feature.dart';
import '../controllers/support_providers.dart';

/// Presentation widget rendering the active support ticket conversation thread,
/// message history, internal notes, canned responses, and reply composer.
/// Bridges [SupportScreen] with the dedicated Clean Architecture [SupportChatPage].
class SupportChatView extends ConsumerWidget {
  const SupportChatView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticket = ref.watch(
      supportControllerProvider.select((s) => s.selectedTicket),
    );

    return SupportChatPage(
      key: ValueKey('embedded_support_chat_${ticket?.id}'),
      ticketId: ticket?.id,
      isEmbedded: true,
      onBack: () =>
          ref.read(supportControllerProvider.notifier).setSelectedTicket(null),
    );
  }
}
