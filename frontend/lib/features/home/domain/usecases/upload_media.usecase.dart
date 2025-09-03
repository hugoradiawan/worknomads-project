import 'package:frontend/core/usecase.dart'
    show Failure, UseCase, BaseResponse, ServerFailure;
import 'package:frontend/features/home/data/repositories/media.repository.dart'
    show MediaRepository;
import 'package:frontend/features/home/domain/imp_repositories/impl_media.repository.dart'
    show MediaRepositoryImpl;
import 'package:frontend/features/home/domain/params/upload_media.params.dart';
import 'package:frontend/features/home/domain/responses/media_upload.response.dart'
    show UploadMediaResponse;

class UploadMediaUseCase
    extends UseCase<UploadMediaResponse, UploadMediaParams> {
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
  Stream<({Failure? fail, BaseResponse<UploadMediaResponse> ok})> call(
    UploadMediaParams params,
  ) async* {
    final BaseResponse<UploadMediaResponse> response = await mediaRepository
        .upload(params);
    if (response.success) {
      yield (fail: null, ok: response);
    } else {
      yield (fail: ServerFailure(null), ok: response);
    }
  }
}
