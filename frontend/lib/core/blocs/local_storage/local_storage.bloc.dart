import 'dart:convert' show json;

import 'package:bloc_concurrency/bloc_concurrency.dart'
    show concurrent, droppable;
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc, BlocProvider;
import 'package:frontend/core/blocs/local_storage/events/local_storage.event.dart'
    show LocalStorageEvent, LocalStorageInit;
import 'package:frontend/core/blocs/local_storage/events/local_users.event.dart' show SaveUser, FetchUser;
import 'package:frontend/core/blocs/local_storage/states/local_storage.state.dart'
    show
        LocalStorageState,
        LocalStorageInitial,
        LocalStorageReady,
        LocalStorageSettingUp;
import 'package:frontend/core/blocs/local_storage/states/local_user.state.dart'
    show LocalStorageUserSaved, LoadingUser, UserFetched;
import 'package:frontend/core/layered_context.dart' show LayeredContext;
import 'package:frontend/shared/data/model.dart' show UserModel;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesWithCache, SharedPreferencesWithCacheOptions;

class LocalStorageBloc extends Bloc<LocalStorageEvent, LocalStorageState> {
  late final SharedPreferencesWithCache prefs;

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

  LocalStorageBloc() : super(LocalStorageInitial()) {
    add(LocalStorageInit());
    on<SaveUser>((event, emit) async {
      await waitForInitialization();
      await prefs.setString('user', json.encode(event.user.toJson()));
      emit(LocalStorageUserSaved());
    }, transformer: concurrent());
    on<FetchUser>((event, emit) async {
      emit(LoadingUser());
      await waitForInitialization();
      final String? local = prefs.getString('user');
      if (local == null) return emit(UserFetched(null));
      emit(UserFetched(UserModel.fromJson(json.decode(local))));
    }, transformer: concurrent());
    on<LocalStorageInit>((event, emit) async {
      emit(LocalStorageSettingUp());
      prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      emit(LocalStorageReady());
    }, transformer: droppable());
  }

  Future<void> waitForInitialization() async {
    while (LayeredContext.core == null) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    while (state is! LocalStorageReady) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
}
