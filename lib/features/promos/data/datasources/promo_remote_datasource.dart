import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/models/promo_model.dart';

abstract class PromoRemoteDataSource {
  Future<List<PromoModel>> getPromos();
  Future<PromoModel> addPromo(Map<String, dynamic> promoData);
  Future<PromoModel> updatePromo(String id, Map<String, dynamic> promoData);
  Future<void> deletePromo(String id);
}

class PromoRemoteDataSourceImpl implements PromoRemoteDataSource {
  final Dio dio;

  PromoRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PromoModel>> getPromos() async {
    try {
      final response = await dio.get(ApiConfig.adminPromos);
      if (response.statusCode == 200) {
        final List<dynamic> dataList = response.data;
        return dataList.map((json) => PromoModel.fromJson(json)).toList();
      } else {
        throw Exception('فشل في جلب الإعلانات');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<PromoModel> addPromo(Map<String, dynamic> promoData) async {
    try {
      final response = await dio.post(ApiConfig.adminPromos, data: promoData);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data['data'] ?? response.data;
        return PromoModel.fromJson(responseData);
      } else {
        throw Exception('فشل في إضافة الإعلان');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<PromoModel> updatePromo(String id, Map<String, dynamic> promoData) async {
    try {
      final response = await dio.put('${ApiConfig.adminPromos}/$id', data: promoData);
      if (response.statusCode == 200) {
        final responseData = response.data['data'] ?? response.data;
        return PromoModel.fromJson(responseData);
      } else {
        throw Exception('فشل في تحديث الإعلان');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deletePromo(String id) async {
    try {
      final response = await dio.delete('${ApiConfig.adminPromos}/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('فشل في حذف الإعلان');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

