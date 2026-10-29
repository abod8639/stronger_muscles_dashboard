import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/core/config/api_config.dart';
import '../models/promo_model.dart';

/// Contract for remote operations regarding promotional banners via REST API.
abstract class PromoRemoteDataSource {
  Future<List<PromoModel>> getPromos();
  Future<PromoModel> addPromo(Map<String, dynamic> promoData);
  Future<PromoModel> updatePromo(String id, Map<String, dynamic> promoData);
  Future<void> deletePromo(String id);
  Future<String> uploadImage(String filePath);
}

/// Production implementation of [PromoRemoteDataSource] using [Dio].
/// 100% testable through constructor dependency injection.
class PromoRemoteDataSourceImpl implements PromoRemoteDataSource {
  final Dio dio;

  const PromoRemoteDataSourceImpl({required this.dio});

  static const _timeout = Duration(seconds: 30);

  @override
  Future<List<PromoModel>> getPromos() async {
    final response = await dio.get(
      ApiConfig.adminPromos,
      options: Options(sendTimeout: _timeout, receiveTimeout: _timeout),
    );
    return await compute(parsePromoListCompute, response.data);
  }

  @override
  Future<PromoModel> addPromo(Map<String, dynamic> promoData) async {
    final response = await dio.post(
      ApiConfig.adminPromos,
      data: promoData,
      options: Options(sendTimeout: _timeout, receiveTimeout: _timeout),
    );
    return await compute(parsePromoCompute, response.data);
  }

  @override
  Future<PromoModel> updatePromo(
    String id,
    Map<String, dynamic> promoData,
  ) async {
    final response = await dio.put(
      '${ApiConfig.adminPromos}/$id',
      data: promoData,
      options: Options(sendTimeout: _timeout, receiveTimeout: _timeout),
    );
    return await compute(parsePromoCompute, response.data);
  }

  @override
  Future<void> deletePromo(String id) async {
    await dio.delete(
      '${ApiConfig.adminPromos}/$id',
      options: Options(sendTimeout: _timeout, receiveTimeout: _timeout),
    );
  }

  @override
  Future<String> uploadImage(String filePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });

    final response = await dio.post(
      ApiConfig.adminUploadProductImage,
      data: formData,
      options: Options(
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    final data = response.data;
    if (data is Map) {
      final imageUrl =
          data['url'] ??
          data['data']?['url'] ??
          data['imageUrl'] ??
          data['path'];
      if (imageUrl != null) return imageUrl.toString();
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'فشل في رفع الصورة',
    );
  }
}
