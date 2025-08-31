import 'dart:async' show Completer;

import 'package:frontend/core/blocs/local_storage/events/local_users.event.dart'
    show LocalLoginResponseFetch, LocalRegisterResponseFetch;
import 'package:frontend/core/blocs/local_storage/local_storage.bloc.dart';
import 'package:frontend/core/blocs/local_storage/states/local_login_response.state.dart'
    show LocalLoginResponseFetched, LocalLoginResponseNotFound, LocalRegisterResponseFetched, LocalRegisterResponseNotFound;
import 'package:frontend/core/blocs/local_storage/states/local_storage.state.dart'
    show LocalStorageState;
import 'package:frontend/core/usecase.dart';
import 'package:frontend/features/login/data/datasources/user_local.datasource.dart'
    show UserLocalDataSource;
import 'package:frontend/features/login/domain/params/login.params.dart';
import 'package:frontend/features/login/domain/params/register.params.dart';
import 'package:frontend/features/login/domain/responses/login.response.dart';
import 'package:frontend/features/login/domain/responses/register.response.dart'
    show RegisterResponse;

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static UserLocalDataSourceImpl? _instance;

  UserLocalDataSourceImpl._internal();

  factory UserLocalDataSourceImpl() {
    _instance ??= UserLocalDataSourceImpl._internal();
    return _instance!;
  }

  @override
  Future<BaseResponse<LoginResponse>> login(LoginParams params) async {
    final Completer<BaseResponse<LoginResponse>> completer =
        Completer<BaseResponse<LoginResponse>>();
    final Stream<LocalStorageState>? subscription = LocalStorageBloc.i?.stream;
    if (subscription == null) {
      completer.complete(
        BaseResponse<LoginResponse>(
          data: null,
          message: 'Login failed (LocalStorageState not found)',
          statusCode: 404,
          success: false,
        ),
      );
      return completer.future;
    }
    try {
      subscription.listen((state) {
        if (state is LocalLoginResponseFetched) {
          completer.complete(
            BaseResponse<LoginResponse>(
              data: state.response,
              message: 'local fetch successful',
              statusCode: 200,
              success: true,
            ),
          );
          subscription.drain();
        } else if (state is LocalLoginResponseNotFound) {
          completer.complete(
            BaseResponse<LoginResponse>(
              data: null,
              message: 'local fetch failed (User not found)',
              statusCode: 404,
              success: false,
            ),
          );
          subscription.drain();
        }
      });
    } catch (e) {
      completer.complete(
        BaseResponse<LoginResponse>(
          data: null,
          message: e.toString(),
          statusCode: 500,
          success: false,
        ),
      );
      subscription.drain();
    }
    LocalStorageBloc.i?.add(LocalLoginResponseFetch());
    return completer.future;
  }

  @override
  Future<BaseResponse<RegisterResponse>> register(RegisterParams params) async {
    final Completer<BaseResponse<RegisterResponse>> completer =
        Completer<BaseResponse<RegisterResponse>>();
    final Stream<LocalStorageState>? subscription = LocalStorageBloc.i?.stream;
    if (subscription == null) {
      completer.complete(
        BaseResponse<RegisterResponse>(
          data: null,
          message: 'Register failed (LocalStorageState not found)',
          statusCode: 404,
          success: false,
        ),
      );
      return completer.future;
    }
    try {
      subscription.listen((state) {
        if (state is LocalRegisterResponseFetched) {
          completer.complete(
            BaseResponse<RegisterResponse>(
              data: state.response,
              message: 'local fetch successful',
              statusCode: 200,
              success: true,
            ),
          );
          subscription.drain();
        } else if (state is LocalRegisterResponseNotFound) {
          completer.complete(
            BaseResponse<RegisterResponse>(
              data: null,
              message: 'local fetch failed (User not found)',
              statusCode: 404,
              success: false,
            ),
          );
          subscription.drain();
        }
      });
    } catch (e) {
      completer.complete(
        BaseResponse<RegisterResponse>(
          data: null,
          message: e.toString(),
          statusCode: 500,
          success: false,
        ),
      );
      subscription.drain();
    }
    LocalStorageBloc.i?.add(LocalRegisterResponseFetch());
    return completer.future;
  }
}
