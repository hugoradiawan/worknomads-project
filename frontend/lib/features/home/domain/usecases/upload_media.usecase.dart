import 'package:frontend/core/base_response.dart' show BaseResponse;
import 'package:frontend/core/failure.dart' show Failure, ServerFailure;
import 'package:frontend/core/usecase.dart' show UseCase;
import 'package:frontend/features/home/data/models/media.model.dart'
    show MediaModel;
import 'package:frontend/features/home/data/repositories/media.repository.dart'
    show MediaRepository;
import 'package:frontend/features/home/domain/imp_repositories/impl_media.repository.dart'
    show MediaRepositoryImpl;
import 'package:frontend/features/home/domain/params/upload_media.params.dart';

class UploadMediaUseCase extends UseCase<MediaModel, UploadMediaParams> {
  final MediaRepository mediaRepository;

  static UploadMediaUseCase? _instance;

  UploadMediaUseCase._internal({MediaRepository? mediaRepository})
    : mediaRepository = mediaRepository ?? MediaRepositoryImpl();

  factory UploadMediaUseCase({MediaRepository? mediaRepository}) {
    _instance ??= UploadMediaUseCase._internal(
      mediaRepository: mediaRepository ?? MediaRepositoryImpl(),
    );
    return _instance!;
  }

  @override
  Stream<({Failure? fail, BaseResponse<MediaModel> ok})> call(
    UploadMediaParams params,
  ) async* {
    final BaseResponse<MediaModel> response = await mediaRepository.upload(
      params,
    );
    if (response.success) {
      yield (fail: null, ok: response);
    } else {
      yield (fail: ServerFailure(null), ok: response);
    }
  }
}
