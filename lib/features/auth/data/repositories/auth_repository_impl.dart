import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthEntity> login(String email, String password) async {
    final authModel = await remoteDataSource.login(email, password);
    if (authModel.token != null) {
      await localDataSource.saveToken(authModel.token!);
    }
    await localDataSource.saveUser(authModel.toJson());
    return authModel;
  }

  @override
  Future<AuthEntity> signup(String name, String email, String password) async {
    final authModel = await remoteDataSource.signup(name, email, password);
    if (authModel.token != null) {
      await localDataSource.saveToken(authModel.token!);
    }
    await localDataSource.saveUser(authModel.toJson());
    return authModel;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearToken();
  }

  @override
  bool isLoggedIn() {
    return localDataSource.hasToken();
  }

  @override
  String? getToken() {
    return localDataSource.getToken();
  }

  @override
  AuthEntity? getCurrentUser() {
    final userMap = localDataSource.getUser();
    if (userMap != null) {
      return AuthModel.fromJson(userMap);
    }
    return null;
  }
}
