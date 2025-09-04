import 'package:frontend/core/base_response.dart' show BaseResponse;
import 'package:frontend/features/home/data/datasources/media_local.datasource.dart'
    show MediaLocalDataSource;
import 'package:frontend/features/home/data/datasources/media_remote.datasource.dart'
    show MediaRemoteDataSource;
import 'package:frontend/features/home/data/models/media.model.dart'
    show MediaModel;
import 'package:frontend/features/home/data/repositories/media.repository.dart'
    show MediaRepository;
import 'package:frontend/features/home/domain/imp_datasources/impl_media_local.datasource.dart'
    show MediaLocalDataSourceImpl;
import 'package:frontend/features/home/domain/imp_datasources/impl_media_remote.datasource.dart'
    show MediaRemoteDataSourceImpl;
import 'package:frontend/features/home/domain/params/fetch_media.params.dart'
    show FetchMediaParams;
import 'package:frontend/features/home/domain/params/upload_media.params.dart';

class MediaRepositoryImpl implements MediaRepository {
  final MediaRemoteDataSource mediaRemoteDataSource;
  final MediaLocalDataSource mediaLocalDataSource;

  static MediaRepositoryImpl? _instance;

  MediaRepositoryImpl._internal({
    MediaRemoteDataSource? mediaRemoteDataSource,
    MediaLocalDataSource? mediaLocalDataSource,
  }) : mediaRemoteDataSource =
           mediaRemoteDataSource ?? MediaRemoteDataSourceImpl(),
       mediaLocalDataSource =
           mediaLocalDataSource ?? MediaLocalDataSourceImpl();

  factory MediaRepositoryImpl({
    MediaRemoteDataSource? mediaRemoteDataSource,
    MediaLocalDataSource? mediaLocalDataSource,
  }) {
    _instance ??= MediaRepositoryImpl._internal(
      mediaRemoteDataSource: mediaRemoteDataSource,
      mediaLocalDataSource: mediaLocalDataSource,
    );
    return _instance!;
  }

  @override
  Stream<BaseResponse<List<MediaModel>>> list(FetchMediaParams params) async* {
    yield await mediaLocalDataSource.fetchMedia();
    final BaseResponse<List<MediaModel>> remoteResponse =
        await mediaRemoteDataSource.fetchMedia(params);
    if (remoteResponse.success && remoteResponse.data != null) {
      yield remoteResponse;
    }
  }

  @override
  Future<BaseResponse<MediaModel>> upload(UploadMediaParams params) =>
      mediaRemoteDataSource.upload(params);
}
