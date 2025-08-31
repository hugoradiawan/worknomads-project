import 'package:frontend/core/usecase.dart' show BaseResponse;
import 'package:frontend/features/login/domain/params/login.params.dart'
    show LoginParams;
import 'package:frontend/features/login/domain/responses/login.response.dart'
    show LoginResponse;

abstract class UserLocalDataSource {
  Future<BaseResponse<LoginResponse>> login(LoginParams params);
}
