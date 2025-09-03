import 'dart:async' show Stream, StreamSubscription;

import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:frontend/features/home/presentation/pages/home.page.dart'
    show HomePage;
import 'package:frontend/features/login/presentation/pages/login.page.dart'
    show LoginPage;
import 'package:frontend/features/login/presentation/pages/register.page.dart' show RegisterPage;
import 'package:frontend/shared/blocs/user.bloc.dart' show UserBloc;
import 'package:go_router/go_router.dart';

class AppRouter {
  final UserBloc userBloc;
  late final GoRouter router = GoRouter(
    refreshListenable: _GoRouterRefreshStream(userBloc.stream),
    routes: [
      GoRoute(path: '/', builder: (_, _) => const HomePage()),
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
    ],
    redirect: (context, state) {
      final bool hasToken = userBloc.state.token != null;
      final String currentLocation = state.uri.toString();

      final bool isLoggingIn = currentLocation == '/login';
      final bool isRegistering = currentLocation == '/register';

      if (!hasToken && !isLoggingIn && !isRegistering) {
        return '/login';
      }
      if (hasToken && (isLoggingIn || isRegistering)) {
        return '/';
      }
      return null;
    },
  );

  AppRouter(this.userBloc);
}

class _GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
