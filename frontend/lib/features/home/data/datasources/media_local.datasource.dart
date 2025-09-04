import 'package:frontend/features/home/data/models/media.model.dart' show MediaModel;

abstract class MediaLocalDataSource {
  Future<List<MediaModel>> fetchMedia();
}
