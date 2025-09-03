import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:frontend/core/blocs/http_client/http_client.bloc.dart'
    show HttpBloc;
import 'package:frontend/core/blocs/http_client/http_client.event.dart'
    show HttpSetToken;
import 'package:frontend/core/layered_context.dart' show LayeredContext;
import 'package:frontend/core/typedef.dart' show Json;
import 'package:frontend/core/usecase.dart' show Failure, BaseResponse;
import 'package:frontend/features/login/domain/responses/login.response.dart'
    show LoginResponse;
import 'package:frontend/features/login/domain/usecases/login.usecase.dart';
import 'package:frontend/features/login/domain/usecases/refresh.usecase.dart'
    show RefreshUseCase;
import 'package:frontend/features/login/domain/usecases/register.usecase.dart'
    show RegisterUseCase;
import 'package:frontend/shared/blocs/user.event.dart'
    show UserEvent, LoginFetch, RegisterFetch, RefreshFetch, LogoutUser;
import 'package:frontend/shared/blocs/user.state.dart'
    show
        UserState,
        UserInitial,
        LoginFetched,
        LoginFailed,
        RegisterFetched,
        RegisterFailed,
        RefreshFetched,
        RefreshFailed;
import 'package:frontend/shared/data/user.model.dart' show UserModel;
import 'package:frontend/shared/domain/entities/token.dart' show Token;
import 'package:hydrated_bloc/hydrated_bloc.dart' show HydratedBloc;

class UserBloc extends HydratedBloc<UserEvent, UserState> {
  Stream<({Failure? fail, BaseResponse<LoginResponse> ok})>? _loginStream;

  static UserBloc get i {
    return BlocProvider.of<UserBloc>(LayeredContext.infrastructure!);
  }

  static BlocProvider<UserBloc> get provide =>
      BlocProvider(lazy: false, create: (_) => UserBloc._internal());

  UserBloc._internal() : super(const UserInitial()) {
    on<LoginFetch>((event, emit) async {
      await for (final result in LoginUseCase().call(event.params)) {
        print(result.ok.data?.toJson());
        if (result.fail == null &&
            result.ok.success &&
            result.ok.data != null) {
          final Token? token = result.ok.data?.token;
          if (token != null) {
            HttpBloc.i?.add(HttpSetToken(token));
          }
          emit(LoginFetched(user: result.ok.data?.user, token: token));
        } else {
          emit(LoginFailed(user: state.user, token: state.token));
        }
      }
    });
    on<RegisterFetch>((event, emit) async {
      await for (final result in RegisterUseCase().call(event.params)) {
        if (result.fail == null &&
            result.ok.success &&
            result.ok.data != null) {
          emit(RegisterFetched());
        } else {
          emit(const RegisterFailed());
        }
      }
    });
    on<RefreshFetch>((event, emit) async {
      await for (final result in RefreshUseCase().call(event.params)) {
        if (result.fail == null &&
            result.ok.success &&
            result.ok.data != null) {
          emit(RefreshFetched(token: result.ok.data?.token));
        } else {
          emit(const RefreshFailed());
        }
      }
    });
    on<LogoutUser>((event, emit) {
      HttpBloc.i?.add(HttpSetToken(null));
      emit(const UserInitial());
    });
  }

  @override
  Future<void> close() {
    _loginStream?.drain();
    _loginStream = null;
    return super.close();
  }

  @override
  UserInitial? fromJson(Json json) {
    if (json.isEmpty) return null;
    return UserInitial(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      token: json['token'] != null ? Token.fromJson(json['token']) : null,
    );
  }

  @override
  Json? toJson(UserState state) => {
    'user': state.user?.toJson(),
    'token': state.token?.toJson(),
  };
}
