import 'dart:developer' show log;

import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocObserver, BlocBase, Change, Bloc;

/// Global BLoC observer for monitoring and debugging all BLoC activities.
///
/// This observer provides comprehensive logging and monitoring of all BLoC
/// lifecycle events and state changes throughout the application. It serves
/// as a central debugging tool and can be extended for analytics, error
/// reporting, and performance monitoring.
class AppBlocObserver extends BlocObserver {
  /// Called when a BLoC is created and initialized.
  ///
  /// This method is invoked immediately after a BLoC instance is created,
  /// providing visibility into BLoC instantiation throughout the app lifecycle.
  /// Useful for tracking which BLoCs are being created and when.
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('onCreate -- ${bloc.runtimeType}');
  }

  /// Called when an event is dispatched to a BLoC.
  ///
  /// This method is invoked every time an event is added to a BLoC,
  /// providing complete visibility into the event flow and user
  /// interactions throughout the application.
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('onEvent -- ${bloc.runtimeType}, event: $event');
  }

  /// Called when a BLoC's state changes.
  ///
  /// This method is invoked every time a BLoC emits a new state,
  /// providing complete visibility into state transitions and
  /// application state evolution over time.
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange -- ${bloc.runtimeType}, change: $change');
  }

  /// Called when an error occurs in a BLoC.
  ///
  /// This method is invoked when an unhandled error occurs during
  /// BLoC operation, providing critical error information for
  /// debugging, crash reporting, and application stability monitoring.
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError -- ${bloc.runtimeType}, error: $error');
    super.onError(bloc, error, stackTrace);
  }

  /// Called when a BLoC is closed and disposed.
  ///
  /// This method is invoked when a BLoC is being disposed of,
  /// providing visibility into resource cleanup and memory
  /// management throughout the application lifecycle.
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('onClose -- ${bloc.runtimeType}');
  }
}
