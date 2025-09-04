import 'package:frontend/core/usecase.dart' show BaseResponse;
import 'package:frontend/features/login/data/datasources/user_local.datasource.dart'
    show UserLocalDataSource;
import 'package:frontend/features/login/data/datasources/user_remote.datasource.dart'
    show UserRemoteDataSource;
import 'package:frontend/features/login/data/repositories/user.repository.dart'
    show UserRepository;
import 'package:frontend/features/login/domain/imp_datasources/imp_user_remote.datasource.dart'
    show UserRemoteDataSourceImpl;
import 'package:frontend/features/login/domain/params/login.params.dart'
    show LoginParams;
import 'package:frontend/features/login/domain/params/refresh_token.params.dart';
import 'package:frontend/features/login/domain/params/register.params.dart';
import 'package:frontend/features/login/domain/responses/login.response.dart'
    show LoginResponse;
import 'package:frontend/features/login/domain/responses/register.response.dart'
    show RegisterResponse;
import 'package:frontend/shared/domain/entities/token.dart' show Token;

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  final UserLocalDataSource? userLocalDataSource;

  static UserRepositoryImpl? _instance;

  UserRepositoryImpl._internal({
    UserRemoteDataSource? userRemoteDataSource,
    this.userLocalDataSource,
  }) : userRemoteDataSource =
           userRemoteDataSource ?? UserRemoteDataSourceImpl();

  factory UserRepositoryImpl({
    UserRemoteDataSource? userRemoteDataSource,
    UserLocalDataSource? userLocalDataSource,
  }) {
    _instance ??= UserRepositoryImpl._internal(
      userRemoteDataSource: userRemoteDataSource,
      userLocalDataSource: userLocalDataSource,
    );
    return _instance!;
  }

  @override
  Stream<BaseResponse<LoginResponse>> login(LoginParams params) async* {
    yield await userRemoteDataSource.login(params);
  }

  @override
  Stream<BaseResponse<RegisterResponse>> register(
    RegisterParams params,
  ) async* {
    yield await userRemoteDataSource.register(params);
  }

  @override
  Stream<BaseResponse<Token>> refreshToken(
    RefreshTokenParams params,
  ) async* {
    yield await userRemoteDataSource.refreshToken(params);
  }
}
