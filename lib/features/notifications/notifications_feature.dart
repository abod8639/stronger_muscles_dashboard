/// Public Barrel File for the Notifications Feature.
///
/// Exposes strictly public contracts (Entities, UseCases, Providers, Routes, and Pages)
/// while encapsulating internal data sources, DTO models, and implementation details.
library;

// Domain Entities
export 'domain/entities/admin_notification_entity.dart';
export 'domain/entities/notifications_result_entity.dart';

// Domain Repositories (Interface)
export 'domain/repositories/notification_repository.dart';

// Domain UseCases
export 'domain/usecases/notification_usecases.dart';

// Presentation State, Notifiers & Providers
export 'presentation/controllers/notifications_providers.dart';

// Modular Routing
export 'notifications_routes.dart';

// Presentation Public Pages & Dialogs
export 'presentation/pages/notifications_screen.dart';
export 'presentation/widgets/send_notification_dialog.dart'
    show showSendNotificationDialog, SendNotificationDialog;
