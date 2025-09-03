import 'package:bloc_concurrency/bloc_concurrency.dart' show concurrent;
import 'package:dio/dio.dart' show Dio, BaseOptions;
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:frontend/core/blocs/http_client/http_client.event.dart'
    show
        HttpEvent,
        HttpSetup,
        HttpResponseEvent,
        HttpErrorEvent,
        HttpReady,
        HttpSetToken;
import 'package:frontend/core/blocs/http_client/http_client.state.dart'
    show
        HttpError,
        HttpInitial,
        HttpLoaded,
        HttpSettingUp,
        HttpState,
        HttpSuccess;
import 'package:frontend/core/layered_context.dart';
import 'package:frontend/core/typedef.dart' show Json;
import 'package:frontend/shared/domain/entities/token.dart' show Token;
import 'package:hydrated_bloc/hydrated_bloc.dart' show HydratedBloc;

class HttpBloc extends HydratedBloc<HttpEvent, HttpState> {
  late final Dio _client;

  HttpBloc() : super(HttpInitial()) {
    on<HttpSetup>((event, emit) => emit(HttpSettingUp()));
    on<HttpResponseEvent>((event, emit) {
      emit(HttpSuccess(event.response, token: state.token));
    }, transformer: concurrent());
    on<HttpErrorEvent>((event, emit) {
      emit(HttpError(event.message, token: state.token));
    });
    on<HttpReady>((event, emit) => emit(HttpLoaded()));
    on<HttpSetToken>((event, emit) {
      emit(HttpInitial(token: event.token));
    });
    _setup();
  }

  static BlocProvider<HttpBloc> get provide =>
      BlocProvider(lazy: false, create: (_) => HttpBloc());

  static HttpBloc? get i => LayeredContext.core == null
      ? null
      : BlocProvider.of<HttpBloc>(LayeredContext.core!);

  Dio get client => _client;

  Future<void> _setup() async {
    add(HttpSetup());
    _client = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/'));
    add(HttpReady());
  }

  @override
  HttpInitial? fromJson(Json json) =>
      HttpInitial(token: Token.fromJson(json['token']));

  @override
  Json? toJson(HttpState state) => {'token': state.token?.toJson()};
}
