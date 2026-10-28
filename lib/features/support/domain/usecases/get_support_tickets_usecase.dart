import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/support_tickets_page_entity.dart';
import '../repositories/support_repository.dart';

/// Pure Dart UseCase to fetch paginated support tickets with filters.
class GetSupportTicketsUseCase {
  final SupportRepository _repository;

  const GetSupportTicketsUseCase(this._repository);

  Future<Either<Failure, SupportTicketsPageEntity>> call({
    String? status,
    String? priority,
    String? category,
    String? search,
    int? adminId,
    int page = 1,
    int perPage = 15,
  }) {
    return _repository.getTickets(
      status: status,
      priority: priority,
      category: category,
      search: search,
      adminId: adminId,
      page: page,
      perPage: perPage,
    );
  }
}
