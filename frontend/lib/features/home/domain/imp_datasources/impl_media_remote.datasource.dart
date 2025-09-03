import 'package:dio/dio.dart' show Response;
import 'package:frontend/core/blocs/http_client/http_client.bloc.dart' show HttpBloc;
import 'package:frontend/core/usecase.dart' show BaseResponse;
import 'package:frontend/features/home/data/datasources/media_remote.datasource.dart'
    show MediaRemoteDataSource;
import 'package:frontend/features/home/domain/params/fetch_media.params.dart'
    show FetchMediaParams;
import 'package:frontend/features/home/domain/params/upload_media.params.dart'
    show UploadMediaParams;
import 'package:frontend/features/home/domain/responses/media.response.dart'
    show MediaResponse;
import 'package:frontend/features/home/domain/responses/media_upload.response.dart';

class MediaRemoteDataSourceImpl implements MediaRemoteDataSource {
  @override
  Future<BaseResponse<MediaResponse>> fetchMedia(FetchMediaParams params) {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<UploadMediaResponse>> upload(UploadMediaParams params) async {
        try {
      final Response<dynamic>? response = await HttpBloc.i?.client.post(
        '/media/upload/',
        data: params.toJson(),
      );
      if (response?.statusCode == 200) {
        final UploadMediaResponse? uploadResponse = UploadMediaResponse.fromJson(
          response!.data,
        );
        return BaseResponse<UploadMediaResponse>(
          data: uploadResponse!,
          message: response.data['message'],
          statusCode: response.statusCode,
          errorCode: response.data['error_code'],
          serverId: response.data['server_id'],
          success: response.data['success'],
        );
      } else {
        return BaseResponse<UploadMediaResponse>(
          data: null,
          message: response?.data['message'],
          statusCode: response?.statusCode,
          errorCode: response?.data['error_code'],
          serverId: response?.data['server_id'],
          success: response?.data['success'],
        );
      }
    } catch (e) {
      return BaseResponse<UploadMediaResponse>(
        data: null,
        message: e.toString(),
        statusCode: 500,
        success: false,
      );
    }
  }
}
