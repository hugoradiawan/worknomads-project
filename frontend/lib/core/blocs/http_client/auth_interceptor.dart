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

/// HTTP interceptor that handles authentication for all API requests.
///
/// This interceptor automatically:
/// - Adds JWT access tokens to request headers
/// - Detects expired tokens (403 errors) and refreshes them automatically
/// - Retries failed requests with new tokens after refresh
/// - Prevents infinite refresh loops for the same request
class AuthInterceptor extends InterceptorsWrapper {
  /// Reference to HttpBloc for accessing current token state
  final HttpBloc _httpBloc;

  /// Set of currently refreshing requests to prevent infinite loops.
  /// Uses request method + path as unique identifier (e.g., "GET-/api/users")
  final Set<String> _refreshingRequests = {};

  /// Creates a new AuthInterceptor instance.
  AuthInterceptor(this._httpBloc);

  /// Intercepts outgoing HTTP requests to add authentication headers.
  ///
  /// Automatically adds the `Authorization: Bearer <token>` header to all
  /// requests if a valid access token is available in the HttpBloc state.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Get the current token from the bloc state
    final token = _httpBloc.state.token;

    // Add Authorization header if access token exists and is not empty
    if (token?.accessToken != null && token!.accessToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }

    // Continue with the request processing
    super.onRequest(options, handler);
  }

  /// Intercepts HTTP errors and handles token refresh for 403 (Forbidden) responses.
  ///
  /// **Token Refresh Flow:**
  /// 1. Detect 403 error (token expired/invalid)
  /// 2. Check if refresh token is available
  /// 3. Prevent duplicate refresh attempts for same request
  /// 4. Trigger refresh via UserBloc
  /// 5. Wait for refresh completion
  /// 6. Update HttpBloc with new token
  /// 7. Retry original request with new token
  ///
  /// **Error Handling:**
  /// - 403 + no refresh token → Pass error through
  /// - 403 + already refreshing → Reject to prevent loops
  /// - Refresh success → Retry request with new token
  /// - Refresh failure → Pass original error through
  /// - Other errors → Pass through unchanged
  ///
  /// [err] - The DioException that occurred
  /// [handler] - Handler to resolve/reject the request
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint("HTTP Error: ${err.response?.statusCode} - ${err.message}");

    // Handle 403 Forbidden errors (token expired/invalid)
    if (err.response?.statusCode == 403) {
      // Create unique identifier for this request to prevent duplicate refreshes
      final requestId =
          "${err.requestOptions.method}-${err.requestOptions.path}";

      // Prevent infinite loops - check if we're already refreshing this request
      if (_refreshingRequests.contains(requestId)) {
        debugPrint("Already refreshing token for this request, rejecting");
        return handler.reject(err);
      }

      // Check if refresh token is available for token refresh
      if (_httpBloc.state.token?.refreshToken == null ||
          _httpBloc.state.token!.refreshToken!.isEmpty) {
        debugPrint("No refresh token available, cannot refresh");
        return super.onError(err, handler);
      }

      // Mark this request as currently being refreshed
      _refreshingRequests.add(requestId);
      debugPrint("Refreshing token...");

      // Listen for token refresh completion from UserBloc
      UserBloc.i.stream
          .firstWhere(
            (state) => state is RefreshFetched || state is RefreshFailed,
          )
          .then((state) {
            // Remove from refreshing set regardless of success/failure
            _refreshingRequests.remove(requestId);

            if (state is RefreshFetched) {
              // Token refresh was successful
              debugPrint(
                "Token refresh successful, updating HttpBloc and retrying request",
              );

              // Update HttpBloc with the new token from UserBloc
              _httpBloc.add(HttpSetToken(state.token));

              // Small delay to ensure HttpBloc state is updated before retry
              Future.delayed(const Duration(milliseconds: 100), () {
                final options = err.requestOptions;
                final newToken = state.token?.accessToken;

                if (newToken != null && newToken.isNotEmpty) {
                  // Update request headers with new token
                  options.headers['Authorization'] = 'Bearer $newToken';
                  debugPrint(
                    "Retrying request with new token: ${newToken.substring(0, 20)}...",
                  );

                  // Retry the original request with new token
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
              // Token refresh failed, pass through original error
              debugPrint("Token refresh failed");
              handler.reject(err);
            }
          })
          .catchError((error) {
            // Handle any errors during the refresh process
            _refreshingRequests.remove(requestId);
            debugPrint("Error during token refresh: $error");
            handler.reject(err);
          });

      // Trigger token refresh via UserBloc
      UserBloc.i.add(
        RefreshFetch(
          RefreshTokenParams(
            refreshToken: _httpBloc.state.token!.refreshToken!,
          ),
        ),
      );

      // Important: Don't call super.onError to prevent double error handling
      return;
    }

    // For all other errors (not 403), pass through to default handler
    super.onError(err, handler);
  }
}
