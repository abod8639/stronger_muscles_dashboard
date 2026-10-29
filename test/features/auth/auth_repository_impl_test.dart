import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/auth/data/models/auth_model.dart';
import 'package:stronger_muscles_dashboard/features/auth/data/repositories/auth_repository_impl.dart';

class MockRemoteDataSource implements AuthRemoteDataSource {
  AuthModel? mockModel;
  Exception? exceptionToThrow;

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockModel!;
  }

  @override
  Future<AuthModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockModel!;
  }
}

class MockLocalDataSource implements AuthLocalDataSource {
  String? token;
  Map<String, dynamic>? userJson;
  bool cleared = false;
  Exception? exceptionToThrow;

  @override
  Future<void> saveToken(String token) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    this.token = token;
  }

  @override
  Future<String?> getToken() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return token;
  }

  @override
  Future<void> clearToken() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    token = null;
  }

  @override
  Future<bool> hasToken() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return token != null && token!.isNotEmpty;
  }

  @override
  Future<void> saveUser(Map<String, dynamic> userJson) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    this.userJson = userJson;
  }

  @override
  Future<Map<String, dynamic>?> getUser() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return userJson;
  }

  @override
  Future<void> clearAll() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    token = null;
    userJson = null;
    cleared = true;
  }
}

void main() {
  late MockRemoteDataSource remoteDataSource;
  late MockLocalDataSource localDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  const tAuthModel = AuthModel(
    id: '1',
    name: 'Admin',
    email: 'admin@gym.com',
    role: 'super_admin',
    token: 'jwt-xyz',
    profileImage: 'profile.jpg',
  );

  group('AuthRepositoryImpl.login', () {
    test(
      'should cache token & user, and return Right(AuthEntity) on success',
      () async {
        remoteDataSource.mockModel = tAuthModel;

        final result = await repository.login(
          email: 'admin@gym.com',
          password: 'password123',
        );

        expect(result.isRight(), true);
        result.fold((failure) => fail('Expected Right but got Left'), (entity) {
          expect(entity.id, '1');
          expect(entity.name, 'Admin');
          expect(entity.token, 'jwt-xyz');
          expect(entity.isSuperAdmin, true);
        });
        expect(localDataSource.token, 'jwt-xyz');
        expect(localDataSource.userJson?['id'], '1');
      },
    );

    test(
      'should return Left(ServerFailure) without throwing when remote fails',
      () async {
        remoteDataSource.exceptionToThrow = const ServerException(
          message: 'Invalid credentials',
          statusCode: 401,
        );

        final result = await repository.login(
          email: 'bad@gym.com',
          password: 'wrong',
        );

        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Invalid credentials');
        }, (entity) => fail('Expected Left but got Right'));
      },
    );
  });

  group('AuthRepositoryImpl.logout', () {
    test('should purge local cache and return Right(unit)', () async {
      localDataSource.token = 'existing-token';

      final result = await repository.logout();

      expect(result.isRight(), true);
      expect(result.getRight().toNullable(), equals(unit));
      expect(localDataSource.cleared, true);
    });
  });
}
