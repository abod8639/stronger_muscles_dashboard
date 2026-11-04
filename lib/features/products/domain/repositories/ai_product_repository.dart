import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/ai_product_suggestion_entity.dart';

/// Contract for AI product auto-fill and specifications generation.
abstract class AiProductRepository {
  Future<Either<Failure, AiProductSuggestionEntity>> generateProductDetails({
    required String productName,
    List<String>? availableCategories,
    List<String>? availableBrands,
  });
}

