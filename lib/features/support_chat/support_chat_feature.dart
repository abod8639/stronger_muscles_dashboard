library;

/// Barrel export file for the Support Chat Clean Architecture feature.

// Domain Entities & Repositories
export 'domain/entities/support_chat_message_entity.dart';
export 'domain/entities/support_chat_ticket_entity.dart';
export 'domain/repositories/support_chat_repository.dart';

// Domain UseCases
export 'domain/usecases/get_ticket_chat_detail_usecase.dart';
export 'domain/usecases/send_support_chat_message_usecase.dart';
export 'domain/usecases/update_support_chat_status_usecase.dart';
export 'domain/usecases/update_support_chat_priority_usecase.dart';
export 'domain/usecases/assign_support_chat_admin_usecase.dart';
export 'domain/usecases/delete_support_chat_ticket_usecase.dart';

// Mappers & Bridges
export 'data/mappers/support_chat_entity_bridge.dart';

// Presentation Controllers & State
export 'presentation/controllers/support_chat_state.dart';
export 'presentation/controllers/support_chat_controller.dart';
export 'presentation/controllers/support_chat_providers.dart';

// Presentation Pages & Widgets
export 'presentation/pages/support_chat_page.dart';
export 'presentation/widgets/support_chat_bubble.dart';
export 'presentation/widgets/support_chat_header.dart';
export 'presentation/widgets/support_chat_composer.dart';

// Routes
export 'support_chat_routes.dart';

