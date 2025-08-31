import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:frontend/features/login/domain/params/login.params.dart'
    show LoginParams;
import 'package:frontend/features/login/presentation/blocs/login.state.dart'
    show LoginLoading, LoginInitial, LoginState;
import 'package:frontend/shared/blocs/user.bloc.dart' show UserBloc;
import 'package:frontend/shared/blocs/user.event.dart' show LoginFetch;

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial()) {
    state.emailOrUsernameController.addListener(() {
      final text = state.emailOrUsernameController.text;
      final isEmail = text.contains('@');
      emit(
        LoginInitial(
          email: isEmail ? text : null,
          password: state.password,
          emailController: state.emailOrUsernameController,
          passwordController: state.passwordController,
        ),
      );
    });
    state.passwordController.addListener(
      () => emit(
        LoginInitial(
          email: state.email,
          password: state.passwordController.text,
          emailController: state.emailOrUsernameController,
          passwordController: state.passwordController,
        ),
      ),
    );
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
