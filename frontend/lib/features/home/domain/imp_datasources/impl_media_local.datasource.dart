import 'dart:async' show Completer, StreamSubscription;

import 'package:frontend/core/base_response.dart' show BaseResponse;
import 'package:frontend/core/blocs/local_storage/events/local_storage.event.dart'
    show MediaListFetch;
import 'package:frontend/core/blocs/local_storage/local_storage.bloc.dart'
    show LocalStorageBloc;
import 'package:frontend/core/blocs/local_storage/states/local_media_response.state.dart'
    show LocalMediaResponseLoaded, LocalMediaResponseNotFound;
import 'package:frontend/core/blocs/local_storage/states/local_storage.state.dart'
    show LocalStorageState;
import 'package:frontend/features/home/data/datasources/media_local.datasource.dart'
    show MediaLocalDataSource;
import 'package:frontend/features/home/data/models/media.model.dart'
    show MediaModel;

class MediaLocalDataSourceImpl implements MediaLocalDataSource {
  @override
  Future<BaseResponse<List<MediaModel>>> fetchMedia() async {
    final Completer<BaseResponse<List<MediaModel>>> completer =
        Completer<BaseResponse<List<MediaModel>>>();
    StreamSubscription<LocalStorageState>? subscription;

    final stream = LocalStorageBloc.i?.stream;
    if (stream == null) {
      return BaseResponse<List<MediaModel>>(
        data: null,
        message: 'Refresh token failed (LocalStorageBloc not found)',
        statusCode: 404,
        success: false,
      );
    }

    try {
      subscription = stream.listen((state) {
        if (state is LocalMediaResponseLoaded) {
          if (!completer.isCompleted) {
            final List<dynamic> data =
                state.data['data'] != null &&
                    state.data['data'] is List<dynamic>
                ? state.data['data']
                : [];
            final List<MediaModel> mediaList = data
                .map(
                  (item) => MediaModel.fromJson(item as Map<String, dynamic>),
                )
                .toList();
            completer.complete(
              BaseResponse<List<MediaModel>>(
                data: mediaList,
                message: 'local fetch successful',
                statusCode: 200,
                success: true,
              ),
            );
          }
        } else if (state is LocalMediaResponseNotFound) {
          if (!completer.isCompleted) {
            completer.complete(
              BaseResponse<List<MediaModel>>(
                data: null,
                message: 'local fetch failed (not found)',
                statusCode: 404,
                success: false,
              ),
            );
          }
        }
      });

      LocalStorageBloc.i?.add(MediaListFetch());

      return await completer.future;
    } catch (e) {
      if (!completer.isCompleted) {
        completer.complete(
          BaseResponse<List<MediaModel>>(
            data: null,
            message: e.toString(),
            statusCode: 500,
            success: false,
          ),
        );
      }
      return completer.future;
    } finally {
      subscription?.cancel();
    }
  }
}
