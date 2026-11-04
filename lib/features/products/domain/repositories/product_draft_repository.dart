import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/product_draft_entity.dart';

/// Contract for managing product drafts locally in the domain layer.
abstract class ProductDraftRepository {
  Future<Either<Failure, List<ProductDraftEntity>>> getDrafts();
  Future<Either<Failure, ProductDraftEntity>> saveDraft(ProductDraftEntity draft);
  Future<Either<Failure, Unit>> deleteDraft(String draftId);
  Future<Either<Failure, Unit>> clearAllDrafts();
}
