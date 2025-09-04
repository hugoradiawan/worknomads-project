import 'package:frontend/core/typedef.dart' show Json;

/// Abstract base class for all local storage-related events.
///
/// This class serves as the parent for all events that can be dispatched
/// to local storage BLoCs for managing persistent data operations such as
/// caching, user preferences, offline data storage, and application state.
abstract class LocalStorageEvent {}

/// Event to initialize the local storage system.
///
/// This event triggers the setup and initialization of the local storage
/// infrastructure, including database connections, cache initialization,
/// storage migrations, and any other necessary setup operations.
class LocalStorageInit extends LocalStorageEvent {}

class MediaListSave extends LocalStorageEvent {
  final Json? data;

  MediaListSave({required this.data});
}

class MediaListFetch extends LocalStorageEvent {}