import 'package:frontend/core/usecase.dart' show BaseResponse;
import 'package:frontend/features/home/data/models/media.model.dart' show MediaModel;
import 'package:frontend/features/home/domain/params/fetch_media.params.dart' show FetchMediaParams;
import 'package:frontend/features/home/domain/params/upload_media.params.dart';
import 'package:frontend/features/home/domain/responses/media.response.dart';

abstract class MediaRepository {
  Stream<BaseResponse<MediaResponse>> list(FetchMediaParams params);
  Future<BaseResponse<MediaModel>> upload(UploadMediaParams params);
}
