import 'package:dio/dio.dart';
import 'package:frontend/core/blocs/http_client/http_client.bloc.dart';

/// Interceptor to automatically add access token to request headers
class AuthInterceptor extends InterceptorsWrapper {
  final HttpBloc _httpBloc;

  AuthInterceptor(this._httpBloc);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Get the current token from the bloc state
    final token = _httpBloc.state.token;

    // Add Authorization header if access token exists
    if (token?.accessToken != null && token!.accessToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized errors (token expired)
    if (err.response?.statusCode == 401) {
      // You can add logic here to refresh the token or redirect to login
      // For now, we'll just pass the error through
    }

    super.onError(err, handler);
  }
}
