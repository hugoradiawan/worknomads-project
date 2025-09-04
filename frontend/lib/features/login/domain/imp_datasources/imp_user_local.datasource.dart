import 'package:frontend/core/base_response.dart' show BaseResponse;
import 'package:frontend/features/login/data/datasources/user_local.datasource.dart'
    show UserLocalDataSource;
import 'package:frontend/features/login/domain/params/login.params.dart';
import 'package:frontend/features/login/domain/params/refresh_token.params.dart';
import 'package:frontend/features/login/domain/params/register.params.dart';
import 'package:frontend/features/login/domain/responses/login.response.dart'
    show LoginResponse;
import 'package:frontend/features/login/domain/responses/register.response.dart'
    show RegisterResponse;
import 'package:frontend/shared/domain/entities/token.dart' show Token;

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static UserLocalDataSourceImpl? _instance;

  UserLocalDataSourceImpl._internal();

  factory UserLocalDataSourceImpl() {
    _instance ??= UserLocalDataSourceImpl._internal();
    return _instance!;
  }

  @override
  Future<BaseResponse<LoginResponse>> login(LoginParams params) async {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<RegisterResponse>> register(RegisterParams params) async {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<Token>> refreshToken(
    RefreshTokenParams params,
  ) async {
    throw UnimplementedError();
  }
}
