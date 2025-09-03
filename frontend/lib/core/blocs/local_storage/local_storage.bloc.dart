import 'dart:convert' show json;

import 'package:bloc_concurrency/bloc_concurrency.dart'
    show concurrent, droppable;
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc, BlocProvider;
import 'package:frontend/core/blocs/local_storage/events/local_storage.event.dart'
    show LocalStorageEvent, LocalStorageInit;
import 'package:frontend/core/blocs/local_storage/events/local_users.event.dart'
    show
        LocalRefreshResponseFetch;
import 'package:frontend/core/blocs/local_storage/states/local_login_response.state.dart'
    show
        LocalRefreshResponseLoading,
        LocalRefreshResponseFetched;
import 'package:frontend/core/blocs/local_storage/states/local_storage.state.dart'
    show
        LocalStorageState,
        LocalStorageInitial,
        LocalStorageReady,
        LocalStorageSettingUp;
import 'package:frontend/core/layered_context.dart' show LayeredContext;
import 'package:frontend/features/login/domain/responses/refresh.response.dart'
    show RefreshResponse;
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
    on<LocalRefreshResponseFetch>((event, emit) async {
      emit(LocalRefreshResponseLoading());
      final String? local = prefs.getString('refreshResponse');
      if (local == null) return emit(LocalRefreshResponseFetched(null));
      final RefreshResponse? response = RefreshResponse.fromJson(
        json.decode(local),
      );
      emit(LocalRefreshResponseFetched(response));
    }, transformer: concurrent());
    on<LocalStorageInit>((event, emit) async {
      emit(LocalStorageSettingUp());
      prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      emit(LocalStorageReady());
    }, transformer: droppable());
    add(LocalStorageInit());
  }
}
