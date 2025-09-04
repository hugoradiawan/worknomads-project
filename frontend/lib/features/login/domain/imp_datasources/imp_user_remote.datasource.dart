import 'package:dio/dio.dart';
import 'package:frontend/core/blocs/http_client/http_client.bloc.dart';
import 'package:frontend/core/usecase.dart' show BaseResponse;
import 'package:frontend/features/login/data/datasources/user_remote.datasource.dart'
    show UserRemoteDataSource;
import 'package:frontend/features/login/domain/params/login.params.dart'
    show LoginParams;
import 'package:frontend/features/login/domain/params/refresh_token.params.dart';
import 'package:frontend/features/login/domain/params/register.params.dart'
    show RegisterParams;
import 'package:frontend/features/login/domain/responses/login.response.dart'
    show LoginResponse;
import 'package:frontend/features/login/domain/responses/register.response.dart'
    show RegisterResponse;
import 'package:frontend/shared/domain/entities/token.dart' show Token;

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  static UserRemoteDataSourceImpl? _instance;

  UserRemoteDataSourceImpl._internal();

  factory UserRemoteDataSourceImpl() {
    _instance ??= UserRemoteDataSourceImpl._internal();
    return _instance!;
  }

  @override
  Future<BaseResponse<LoginResponse>> login(LoginParams params) async {
    try {
      final Response<dynamic>? response = await HttpBloc.i?.client.post(
        '/auth/login',
        data: params.toJson(),
      );
      if (response?.statusCode == 200) {
        return BaseResponse<LoginResponse>(
          data: LoginResponse.fromJson(response!.data?['data']),
          message: response.data['message'],
          serverId: response.data['server_id'],
          statusCode: response.statusCode,
          success: response.data['success'],
        );
      } else {
        return BaseResponse<LoginResponse>(
          data: null,
          message: response?.data['message'],
          statusCode: response?.statusCode,
          errorCode: response?.data['error_code'],
          serverId: response?.data['server_id'],
          success: response?.data['success'],
        );
      }
    } catch (e) {
      return BaseResponse<LoginResponse>(
        data: null,
        message: e.toString(),
        statusCode: 500,
        success: false,
      );
    }
  }

  @override
  Future<BaseResponse<RegisterResponse>> register(RegisterParams params) async {
    try {
      final Response<dynamic>? response = await HttpBloc.i?.client.post(
        '/auth/register',
        data: params.toJson(),
      );
      if (response?.statusCode == 201) {
        final RegisterResponse? registerResponse = RegisterResponse.fromJson(
          response!.data,
        );
        return registerResponse!;
      } else {
        return BaseResponse<RegisterResponse>(
          data: null,
          message: response?.data['message'],
          statusCode: response?.statusCode,
          errorCode: response?.data['error_code'],
          serverId: response?.data['server_id'],
          success: response?.data['success'],
        );
      }
    } catch (e) {
      return BaseResponse<RegisterResponse>(
        data: null,
        message: e.toString(),
        statusCode: 500,
        success: false,
      );
    }
  }

  @override
  Future<BaseResponse<Token>> refreshToken(
    RefreshTokenParams params,
  ) async {
    try {
      final Response<dynamic>? response = await HttpBloc.i?.client.post(
        '/auth/refreshtoken',
        data: params.toJson(),
      );
      if (response?.statusCode == 200) {
        return BaseResponse<Token>(
          data: Token.fromJson(response?.data['data']),
          message: response?.data['message'],
          statusCode: response?.statusCode,
          errorCode: response?.data['error_code'],
          serverId: response?.data['server_id'],
          success: response?.data['success'],
        );
      } else {
        return BaseResponse<Token>(
          data: null,
          message: response?.data['message'],
          statusCode: response?.statusCode,
          errorCode: response?.data['error_code'],
          serverId: response?.data['server_id'],
          success: response?.data['success'],
        );
      }
    } catch (e) {
      return BaseResponse<Token>(
        data: null,
        message: e.toString(),
        statusCode: 500,
        success: false,
      );
    }
  }
}
