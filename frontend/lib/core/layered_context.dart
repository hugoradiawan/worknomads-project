import 'package:flutter/material.dart' show BuildContext;

/// Global context manager that provides cross-layer access to BLoCs in a layered architecture.
///
/// The `LayeredContext` class implements a static context management system that
/// enables different layers of the application to access BLoCs from other layers
/// without direct dependency injection. This is particularly useful for utility
/// functions, interceptors, and cross-layer communication patterns.
///
/// **Architecture Layers:**
/// The application follows a layered architecture where each layer has specific
/// responsibilities and dependencies:
///
/// 1. **Core Layer** - Foundation services (storage, HTTP client)
/// 2. **Infrastructure Layer** - Authentication, routing, cross-cutting concerns
/// 3. **Feature Layer** - Business logic and UI components
class LayeredContext {
  /// BuildContext for the core layer containing foundational services.
  ///
  /// This context provides access to core BLoCs that are fundamental to
  /// the application's operation:
  /// - **LocalStorageBloc** - Persistent data storage and caching
  /// - **HttpBloc** - Network client configuration and HTTP operations
  static BuildContext?
  core,
  /// BuildContext for the infrastructure layer containing authentication and routing services.
  ///
  /// This context provides access to infrastructure BLoCs that manage
  /// cross-cutting concerns and application-wide functionality:
  /// - **UserBloc** - Authentication state, login/logout, user management
  /// - **RouterCubit** - Navigation management and routing configuration
  infrastructure;
}
