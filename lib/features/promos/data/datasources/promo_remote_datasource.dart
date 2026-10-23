import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/models/promo_model.dart';

abstract class PromoRemoteDataSource {
  Future<List<PromoModel>> getPromos({CancelToken? cancelToken});
  Future<PromoModel> addPromo(Map<String, dynamic> promoData, {CancelToken? cancelToken});
  Future<PromoModel> updatePromo(String id, Map<String, dynamic> promoData, {CancelToken? cancelToken});
  Future<void> deletePromo(String id, {CancelToken? cancelToken});
  Future<String> uploadImage(String filePath, {CancelToken? cancelToken});
}

class PromoRemoteDataSourceImpl implements PromoRemoteDataSource {
  final Dio dio;

  PromoRemoteDataSourceImpl({required this.dio});

  static const _timeout = Duration(seconds: 30);

  @override
  Future<List<PromoModel>> getPromos({CancelToken? cancelToken}) async {
    final response = await dio.get(
      ApiConfig.adminPromos,
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: _timeout,
        receiveTimeout: _timeout,
      ),
    );
    return await compute(parsePromoListCompute, response.data);
  }

  @override
  Future<PromoModel> addPromo(Map<String, dynamic> promoData, {CancelToken? cancelToken}) async {
    final response = await dio.post(
      ApiConfig.adminPromos,
      data: promoData,
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: _timeout,
        receiveTimeout: _timeout,
      ),
    );
    return await compute(parsePromoCompute, response.data);
  }

  @override
  Future<PromoModel> updatePromo(String id, Map<String, dynamic> promoData, {CancelToken? cancelToken}) async {
    final response = await dio.put(
      '${ApiConfig.adminPromos}/$id',
      data: promoData,
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: _timeout,
        receiveTimeout: _timeout,
      ),
    );
    return await compute(parsePromoCompute, response.data);
  }

  @override
  Future<void> deletePromo(String id, {CancelToken? cancelToken}) async {
    await dio.delete(
      '${ApiConfig.adminPromos}/$id',
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: _timeout,
        receiveTimeout: _timeout,
      ),
    );
  }

  @override
  Future<String> uploadImage(String filePath, {CancelToken? cancelToken}) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });

    final response = await dio.post(
      ApiConfig.adminUploadProductImage,
      data: formData,
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    final data = response.data;
    if (data is Map) {
      final imageUrl = data['url'] ?? data['data']?['url'] ?? data['imageUrl'] ?? data['path'];
      if (imageUrl != null) return imageUrl.toString();
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'فشل في رفع الصورة',
    );
  }
}
