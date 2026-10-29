import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import '../models/user_model.dart';
import '../models/users_stats_model.dart';

abstract class UserRemoteDataSource {
  Future<UsersStatsModel> getUsersStats({CancelToken? cancelToken});
  Future<List<UserModel>> getUsers({CancelToken? cancelToken});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSourceImpl(this._dio);

  @override
  Future<UsersStatsModel> getUsersStats({CancelToken? cancelToken}) async {
    final response = await _dio.get(
      ApiConfig.adminUsers,
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: const Duration(seconds: 35),
        receiveTimeout: const Duration(seconds: 35),
      ),
    );
    final decoded = response.data;
    final Map<String, dynamic> rawMap;
    if (decoded is Map<String, dynamic>) {
      rawMap = (decoded.containsKey('data') && decoded['data'] is Map<String, dynamic>)
          ? decoded['data'] as Map<String, dynamic>
          : decoded;
    } else {
      rawMap = {};
    }

    return await compute(_parseUsersStatsCompute, rawMap);
  }

  @override
  Future<List<UserModel>> getUsers({CancelToken? cancelToken}) async {
    final response = await _dio.get(
      ApiConfig.adminUsers,
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: const Duration(seconds: 35),
        receiveTimeout: const Duration(seconds: 35),
      ),
    );
    final data = response.data;
    dynamic rawList;
    if (data is Map && data.containsKey('data')) {
      final inner = data['data'];
      if (inner is Map && inner.containsKey('users')) {
        rawList = inner['users'];
      } else if (inner is List) {
        rawList = inner;
      } else {
        rawList = [];
      }
    } else if (data is Map && data.containsKey('users')) {
      rawList = data['users'];
    } else if (data is List) {
      rawList = data;
    } else {
      rawList = [];
    }

    return await compute(_parseUsersListCompute, rawList);
  }
}

UsersStatsModel _parseUsersStatsCompute(Map<String, dynamic> json) {
  return UsersStatsModel.fromJson(json);
}

List<UserModel> _parseUsersListCompute(dynamic data) {
  if (data is List) {
    return data
        .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
  return [];
}
