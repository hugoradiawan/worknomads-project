import 'package:dio/dio.dart' show Response, FormData, MultipartFile;
import 'package:dio/dio.dart' show Response, MultipartFile, FormData;
import 'package:frontend/core/base_response.dart' show BaseResponse;
import 'package:frontend/core/blocs/http_client/http_client.bloc.dart'
    show HttpBloc;
import 'package:frontend/features/home/data/datasources/media_remote.datasource.dart'
    show MediaRemoteDataSource;
import 'package:frontend/features/home/data/models/media.model.dart'
    show MediaModel;
import 'package:frontend/features/home/domain/params/fetch_media.params.dart'
    show FetchMediaParams;
import 'package:frontend/features/home/domain/params/upload_media.params.dart'
    show UploadMediaParams;

class MediaRemoteDataSourceImpl implements MediaRemoteDataSource {
  @override
  Future<BaseResponse<List<MediaModel>>> fetchMedia(
    FetchMediaParams params,
  ) async {
    try {
      final Response<dynamic>? response = await HttpBloc.i?.client.get(
        '/media/list/',
        data: params.toJson(),
      );
      if (response?.statusCode == 200) {
        final List<dynamic> mediaList = response?.data['data'] is List
            ? response?.data['data']
            : [];

        return BaseResponse<List<MediaModel>>(
          data: mediaList.map((item) => MediaModel.fromJson(item)).toList(),
          message: response?.data['message'],
          statusCode: response?.statusCode,
          errorCode: response?.data['error_code'],
          serverId: response?.data['server_id'],
          success: response?.data['success'],
        );
      } else {
        return BaseResponse<List<MediaModel>>(
          data: null,
          message: response?.data['message'],
          statusCode: response?.statusCode,
          errorCode: response?.data['error_code'],
          serverId: response?.data['server_id'],
          success: response?.data['success'],
        );
      }
    } catch (e) {
      return BaseResponse<List<MediaModel>>(
        data: null,
        message: e.toString(),
        statusCode: 500,
        success: false,
      );
    }
  }

  @override
  Future<BaseResponse<MediaModel>> upload(UploadMediaParams params) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          params.file.path,
          filename: params.file.path.split('/').last,
        ),
        'media_type': params.type.name,
        'metadata': params.metadata,
      });

      final Response<dynamic>? response = await HttpBloc.i?.client.post(
        '/media/upload/',
        data: formData,
      );
      if (response?.statusCode == 201) {
        return BaseResponse<MediaModel>(
          data: MediaModel.fromJson(response?.data['data']),
          message: response?.data['message'],
          statusCode: response?.statusCode,
          errorCode: response?.data['error_code'],
          serverId: response?.data['server_id'],
          success: response?.data['success'],
        );
      } else {
        return BaseResponse<MediaModel>(
          data: null,
          message: response?.data['message'],
          statusCode: response?.statusCode,
          errorCode: response?.data['error_code'],
          serverId: response?.data['server_id'],
          success: response?.data['success'],
        );
      }
    } catch (e) {
      return BaseResponse<MediaModel>(
        data: null,
        message: e.toString(),
        statusCode: 500,
        success: false,
      );
    }
  }
}
