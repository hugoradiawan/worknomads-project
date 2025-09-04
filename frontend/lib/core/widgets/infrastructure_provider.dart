import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget, Builder;
import 'package:flutter_bloc/flutter_bloc.dart'
    show MultiBlocProvider, BlocProvider, ReadContext;
import 'package:frontend/core/layered_context.dart' show LayeredContext;
import 'package:frontend/core/router/app_router.dart' show AppRouter;
import 'package:frontend/core/router/router_cubit.dart' show RouterCubit;
import 'package:frontend/shared/blocs/user.bloc.dart';

/// Infrastructure provider widget that manages user authentication and routing BLoCs.
///
/// The `InfrastructureProvider` widget serves as the infrastructure layer of the
/// application's state management architecture. It provides BLoCs responsible for
/// user authentication and navigation, building upon the core services provided
/// by CoreProvider.
class InfrastructureProvider extends StatelessWidget {
  /// Builder function that receives the BuildContext with infrastructure BLoCs available.
  ///
  /// This function is called with a BuildContext that has access to all
  /// infrastructure BLoCs (UserBloc, RouterCubit) and can be used to build
  /// the application's main widget tree or routing configuration.
  final Widget Function(BuildContext) builder;

  /// Creates an InfrastructureProvider widget with the specified builder function.
  ///
  /// The InfrastructureProvider will set up all infrastructure BLoCs and
  /// call the builder function with a context that has access to these BLoCs.
  const InfrastructureProvider({super.key, required this.builder});

  /// Builds the InfrastructureProvider with all infrastructure BLoCs and routing setup.
  ///
  /// This method creates a MultiBlocProvider that provides infrastructure BLoCs
  /// and integrates authentication with routing. It uses a Builder to establish
  /// the LayeredContext.infrastructure reference and call the builder function.
  @override
  Widget build(_) => MultiBlocProvider(
    // Provide all infrastructure BLoCs needed for app-level functionality
    providers: [
      // User authentication BLoC for login/logout and auth state management
      UserBloc.provide,

      // Router BLoC that integrates with user authentication
      // Creates AppRouter with UserBloc dependency for auth-based routing
      BlocProvider(
        create: (context) =>
            RouterCubit(AppRouter(context.read<UserBloc>()).router),
      ),
    ],

    child: Builder(
      // Builder captures the context after infrastructure BLoCs are established
      builder: (context) {
        // Establish LayeredContext.infrastructure for cross-layer BLoC access
        // This allows other parts of the app to access infrastructure BLoCs
        // without direct dependency injection
        LayeredContext.infrastructure = context;

        // Call the provided builder function with the enriched context
        // Context now has access to UserBloc, RouterCubit, and core BLoCs
        return builder(context);
      },
    ),
  );
}
