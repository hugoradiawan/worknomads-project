import 'package:flutter/material.dart' show StatelessWidget, Widget;
import 'package:flutter/widgets.dart' show Builder;
import 'package:flutter_bloc/flutter_bloc.dart' show MultiBlocProvider;
import 'package:frontend/core/blocs/http_client/http_client.bloc.dart';
import 'package:frontend/core/blocs/local_storage/local_storage.bloc.dart'
    show LocalStorageBloc;
import 'package:frontend/core/layered_context.dart' show LayeredContext;

/// Core provider widget that initializes and provides essential BLoCs for the application.
///
/// The `CoreProvider` widget serves as the foundational layer for the application's
/// state management architecture. It provides core BLoCs that are needed throughout
/// the app and establishes the layered context system for cross-layer communication.
class CoreProvider extends StatelessWidget {
  /// The child widget that will have access to all core BLoCs.
  ///
  /// This is typically the next layer in the provider hierarchy or
  /// the main application widget tree that needs access to core services.
  final Widget child;

  /// Creates a CoreProvider widget with the specified child.
  ///
  /// The CoreProvider will wrap the child with all necessary core BLoCs
  /// and establish the layered context system for cross-layer communication.
  ///
  /// **Parameters:**
  /// - [key] - Optional widget key for identification and optimization
  /// - [child] - The widget that will have access to core BLoCs
  const CoreProvider({super.key, required this.child});

  /// Builds the CoreProvider widget with all core BLoCs and layered context setup.
  ///
  /// This method creates a MultiBlocProvider that provides all core BLoCs
  /// and uses a Builder to establish the LayeredContext.core reference.
  @override
  Widget build(_) => MultiBlocProvider(
    // Provide all core BLoCs that are needed throughout the application
    providers: [
      // Local storage BLoC for persistent data management
      LocalStorageBloc.provide,

      // HTTP client BLoC for network operations and API communication
      HttpBloc.provide,
    ],

    child: Builder(
      // Builder captures the context after BLoC providers are established
      builder: (context) {
        // Establish LayeredContext.core for cross-layer BLoC access
        // This allows other parts of the app to access core BLoCs
        // without direct dependency injection
        LayeredContext.core = context;

        // Return the child widget with access to all core BLoCs
        return child;
      },
    ),
  );
}
