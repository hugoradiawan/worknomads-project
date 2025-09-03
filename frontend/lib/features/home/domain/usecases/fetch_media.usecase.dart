import 'package:frontend/core/usecase.dart'
    show Failure, UseCase, BaseResponse, ServerFailure;
import 'package:frontend/features/home/data/repositories/media.repository.dart' show MediaRepository;
import 'package:frontend/features/home/domain/imp_repositories/impl_media.repository.dart' show MediaRepositoryImpl;
import 'package:frontend/features/home/domain/params/fetch_media.params.dart' show FetchMediaParams;
import 'package:frontend/features/home/domain/responses/media.response.dart';

class FetchMediaUseCase extends UseCase<MediaResponse, FetchMediaParams> {
  final MediaRepository userRepository;

  static FetchMediaUseCase? _instance;

  FetchMediaUseCase._internal({MediaRepository? userRepository})
    : userRepository = userRepository ?? MediaRepositoryImpl();

  factory FetchMediaUseCase({MediaRepository? userRepository}) {
    _instance ??= FetchMediaUseCase._internal(
      userRepository: userRepository ?? MediaRepositoryImpl(),
    );
    return _instance!;
  }

  @override
  Stream<({Failure? fail, BaseResponse<MediaResponse> ok})> call(
    FetchMediaParams params,
  ) async* {
    await for (final event in userRepository.list(params)) {
      if (event.success) {
        yield (fail: null, ok: event);
      } else {
        yield (fail: ServerFailure(null), ok: event);
      }
    }
  }
}
