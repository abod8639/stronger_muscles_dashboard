import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/product_draft_entity.dart';
import '../repositories/product_draft_repository.dart';

class GetProductDraftsUseCase {
  final ProductDraftRepository _repository;

  const GetProductDraftsUseCase(this._repository);

  Future<Either<Failure, List<ProductDraftEntity>>> call() {
    return _repository.getDrafts();
  }
}

