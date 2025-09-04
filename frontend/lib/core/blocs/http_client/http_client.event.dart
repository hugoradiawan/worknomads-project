import 'package:frontend/core/base_response.dart' show BaseResponse;
import 'package:frontend/core/params.dart' show Params;
import 'package:frontend/shared/domain/entities/token.dart' show Token;

/// Abstract base class for all HTTP-related events in the HttpBloc.
///
/// This class serves as the parent for all events that can be dispatched
/// to the HttpBloc for managing HTTP client state, requests, and responses.
abstract class HttpEvent {}

/// Event to trigger an HTTP GET request.
///
/// This event is used to initiate GET requests through the HttpBloc.
/// The event carries parameters that define the request configuration,
/// including endpoint, query parameters, and headers.
class GetEvent extends HttpEvent {
  /// The parameters containing request configuration.
  /// Includes endpoint, query parameters, headers, and other request data.
  final Params params;

  /// Creates a new GetEvent with the specified parameters.
  GetEvent(this.params);
}

/// Event to trigger an HTTP POST request.
///
/// This event is used to initiate POST requests through the HttpBloc.
/// The event carries parameters that define the request configuration,
/// including endpoint, request body, headers, and other options.
class PostEvent extends HttpEvent {
  /// The parameters containing request configuration.
  /// Includes endpoint, request body, headers, and other request data.
  final Params params;

  /// Creates a new PostEvent with the specified parameters.
  PostEvent(this.params);
}

/// Event that carries a successful HTTP response.
///
/// This event is dispatched when an HTTP request completes successfully.
/// It contains the response data wrapped in a BaseResponse object and
/// triggers the HttpBloc to emit an HttpSuccess state.
class HttpResponseEvent<T> extends HttpEvent {
  /// The successful response containing data of type T.
  /// Wrapped in BaseResponse which includes success status,
  /// data payload, status code, and optional message.
  final BaseResponse<T> response;

  /// Creates a new HttpResponseEvent with the specified response.
  HttpResponseEvent(this.response);
}

/// Event that carries HTTP error information.
///
/// This event is dispatched when an HTTP request fails or encounters
/// an error. It contains an error message describing what went wrong
/// and triggers the HttpBloc to emit an HttpError state.
///
class HttpErrorEvent extends HttpEvent {
  /// Human-readable error message describing what went wrong.
  /// Should provide enough context for debugging and user feedback.
  final String message;

  /// Creates a new HttpErrorEvent with the specified error message.
  HttpErrorEvent(this.message);
}

/// Event to initiate HTTP client setup process.
///
/// This event triggers the initialization of the Dio HTTP client,
/// including configuration of base URL, interceptors, and other
/// necessary setup steps. It causes the HttpBloc to transition
/// to the HttpSettingUp state.
class HttpSetup extends HttpEvent {}

/// Event to mark HTTP client as ready for use.
///
/// This event is dispatched when the HTTP client setup process
/// is complete and the client is fully configured and ready
/// to handle requests. It causes the HttpBloc to transition
/// to the HttpLoaded state.
class HttpReady extends HttpEvent {}

/// Event to update the authentication token in the HTTP client.
///
/// This event is used to set or update the authentication token
/// that will be used for subsequent HTTP requests. The token is
/// automatically added to request headers by the AuthInterceptor.
class HttpSetToken extends HttpEvent {
  /// The authentication token to be used for HTTP requests.
  final Token? token;

  /// Creates a new HttpSetToken event with the specified token.
  HttpSetToken(this.token);
}
