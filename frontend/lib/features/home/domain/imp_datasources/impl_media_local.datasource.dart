import 'package:frontend/features/home/data/datasources/media_local.datasource.dart'
    show MediaLocalDataSource;
import 'package:frontend/features/home/domain/responses/media.response.dart'
    show MediaResponse;

class MediaLocalDataSourceImpl implements MediaLocalDataSource {
  @override
  Future<List<MediaResponse>> fetchMedia() {
    throw UnimplementedError();
  }
}
