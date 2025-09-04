import 'package:frontend/core/base_response.dart' show BaseResponse;
import 'package:frontend/core/failure.dart' show Failure, ServerFailure;
import 'package:frontend/core/usecase.dart' show UseCase;
import 'package:frontend/features/login/data/repositories/user.repository.dart' show UserRepository;
import 'package:frontend/features/login/domain/imp_repositories/imp_user.repository.dart' show UserRepositoryImpl;
import 'package:frontend/features/login/domain/params/register.params.dart' show RegisterParams;
import 'package:frontend/features/login/domain/responses/register.response.dart' show RegisterResponse;

class RegisterUseCase extends UseCase<RegisterResponse, RegisterParams> {
  final UserRepository userRepository;

  static RegisterUseCase? _instance;

  RegisterUseCase._internal({UserRepository? userRepository})
    : userRepository = userRepository ?? UserRepositoryImpl();

  factory RegisterUseCase({UserRepository? userRepository}) {
    _instance ??= RegisterUseCase._internal(
      userRepository: userRepository ?? UserRepositoryImpl(),
    );
    return _instance!;
  }

  @override
  Stream<({Failure? fail, BaseResponse<RegisterResponse> ok})> call(
    RegisterParams params,
  ) async* {
    await for (final event in userRepository.register(params)) {
      if (event.success) {
        yield (fail: null, ok: event);
      } else {
        yield (fail: ServerFailure(null), ok: event);
      }
    }
  }
}
