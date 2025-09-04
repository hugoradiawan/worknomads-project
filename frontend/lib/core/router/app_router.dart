import 'dart:async' show Stream, StreamSubscription;
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:frontend/features/home/presentation/pages/home.page.dart'
    show HomePage;
import 'package:frontend/features/login/presentation/pages/login.page.dart'
    show LoginPage;
import 'package:frontend/features/login/presentation/pages/register.page.dart'
    show RegisterPage;
import 'package:frontend/shared/blocs/user.bloc.dart' show UserBloc;
import 'package:go_router/go_router.dart';

/// Central application router that manages navigation and authentication-based routing.
///
/// The `AppRouter` class provides a declarative routing solution that automatically
/// handles navigation between authenticated and unauthenticated states. It integrates
/// with the UserBloc to monitor authentication status and redirect users accordingly.
class AppRouter {
  /// The UserBloc instance used for authentication state monitoring.
  ///
  /// This bloc provides the authentication state that drives routing decisions.
  /// The router listens to state changes to automatically redirect users
  /// based on their authentication status.
  final UserBloc userBloc;

  /// The main GoRouter instance that handles all application navigation.
  ///
  /// This router is configured with:
  /// - **Reactive Updates**: Listens to UserBloc changes via `_GoRouterRefreshStream`
  /// - **Route Definitions**: Declarative routes for all app pages
  /// - **Authentication Logic**: Automatic redirects based on auth status
  ///
  /// The router automatically rebuilds and re-evaluates routes whenever
  /// the UserBloc state changes, ensuring immediate navigation updates
  /// when authentication status changes.
  late final GoRouter router = GoRouter(
    // Enable reactive routing based on UserBloc state changes
    refreshListenable: _GoRouterRefreshStream(userBloc.stream),
    routes: [
      GoRoute(path: '/', builder: (_, _) => const HomePage()),
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
    ],

    /// Authentication-based redirect logic.
    ///
    /// This function is called before navigating to any route and determines
    /// if a redirect is necessary based on the user's authentication status
    /// and the requested destination.
    redirect: (context, state) {
      // Check current authentication status from UserBloc
      final bool hasToken = userBloc.state.token != null;

      // Get the current location being accessed
      final String currentLocation = state.uri.toString();

      // Identify the type of route being accessed
      final bool isLoggingIn = currentLocation == '/login';
      final bool isRegistering = currentLocation == '/register';

      // RULE 1: Redirect unauthenticated users to login
      // If user has no token and is trying to access a protected route
      if (!hasToken && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      // RULE 2: Redirect authenticated users away from auth pages
      // If user is authenticated but trying to access login/register
      if (hasToken && (isLoggingIn || isRegistering)) {
        return '/';
      }

      // RULE 3: No redirect needed - proceed to requested route
      return null;
    },
  );

  /// Creates an AppRouter instance with the provided UserBloc.
  ///
  /// The UserBloc is essential for authentication-based routing decisions
  /// and reactive navigation updates. The router will monitor this bloc's
  /// state changes to automatically handle redirects and route access.
  AppRouter(this.userBloc);
}

/// Internal helper class that enables reactive routing based on stream changes.
///
/// `_GoRouterRefreshStream` extends `ChangeNotifier` to provide a bridge between
/// Dart streams (like BLoC state streams) and Flutter's change notification system.
/// This allows GoRouter to automatically refresh and re-evaluate routes when
/// the underlying stream emits new values.
class _GoRouterRefreshStream extends ChangeNotifier {
  /// Stream subscription that listens to the provided stream.
  ///
  /// This subscription is maintained throughout the lifetime of the
  /// refresh stream and is properly cancelled during disposal to
  /// prevent memory leaks.
  late final StreamSubscription<dynamic> _subscription;

  /// Creates a refresh stream that listens to the provided stream.
  ///
  /// This constructor sets up the stream subscription and immediately
  /// notifies listeners to trigger an initial route evaluation.
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    // Notify immediately to trigger initial route evaluation
    notifyListeners();

    // Set up subscription to listen for stream changes
    // Convert to broadcast stream to allow multiple listeners
    _subscription = stream.asBroadcastStream().listen(
      // On any stream event, notify GoRouter to refresh routes
      (dynamic _) => notifyListeners(),
    );
  }

  /// Disposes of the refresh stream and cancels the stream subscription.
  ///
  /// This method ensures proper cleanup of resources when the refresh stream
  /// is no longer needed. It's critical for preventing memory leaks in the
  /// application.
  @override
  void dispose() {
    // Cancel the stream subscription to prevent memory leaks
    _subscription.cancel();

    // Complete the ChangeNotifier disposal process
    super.dispose();
  }
}
