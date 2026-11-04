import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/product_draft_repository.dart';

class DeleteProductDraftUseCase {
  final ProductDraftRepository _repository;

  const DeleteProductDraftUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String draftId) {
    return _repository.deleteDraft(draftId);
  }
}

