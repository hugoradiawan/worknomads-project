import 'package:frontend/core/blocs/local_storage/states/local_storage.state.dart'
    show LocalStorageState;

/// State indicating that no cached login response was found in local storage.
///
/// This state is emitted when the application attempts to retrieve a cached
/// login response but no valid data exists in the local storage. This typically
/// occurs during:
class LocalLoginResponseNotFound extends LocalStorageState {}

/// State indicating that a login response lookup operation is in progress.
///
/// This state represents an active operation to retrieve or validate cached
/// login response data from local storage. During this state, the application
/// is checking for existing authentication data.
class LocalLoginResponseLoading extends LocalStorageState {}

/// State indicating that a registration response lookup operation is in progress.
///
/// This state represents an active operation to retrieve cached registration
/// response data from local storage. This might be used for registration
/// status tracking or resuming incomplete registration flows.
class LocalRefreshResponseLoading extends LocalStorageState {}

/// State indicating that no cached registration response was found in local storage.
///
/// This state is emitted when the application attempts to retrieve cached
/// registration response data but no valid information exists in local storage.
/// This typically occurs when checking for registration status or metadata.
class LocalRegisterResponseNotFound extends LocalStorageState {}

/// State indicating that no cached refresh token response was found in local storage.
///
/// This state is emitted when the application attempts to retrieve cached
/// refresh token response data but no valid token information exists in
/// local storage. This is critical for authentication flow management.
class LocalRefreshResponseNotFound extends LocalStorageState {}
