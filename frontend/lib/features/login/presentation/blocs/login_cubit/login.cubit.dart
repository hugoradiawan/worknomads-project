import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:frontend/features/login/domain/params/login.params.dart'
    show LoginParams;
import 'package:frontend/features/login/presentation/blocs/login_cubit/login.state.dart'
    show LoginLoading, LoginInitial, LoginState;
import 'package:frontend/shared/blocs/user.bloc.dart' show UserBloc;
import 'package:frontend/shared/blocs/user.event.dart' show LoginFetch;

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial()) {
    void emitLatest() {
      emit(
        LoginInitial(
          email: state.emailOrUsernameController.text,
          password: state.passwordController.text,
          emailController: state.emailOrUsernameController,
          passwordController: state.passwordController,
        ),
      );
    }

    state.emailOrUsernameController.addListener(emitLatest);
    state.passwordController.addListener(emitLatest);
  }

  void login() async {
    emit(
      LoginLoading(
        email: state.email,
        password: state.password,
        emailController: state.emailOrUsernameController,
        passwordController: state.passwordController,
      ),
    );
    UserBloc.i.add(
      LoginFetch(LoginParams(email: state.email, password: state.password)),
    );
  }

  @override
  Future<void> close() {
    state.emailOrUsernameController.dispose();
    state.passwordController.dispose();
    return super.close();
  }
}
