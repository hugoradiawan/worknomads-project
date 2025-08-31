import 'package:flutter/widgets.dart' show TextEditingController;

abstract class LoginState {
  final String? email, password;
  final TextEditingController emailOrUsernameController;
  final TextEditingController passwordController;
  LoginState({
    this.email,
    this.password,
    TextEditingController? emailController,
    TextEditingController? passwordController,
  }) : emailOrUsernameController = emailController ?? TextEditingController(),
       passwordController = passwordController ?? TextEditingController();
}

class LoginInitial extends LoginState {
  LoginInitial({
    super.email,
    super.password,
    super.emailController,
    super.passwordController,
  });
}

class LoginLoading extends LoginState {
  LoginLoading({
    super.email,
    super.password,
    super.emailController,
    super.passwordController,
  });
}

class LoginChange extends LoginState {
  LoginChange({
    super.email,
    super.password,
    super.emailController,
    super.passwordController,
  });
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message) : super(email: null, password: null);
}

class LoginSuccess extends LoginState {
  LoginSuccess({
    super.email,
    super.password,
    super.emailController,
    super.passwordController,
  });
}