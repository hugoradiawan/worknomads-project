import 'package:frontend/core/base_response.dart' show BaseResponse;
import 'package:frontend/core/failure.dart' show Failure, ServerFailure;
import 'package:frontend/core/usecase.dart'
    show UseCase;
import 'package:frontend/features/login/data/repositories/user.repository.dart'
    show UserRepository;
import 'package:frontend/features/login/domain/imp_repositories/imp_user.repository.dart';
import 'package:frontend/features/login/domain/params/login.params.dart'
    show LoginParams;
import 'package:frontend/features/login/domain/responses/login.response.dart'
    show LoginResponse;

class LoginUseCase extends UseCase<LoginResponse, LoginParams> {
  final UserRepository userRepository;

  static LoginUseCase? _instance;

  LoginUseCase._internal({UserRepository? userRepository})
    : userRepository = userRepository ?? UserRepositoryImpl();

  factory LoginUseCase({UserRepository? userRepository}) {
    _instance ??= LoginUseCase._internal(
      userRepository: userRepository ?? UserRepositoryImpl(),
    );
    return _instance!;
  }

  @override
  Stream<({Failure? fail, BaseResponse<LoginResponse> ok})> call(
    LoginParams params,
  ) async* {
    await for (final event in userRepository.login(params)) {
      if (event.success) {
        yield (fail: null, ok: event);
      } else {
        yield (fail: ServerFailure(null), ok: event);
      }
    }
  }
}
