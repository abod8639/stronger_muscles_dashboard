import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/product_draft_entity.dart';
import '../repositories/product_draft_repository.dart';

class SaveProductDraftUseCase {
  final ProductDraftRepository _repository;

  const SaveProductDraftUseCase(this._repository);

  Future<Either<Failure, ProductDraftEntity>> call(ProductDraftEntity draft) {
    return _repository.saveDraft(draft);
  }
}

