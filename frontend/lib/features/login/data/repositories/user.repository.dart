import 'package:frontend/core/usecase.dart' show BaseResponse;
import 'package:frontend/features/login/domain/params/login.params.dart'
    show LoginParams;
import 'package:frontend/features/login/domain/params/register.params.dart'
    show RegisterParams;
import 'package:frontend/features/login/domain/responses/login.response.dart'
    show LoginResponse;
import 'package:frontend/features/login/domain/responses/register.response.dart' show RegisterResponse;

abstract class UserRepository {
  Stream<BaseResponse<LoginResponse>> login(LoginParams params);

  Stream<BaseResponse<RegisterResponse>> register(RegisterParams params);
}
