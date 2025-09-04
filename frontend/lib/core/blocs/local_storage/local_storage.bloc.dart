import 'dart:convert' show json;

import 'package:bloc_concurrency/bloc_concurrency.dart' show droppable;
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc, BlocProvider;
import 'package:frontend/core/blocs/local_storage/events/local_storage.event.dart'
    show LocalStorageEvent, LocalStorageInit, MediaListFetch, MediaListSave;
import 'package:frontend/core/blocs/local_storage/states/local_media_response.state.dart'
    show
        LocalMediaResponseLoaded,
        LocalMediaResponseNotFound,
        LocalMediaResponseSaved;
import 'package:frontend/core/blocs/local_storage/states/local_storage.state.dart'
    show
        LocalStorageState,
        LocalStorageInitial,
        LocalStorageReady,
        LocalStorageSettingUp;
import 'package:frontend/core/layered_context.dart' show LayeredContext;
import 'package:frontend/shared/blocs/user.bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesWithCache, SharedPreferencesWithCacheOptions;

/// BLoC that manages local storage operations and persistent data management.
///
/// This BLoC serves as the central coordinator for all local storage operations
/// in the application, providing a unified interface for data persistence,
/// caching, and offline storage management.
class LocalStorageBloc extends Bloc<LocalStorageEvent, LocalStorageState> {
  /// Cached SharedPreferences instance for optimized key-value storage.
  late final SharedPreferencesWithCache prefs;

  /// Provides a BlocProvider for the LocalStorageBloc.
  ///
  /// Creates a non-lazy BlocProvider that immediately instantiates the
  /// LocalStorageBloc to ensure storage systems are available as soon
  /// as the app starts. This is critical for app initialization.
  static BlocProvider<LocalStorageBloc> get provide =>
      BlocProvider(lazy: false, create: (_) => LocalStorageBloc());

  static LocalStorageBloc? get i {
    if (LayeredContext.core == null) return null;
    try {
      return BlocProvider.of<LocalStorageBloc>(LayeredContext.core!);
    } catch (_) {
      return null;
    }
  }

  /// Gets the current LocalStorageBloc instance from the widget tree.
  ///
  /// Provides global access to the LocalStorageBloc instance through
  /// the LayeredContext system. Returns null if the context is not
  /// available or if the LocalStorageBloc is not found.
  LocalStorageBloc() : super(LocalStorageInitial()) {
    // Register LocalStorageInit event handler with droppable transformer
    // Droppable prevents multiple simultaneous initialization attempts
    on<LocalStorageInit>((event, emit) async {
      // Transition to setting up state
      emit(LocalStorageSettingUp());

      // Initialize SharedPreferences with optimized caching
      // This creates a cached instance for faster subsequent access
      prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
          // Default cache options provide optimal performance
          // for most use cases without excessive memory usage
        ),
      );

      // Transition to ready state - storage systems are now operational
      emit(LocalStorageReady());
    }, transformer: droppable()); // Droppable prevents redundant initialization
    on<MediaListFetch>((event, emit) async {
      print('1111');
      await _waitForInitialization();
      print('2222');
      final String? local = prefs.getString(
        'media_list${UserBloc.i.state.user?.email ?? ''}',
      );
      if (local != null) {
        emit(LocalMediaResponseLoaded(data: json.decode(local)));
      } else {
        emit(LocalMediaResponseNotFound());
      }
    });
    on<MediaListSave>((event, emit) async {
      await _waitForInitialization();
      await prefs.setString(
        'media_list${UserBloc.i.state.user?.email ?? ''}',
        json.encode(event.data),
      );
      emit(LocalMediaResponseSaved());
    });

    // Automatically trigger initialization on BLoC creation
    // This ensures storage is available as soon as possible
    add(LocalStorageInit());
  }

  Future<void> _waitForInitialization() async {
    while (LayeredContext.core == null) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    while (state is LocalStorageSettingUp) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
}
