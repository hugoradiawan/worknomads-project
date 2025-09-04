import 'package:bloc_concurrency/bloc_concurrency.dart' show concurrent;
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:frontend/core/blocs/http_client/auth_interceptor.dart';
import 'package:frontend/core/blocs/http_client/http_client.event.dart'
    show
        HttpEvent,
        HttpSetup,
        HttpResponseEvent,
        HttpErrorEvent,
        HttpReady,
        HttpSetToken;
import 'package:frontend/core/blocs/http_client/http_client.state.dart'
    show
        HttpError,
        HttpInitial,
        HttpLoaded,
        HttpSettingUp,
        HttpState,
        HttpSuccess;
import 'package:frontend/core/layered_context.dart';
import 'package:frontend/core/typedef.dart' show Json;
import 'package:frontend/shared/domain/entities/token.dart' show Token;
import 'package:hydrated_bloc/hydrated_bloc.dart' show HydratedBloc;

/// BLoC that manages HTTP client configuration and authentication state.
///
/// This BLoC serves as the central HTTP client manager for the application,
/// handling:
/// - Dio HTTP client initialization and configuration
/// - Authentication token persistence and hydration
/// - Request/response event handling
/// - Authentication interceptor integration
class HttpBloc extends HydratedBloc<HttpEvent, HttpState> {
  /// The Dio HTTP client instance used for all API calls.
  /// Configured with base URL and authentication interceptor.
  late final Dio _client;

  /// Creates a new HttpBloc instance and sets up event handlers.
  ///
  /// Initializes the BLoC with HttpInitial state and registers event handlers
  /// for all HTTP-related events. Automatically triggers the setup process
  /// to configure the Dio client.
  HttpBloc() : super(HttpInitial()) {
    // Handle HTTP client setup initiation
    on<HttpSetup>((event, emit) => emit(HttpSettingUp(token: state.token)));

    // Handle successful HTTP responses
    // Uses concurrent transformer to allow multiple requests simultaneously
    on<HttpResponseEvent>((event, emit) {
      emit(HttpSuccess(event.response, token: state.token));
    }, transformer: concurrent());

    // Handle HTTP errors
    on<HttpErrorEvent>((event, emit) {
      emit(HttpError(event.message, token: state.token));
    });

    // Handle HTTP client ready state
    on<HttpReady>((event, emit) => emit(HttpLoaded(token: state.token)));

    // Handle authentication token updates
    on<HttpSetToken>((event, emit) {
      emit(HttpInitial(token: event.token));
    });

    // Trigger the HTTP client setup process
    _setup();
  }

  /// Provides a BlocProvider for the HttpBloc.
  ///
  /// Creates a non-lazy BlocProvider that immediately instantiates the HttpBloc.
  /// This ensures the HTTP client is available as soon as the app starts.
  static BlocProvider<HttpBloc> get provide =>
      BlocProvider(lazy: false, create: (_) => HttpBloc());

  /// Gets the current HttpBloc instance from the widget tree.
  ///
  /// Returns null if the LayeredContext.core is not available or if
  /// the HttpBloc is not found in the widget tree.
  static HttpBloc? get i => LayeredContext.core == null
      ? null
      : BlocProvider.of<HttpBloc>(LayeredContext.core!);

  /// Provides access to the configured Dio HTTP client.
  ///
  /// The client is pre-configured with:
  /// - Base URL for API endpoints
  /// - Authentication interceptor for automatic token handling
  /// - Error handling and token refresh capabilities
  Dio get client => _client;

  /// Sets up the Dio HTTP client with configuration and interceptors.
  Future<void> _setup() async {
    // Emit setup event to indicate configuration is starting
    add(HttpSetup());

    // Create Dio client with base configuration
    _client = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8080/api/', // Android emulator localhost
      ),
    );

    // Add authentication interceptor for automatic token handling
    // This handles adding Bearer tokens and refreshing expired tokens
    _client.interceptors.add(AuthInterceptor(this));

    // Emit ready event to indicate client is configured and ready
    add(HttpReady());
  }

  /// Restores the HttpBloc state from persistent storage.
  ///
  /// This method is called by HydratedBloc when the app starts to restore
  /// the previous state, particularly the authentication token.
  @override
  HttpInitial? fromJson(Json json) =>
      HttpInitial(token: Token.fromJson(json['token']));

  /// Persists the current HttpBloc state to storage.
  ///
  /// This method is called by HydratedBloc whenever the state changes
  /// to save the authentication token for future app launches.
  @override
  Json? toJson(HttpState state) => {'token': state.token?.toJson()};
}
