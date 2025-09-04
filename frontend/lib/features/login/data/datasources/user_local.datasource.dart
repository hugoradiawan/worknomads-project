import 'package:frontend/core/usecase.dart' show BaseResponse;
import 'package:frontend/features/login/domain/params/login.params.dart'
    show LoginParams;
import 'package:frontend/features/login/domain/params/refresh_token.params.dart' show RefreshTokenParams;
import 'package:frontend/features/login/domain/params/register.params.dart' show RegisterParams;
import 'package:frontend/features/login/domain/responses/login.response.dart' show LoginResponse;
import 'package:frontend/features/login/domain/responses/register.response.dart';
import 'package:frontend/shared/domain/entities/token.dart' show Token;

abstract class UserLocalDataSource {
  Future<BaseResponse<LoginResponse>> login(LoginParams params);
  Future<BaseResponse<RegisterResponse>> register(RegisterParams params);
  Future<BaseResponse<Token>> refreshToken(RefreshTokenParams params);
}
