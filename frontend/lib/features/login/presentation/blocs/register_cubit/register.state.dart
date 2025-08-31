import 'package:flutter/material.dart' show TextEditingController;

abstract class RegisterState {
  final String? email, username, password, confirmPassword;
  final TextEditingController emailController,
      usernameController,
      passwordController,
      confirmPasswordController;
  RegisterState({
    this.email,
    this.password,
    this.username,
    this.confirmPassword,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? usernameController,
    TextEditingController? confirmPasswordController,
  }) : emailController = emailController ?? TextEditingController(),
       passwordController = passwordController ?? TextEditingController(),
       usernameController = usernameController ?? TextEditingController(),
       confirmPasswordController =
           confirmPasswordController ?? TextEditingController();
}

class RegisterInitial extends RegisterState {
  RegisterInitial({
    super.email,
    super.password,
    super.username,
    super.confirmPassword,
    super.emailController,
    super.passwordController,
    super.usernameController,
    super.confirmPasswordController,
  });
}

class RegisterLoading extends RegisterState {
  RegisterLoading({
    super.email,
    super.password,
    super.username,
    super.confirmPassword,
    super.emailController,
    super.passwordController,
    super.usernameController,
    super.confirmPasswordController,
  });
}

class RegisterChange extends RegisterState {
  RegisterChange({
    super.email,
    super.password,
    super.username,
    super.confirmPassword,
    super.emailController,
    super.passwordController,
    super.usernameController,
    super.confirmPasswordController,
  });
}

class RegisterFailure extends RegisterState {
  final String? message;

  RegisterFailure({
    this.message,
    super.email,
    super.password,
    super.username,
    super.confirmPassword,
    super.emailController,
    super.passwordController,
    super.usernameController,
    super.confirmPasswordController,
  });
}

class RegisterSuccess extends RegisterState {
  RegisterSuccess({
    super.email,
    super.password,
    super.username,
    super.confirmPassword,
    super.emailController,
    super.passwordController,
    super.usernameController,
    super.confirmPasswordController,
  });
}
