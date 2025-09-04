import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:go_router/go_router.dart' show GoRouter;

/// A BLoC Cubit that manages the GoRouter instance as application state.
///
/// The `RouterCubit` provides a state management wrapper around the GoRouter
/// instance, allowing the router to be managed and accessed through the BLoC
/// pattern. This enables consistent state management across the application
/// and provides a centralized way to access routing functionality.
class RouterCubit extends Cubit<GoRouter> {
  /// Creates a RouterCubit with the provided GoRouter instance.
  ///
  /// This constructor initializes the cubit with a GoRouter instance that
  /// serves as the application's routing configuration. The router is
  /// typically created by AppRouter with all necessary route definitions,
  /// authentication logic, and reactive capabilities.
  RouterCubit(super.router);
}
