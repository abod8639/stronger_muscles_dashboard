import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../../domain/entities/ai_product_suggestion_entity.dart';
import '../../domain/repositories/ai_product_repository.dart';
import '../datasources/gemini_product_remote_datasource.dart';

class AiProductRepositoryImpl implements AiProductRepository {
  final GeminiProductRemoteDataSource _remoteDataSource;

  const AiProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AiProductSuggestionEntity>> generateProductDetails({
    required String productName,
    List<String>? availableCategories,
    List<String>? availableBrands,
  }) async {
    try {
      final model = await _remoteDataSource.generateProductDetails(
        productName: productName,
        availableCategories: availableCategories,
        availableBrands: availableBrands,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.response != null) {
        final code = e.response?.statusCode;
        final data = e.response?.data;
        String msg = 'خطأ أثناء الاتصال بـ Gemini ($code)';
        if (data is Map && data['error'] is Map) {
          msg = data['error']['message'] ?? msg;
        }
        return Left(ServerFailure(message: msg, statusCode: code));
      }
      return Left(
        NetworkFailure(
          message: 'تعذر الاتصال بخدمة الذكاء الاصطناعي: ${e.message}',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }
}
