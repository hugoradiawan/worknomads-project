import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:frontend/core/blocs/http_client/http_client.bloc.dart';
import 'package:frontend/core/blocs/http_client/http_client.event.dart'
    show HttpSetToken;
import 'package:frontend/features/login/domain/params/refresh_token.params.dart'
    show RefreshTokenParams;
import 'package:frontend/shared/blocs/user.bloc.dart';
import 'package:frontend/shared/blocs/user.event.dart' show RefreshFetch;
import 'package:frontend/shared/blocs/user.state.dart'
    show RefreshFetched, RefreshFailed;

class AuthInterceptor extends InterceptorsWrapper {
  final HttpBloc _httpBloc;
  final Set<String> _refreshingRequests = {};

  AuthInterceptor(this._httpBloc);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _httpBloc.state.token;

    if (token?.accessToken != null && token!.accessToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint("HTTP Error: ${err.response?.statusCode} - ${err.message}");

    // Handle 403 Forbidden errors (token expired)
    if (err.response?.statusCode == 403) {
      final requestId =
          "${err.requestOptions.method}-${err.requestOptions.path}";

      // Prevent infinite loops - check if we're already refreshing this request
      if (_refreshingRequests.contains(requestId)) {
        debugPrint("Already refreshing token for this request, rejecting");
        return handler.reject(err);
      }

      if (_httpBloc.state.token?.refreshToken == null ||
          _httpBloc.state.token!.refreshToken!.isEmpty) {
        debugPrint("No refresh token available, cannot refresh");
        return super.onError(err, handler);
      }

      _refreshingRequests.add(requestId);
      debugPrint("Refreshing token...");

      UserBloc.i.stream
          .firstWhere(
            (state) => state is RefreshFetched || state is RefreshFailed,
          )
          .then((state) {
            _refreshingRequests.remove(requestId);

            if (state is RefreshFetched) {
              debugPrint(
                "Token refresh successful, updating HttpBloc and retrying request",
              );

              _httpBloc.add(HttpSetToken(state.token));

              Future.delayed(const Duration(milliseconds: 100), () {
                final options = err.requestOptions;
                final newToken = state.token?.accessToken;

                if (newToken != null && newToken.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $newToken';
                  debugPrint(
                    "Retrying request with new token: ${newToken.substring(0, 20)}...",
                  );

                  _httpBloc.client
                      .fetch(options)
                      .then(
                        (r) {
                          debugPrint("Request successful after token refresh");
                          handler.resolve(r);
                        },
                        onError: (e) {
                          debugPrint(
                            "Request failed even after token refresh: $e",
                          );
                          handler.reject(e as DioException);
                        },
                      );
                } else {
                  debugPrint("New token is null or empty after refresh");
                  handler.reject(err);
                }
              });
            } else {
              debugPrint("Token refresh failed");
              handler.reject(err);
            }
          })
          .catchError((error) {
            _refreshingRequests.remove(requestId);
            debugPrint("Error during token refresh: $error");
            handler.reject(err);
          });

      UserBloc.i.add(
        RefreshFetch(
          RefreshTokenParams(
            refreshToken: _httpBloc.state.token!.refreshToken!,
          ),
        ),
      );
      return;
    }

    super.onError(err, handler);
  }
}
