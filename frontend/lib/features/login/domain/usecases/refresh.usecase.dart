import 'package:frontend/core/usecase.dart'
    show UseCase, Failure, BaseResponse, ServerFailure;
import 'package:frontend/features/login/data/repositories/user.repository.dart'
    show UserRepository;
import 'package:frontend/features/login/domain/imp_repositories/imp_user.repository.dart'
    show UserRepositoryImpl;
import 'package:frontend/features/login/domain/params/refresh_token.params.dart'
    show RefreshTokenParams;
import 'package:frontend/shared/domain/entities/token.dart' show Token;

class RefreshUseCase extends UseCase<Token, RefreshTokenParams> {
  final UserRepository userRepository;

  static RefreshUseCase? _instance;

  RefreshUseCase._internal({UserRepository? userRepository})
    : userRepository = userRepository ?? UserRepositoryImpl();

  factory RefreshUseCase({UserRepository? userRepository}) {
    _instance ??= RefreshUseCase._internal(
      userRepository: userRepository ?? UserRepositoryImpl(),
    );
    return _instance!;
  }

  @override
  Stream<({Failure? fail, BaseResponse<Token> ok})> call(
    RefreshTokenParams params,
  ) async* {
    await for (final event in userRepository.refreshToken(params)) {
      if (event.success) {
        yield (fail: null, ok: event);
      } else {
        yield (fail: ServerFailure(null), ok: event);
      }
    }
  }
}
