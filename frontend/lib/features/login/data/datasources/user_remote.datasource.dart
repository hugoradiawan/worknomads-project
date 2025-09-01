import 'package:frontend/core/usecase.dart' show BaseResponse;
import 'package:frontend/features/login/domain/params/login.params.dart' show LoginParams;
import 'package:frontend/features/login/domain/params/refresh_token.params.dart' show RefreshTokenParams;
import 'package:frontend/features/login/domain/params/register.params.dart' show RegisterParams;
import 'package:frontend/features/login/domain/responses/login.response.dart' show LoginResponse;
import 'package:frontend/features/login/domain/responses/refresh.response.dart' show RefreshResponse;
import 'package:frontend/features/login/domain/responses/register.response.dart' show RegisterResponse;

abstract class UserRemoteDataSource {
  Future<BaseResponse<LoginResponse>> login(LoginParams params);
  Future<BaseResponse<RegisterResponse>> register(RegisterParams params);
  Future<BaseResponse<RefreshResponse>> refreshToken(RefreshTokenParams params);
}
