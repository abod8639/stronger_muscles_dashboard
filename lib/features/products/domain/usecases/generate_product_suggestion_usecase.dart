import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/ai_product_suggestion_entity.dart';
import '../repositories/ai_product_repository.dart';

/// UseCase to generate detailed product specifications via AI
class GenerateProductSuggestionUseCase {
  final AiProductRepository _repository;

  const GenerateProductSuggestionUseCase(this._repository);

  Future<Either<Failure, AiProductSuggestionEntity>> call({
    required String productName,
    String? manufacturerUrl,
    List<String>? availableCategories,
    List<String>? availableBrands,
    List<String>? availableFlavors,
  }) {
    return _repository.generateProductDetails(
      productName: productName,
      manufacturerUrl: manufacturerUrl,
      availableCategories: availableCategories,
      availableBrands: availableBrands,
      availableFlavors: availableFlavors,
    );
  }
}

