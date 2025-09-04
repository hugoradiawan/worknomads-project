import 'package:equatable/equatable.dart';
import 'package:frontend/core/base_response.dart' show BaseResponse;
import 'package:frontend/shared/domain/entities/token.dart' show Token;

/// Initial state of the HTTP client before setup or after token updates.
class HttpInitial extends HttpState {
  /// Creates an HttpInitial state with an optional authentication token.
  const HttpInitial({super.token});
}

/// State indicating the HTTP client is being configured and set up.
///
/// This transient state occurs when the Dio HTTP client is being
/// initialized with its base configuration, interceptors, and other
/// necessary setup components.
class HttpSettingUp extends HttpState {
  /// Creates an HttpSettingUp state with the current authentication token.
  const HttpSettingUp({super.token});
}

/// State indicating the HTTP client is ready but not currently used.
class HttpIsReady extends HttpState {
  /// Creates an HttpIsReady state with the current authentication token.
  const HttpIsReady({super.token});
}

/// State indicating an HTTP request is currently in progress.
///
/// This state is emitted when any HTTP request (GET, POST, PUT, DELETE, etc.)
/// is actively being processed. It's useful for showing loading indicators
/// in the UI during network operations.
class HttpLoading extends HttpState {
  /// Creates an HttpLoading state with the current authentication token.
  const HttpLoading({super.token});
}

/// State indicating the HTTP client is fully configured and ready for use.
///
/// This state represents that the Dio HTTP client has been successfully
/// set up and is ready to handle HTTP requests. All interceptors are
/// configured, base URL is set, and authentication is properly initialized.
class HttpLoaded extends HttpState {
  /// Creates an HttpLoaded state with the current authentication token.
  const HttpLoaded({super.token});
}

/// State representing a successful HTTP response.
///
/// This state is emitted when an HTTP request completes successfully
/// and contains the response data. It includes both the response data
/// and the current authentication token.
class HttpSuccess<T> extends HttpState {
  /// The successful response containing typed data.
  final BaseResponse<T> response;

  /// Creates an HttpSuccess state with response data and current token.
  const HttpSuccess(this.response, {super.token});
}

/// State representing an HTTP request failure or error.
///
/// This state is emitted when an HTTP request fails due to various
/// reasons such as network issues, server errors, authentication
/// failures, or other problems during the request lifecycle.
class HttpError extends HttpState {
  /// Human-readable error message describing what went wrong.
  final String message;

  /// Creates an HttpError state with error message and current token.
  const HttpError(this.message, {super.token});
}

/// Abstract base class for all HTTP client states.
///
/// This class defines the common structure for all states in the HttpBloc,
/// ensuring every state can carry an authentication token for proper
/// state persistence and token management.
abstract class HttpState extends Equatable {
  /// The current authentication token.
  final Token? token;

  /// Creates an HttpState with an optional authentication token.
  const HttpState({this.token});

  /// Defines equality comparison based on token value.
  @override
  List<Object?> get props => [token];
}
