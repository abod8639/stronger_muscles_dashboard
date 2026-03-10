import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<Map<String, dynamic>> getUsersStats();
  Future<List<UserModel>> getUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> getUsersStats() async {
    final response = await dio.get('/users/stats');
    if (response.statusCode == 200) {
      return response.data;
    }
    throw Exception('Failed to load user stats');
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await dio.get('/users');
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((e) => UserModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load users');
  }
}
