/// Abstract base class for all local storage-related states.
///
/// This class serves as the foundation for all states in the local storage
/// BLoC system, providing a common structure for managing persistent data
/// operations, cache management, and offline storage functionality.
class LocalStorageState {}

/// Initial state of the local storage system before any setup operations.
///
/// This state represents the starting point of the local storage lifecycle,
/// typically when the application first launches or when the storage system
/// needs to be reinitialized. No storage operations are available in this state.
class LocalStorageInitial extends LocalStorageState {}

/// State indicating the local storage system is being configured and initialized.
///
/// This transient state occurs during the setup and configuration of all
/// local storage systems, including databases, caches, file systems, and
/// other persistence mechanisms. The system is not ready for operations.
class LocalStorageSettingUp extends LocalStorageState {}

/// State indicating the local storage system is fully configured and operational.
///
/// This state represents that all local storage systems have been successfully
/// initialized and are ready to handle data operations. All persistence
/// mechanisms are active and available for use throughout the application.
class LocalStorageReady extends LocalStorageState {}
