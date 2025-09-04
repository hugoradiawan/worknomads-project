import 'package:frontend/core/base_response.dart' show BaseResponse;
import 'package:frontend/features/home/data/models/media.model.dart' show MediaModel;

abstract class MediaLocalDataSource {
  Future<BaseResponse<List<MediaModel>>> fetchMedia();
}
