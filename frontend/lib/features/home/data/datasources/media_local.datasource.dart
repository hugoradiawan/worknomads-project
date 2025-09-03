import 'package:frontend/features/home/domain/responses/media.response.dart' show MediaResponse;

abstract class MediaLocalDataSource {
  Future<List<MediaResponse>> fetchMedia();
}
