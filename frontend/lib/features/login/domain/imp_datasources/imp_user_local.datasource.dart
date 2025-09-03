import 'dart:async' show Completer, StreamSubscription;

import 'package:frontend/core/blocs/local_storage/events/local_users.event.dart'
    show
        LocalLoginResponseFetch,
        LocalRegisterResponseFetch,
        LocalRefreshResponseFetch;
import 'package:frontend/core/blocs/local_storage/local_storage.bloc.dart';
import 'package:frontend/core/blocs/local_storage/states/local_login_response.state.dart'
    show
        LocalLoginResponseFetched,
        LocalLoginResponseNotFound,
        LocalRegisterResponseFetched,
        LocalRegisterResponseNotFound,
        LocalRefreshResponseNotFound,
        LocalRefreshResponseFetched;
import 'package:frontend/core/blocs/local_storage/states/local_storage.state.dart'
    show LocalStorageState;
import 'package:frontend/core/usecase.dart';
import 'package:frontend/features/login/data/datasources/user_local.datasource.dart'
    show UserLocalDataSource;
import 'package:frontend/features/login/domain/params/login.params.dart';
import 'package:frontend/features/login/domain/params/refresh_token.params.dart';
import 'package:frontend/features/login/domain/params/register.params.dart';
import 'package:frontend/features/login/domain/responses/login.response.dart';
import 'package:frontend/features/login/domain/responses/refresh.response.dart';
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
    StreamSubscription<LocalStorageState>? subscription;

    final stream = LocalStorageBloc.i?.stream;
    if (stream == null) {
      return BaseResponse<LoginResponse>(
        data: null,
        message: 'Login failed (LocalStorageBloc not found)',
        statusCode: 404,
        success: false,
      );
    }

    try {
      subscription = stream.listen((state) {
        if (state is LocalLoginResponseFetched) {
          if (!completer.isCompleted) {
            completer.complete(
              BaseResponse<LoginResponse>(
                data: state.response,
                message: 'local fetch successful',
                statusCode: 200,
                success: true,
              ),
            );
          }
        } else if (state is LocalLoginResponseNotFound) {
          if (!completer.isCompleted) {
            completer.complete(
              BaseResponse<LoginResponse>(
                data: null,
                message: 'local fetch failed (User not found)',
                statusCode: 404,
                success: false,
              ),
            );
          }
        }
      });

      LocalStorageBloc.i?.add(LocalLoginResponseFetch());

      return await completer.future;
    } catch (e) {
      if (!completer.isCompleted) {
        completer.complete(
          BaseResponse<LoginResponse>(
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

  @override
  Future<BaseResponse<RegisterResponse>> register(RegisterParams params) async {
    final Completer<BaseResponse<RegisterResponse>> completer =
        Completer<BaseResponse<RegisterResponse>>();
    StreamSubscription<LocalStorageState>? subscription;

    final stream = LocalStorageBloc.i?.stream;
    if (stream == null) {
      return BaseResponse<RegisterResponse>(
        data: null,
        message: 'Register failed (LocalStorageBloc not found)',
        statusCode: 404,
        success: false,
      );
    }

    try {
      subscription = stream.listen((state) {
        if (state is LocalRegisterResponseFetched) {
          if (!completer.isCompleted) {
            completer.complete(
              BaseResponse<RegisterResponse>(
                data: state.response,
                message: 'local fetch successful',
                statusCode: 200,
                success: true,
              ),
            );
          }
        } else if (state is LocalRegisterResponseNotFound) {
          if (!completer.isCompleted) {
            completer.complete(
              BaseResponse<RegisterResponse>(
                data: null,
                message: 'local fetch failed (User not found)',
                statusCode: 404,
                success: false,
              ),
            );
          }
        }
      });

      LocalStorageBloc.i?.add(LocalRegisterResponseFetch());

      return await completer.future;
    } catch (e) {
      if (!completer.isCompleted) {
        completer.complete(
          BaseResponse<RegisterResponse>(
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

  @override
  Future<BaseResponse<RefreshResponse>> refreshToken(
    RefreshTokenParams params,
  ) async {
    final Completer<BaseResponse<RefreshResponse>> completer =
        Completer<BaseResponse<RefreshResponse>>();
    StreamSubscription<LocalStorageState>? subscription;

    final stream = LocalStorageBloc.i?.stream;
    if (stream == null) {
      return BaseResponse<RefreshResponse>(
        data: null,
        message: 'Refresh token failed (LocalStorageBloc not found)',
        statusCode: 404,
        success: false,
      );
    }

    try {
      subscription = stream.listen((state) {
        if (state is LocalRefreshResponseFetched) {
          if (!completer.isCompleted) {
            completer.complete(
              BaseResponse<RefreshResponse>(
                data: state.response,
                message: 'local fetch successful',
                statusCode: 200,
                success: true,
              ),
            );
          }
        } else if (state is LocalRefreshResponseNotFound) {
          if (!completer.isCompleted) {
            completer.complete(
              BaseResponse<RefreshResponse>(
                data: null,
                message: 'local fetch failed (Token not found)',
                statusCode: 404,
                success: false,
              ),
            );
          }
        }
      });

      LocalStorageBloc.i?.add(LocalRefreshResponseFetch());

      return await completer.future;
    } catch (e) {
      if (!completer.isCompleted) {
        completer.complete(
          BaseResponse<RefreshResponse>(
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
