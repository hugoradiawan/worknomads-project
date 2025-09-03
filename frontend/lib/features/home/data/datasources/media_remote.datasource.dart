import 'package:frontend/core/usecase.dart' show BaseResponse;
import 'package:frontend/features/home/data/models/media.model.dart'
    show MediaModel;
import 'package:frontend/features/home/domain/params/fetch_media.params.dart';
import 'package:frontend/features/home/domain/params/upload_media.params.dart'
    show UploadMediaParams;
import 'package:frontend/features/home/domain/responses/media.response.dart'
    show MediaResponse;

abstract class MediaRemoteDataSource {
  Future<BaseResponse<MediaResponse>> fetchMedia(FetchMediaParams params);
  Future<BaseResponse<MediaModel>> upload(UploadMediaParams params);
}
