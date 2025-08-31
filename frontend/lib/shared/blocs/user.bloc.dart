import 'package:flutter_bloc/flutter_bloc.dart' show Bloc, BlocProvider;
import 'package:frontend/core/layered_context.dart' show LayeredContext;
import 'package:frontend/core/usecase.dart' show Failure, BaseResponse;
import 'package:frontend/features/login/domain/responses/login.response.dart'
    show LoginResponse;
import 'package:frontend/features/login/domain/usecases/login.usecase.dart';
import 'package:frontend/features/login/domain/usecases/register.usecase.dart'
    show RegisterUseCase;
import 'package:frontend/shared/blocs/user.event.dart'
    show UserEvent, LoginFetch, RegisterFetch;
import 'package:frontend/shared/blocs/user.state.dart'
    show
        UserState,
        UserInitial,
        LoginFetched,
        LoginFailed,
        RegisterFetched,
        RegisterFailed;

class UserBloc extends Bloc<UserEvent, UserState> {
  Stream<({Failure? fail, BaseResponse<LoginResponse> ok})>? _loginStream;

  static UserBloc get i {
    return BlocProvider.of<UserBloc>(LayeredContext.infrastructure!);
  }

  static BlocProvider<UserBloc> get provide =>
      BlocProvider(lazy: false, create: (_) => UserBloc._internal());

  UserBloc._internal() : super(const UserInitial()) {
    on<LoginFetch>((event, emit) async {
      await for (final result in LoginUseCase().call(event.params)) {
        if (result.fail == null &&
            result.ok.success &&
            result.ok.data != null) {
          emit(LoginFetched(result.ok.data?.user, result.ok.data?.token));
        } else {
          emit(const LoginFailed());
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
  }

  @override
  Future<void> close() {
    _loginStream?.drain();
    _loginStream = null;
    return super.close();
  }
}
