import 'package:frontend/features/home/data/datasources/media_local.datasource.dart'
    show MediaLocalDataSource;
import 'package:frontend/features/home/data/models/media.model.dart' show MediaModel;

class MediaLocalDataSourceImpl implements MediaLocalDataSource {
  @override
  Future<List<MediaModel>> fetchMedia() {
    throw UnimplementedError();
  }
}
