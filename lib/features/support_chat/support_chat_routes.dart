import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'domain/entities/support_chat_ticket_entity.dart';
import 'presentation/pages/support_chat_page.dart';

/// Modular GoRouter route declaration for the dedicated Support Chat conversation feature.
abstract class SupportChatRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.supportChat,
      name: 'support-chat',
      builder: (context, state) {
        int? ticketId;
        SupportChatTicketEntity? initialTicket;

        // 1. Try extra parameter
        if (state.extra is int) {
          ticketId = state.extra as int;
        } else if (state.extra is SupportChatTicketEntity) {
          initialTicket = state.extra as SupportChatTicketEntity;
          ticketId = initialTicket.id;
        }

        // 2. Try URI query parameters fallback (?id=123 or ?ticket_id=123)
        if (ticketId == null) {
          final qId =
              state.uri.queryParameters['id'] ??
              state.uri.queryParameters['ticket_id'];
          if (qId != null) {
            ticketId = int.tryParse(qId);
          }
        }

        return SupportChatPage(
          ticketId: ticketId,
          initialTicket: initialTicket,
          isEmbedded: false,
        );
      },
    ),
  ];
}

