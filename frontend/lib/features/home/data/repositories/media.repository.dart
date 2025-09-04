import 'package:frontend/core/base_response.dart' show BaseResponse;
import 'package:frontend/features/home/data/models/media.model.dart' show MediaModel;
import 'package:frontend/features/home/domain/params/fetch_media.params.dart' show FetchMediaParams;
import 'package:frontend/features/home/domain/params/upload_media.params.dart';

abstract class MediaRepository {
  Stream<BaseResponse<List<MediaModel>>> list(FetchMediaParams params);
  Future<BaseResponse<MediaModel>> upload(UploadMediaParams params);
}
