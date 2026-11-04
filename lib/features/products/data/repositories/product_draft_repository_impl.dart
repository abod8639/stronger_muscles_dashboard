import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../../domain/entities/product_draft_entity.dart';
import '../../domain/repositories/product_draft_repository.dart';
import '../datasources/product_draft_local_datasource.dart';
import '../models/product_draft_model.dart';

class ProductDraftRepositoryImpl implements ProductDraftRepository {
  final ProductDraftLocalDataSource _localDataSource;

  const ProductDraftRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<ProductDraftEntity>>> getDrafts() async {
    try {
      final models = await _localDataSource.getDrafts();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل في استرجاع المسودات المحلية: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, ProductDraftEntity>> saveDraft(
    ProductDraftEntity draft,
  ) async {
    try {
      final model = ProductDraftModel.fromEntity(draft);
      final saved = await _localDataSource.saveDraft(model);
      return Right(saved.toEntity());
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل في حفظ المسودة محلياً: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDraft(String draftId) async {
    try {
      await _localDataSource.deleteDraft(draftId);
      return const Right(unit);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل في حذف المسودة: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAllDrafts() async {
    try {
      await _localDataSource.clearAllDrafts();
      return const Right(unit);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل في تفريغ المسودات: $e'),
      );
    }
  }
}
