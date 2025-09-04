import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:frontend/features/login/domain/params/register.params.dart' show RegisterParams;
import 'package:frontend/features/login/presentation/blocs/register_cubit/register.state.dart'
    show RegisterChange, RegisterLoading, RegisterState, RegisterInitial;
import 'package:frontend/shared/blocs/user.bloc.dart' show UserBloc;
import 'package:frontend/shared/blocs/user.event.dart' show RegisterFetch;
import 'package:frontend/shared/blocs/user.state.dart' show UserState, RegisterFetched, RegisterFailed;
import 'package:go_router/go_router.dart';

class RegisterCubit extends Cubit<RegisterState> {
  StreamSubscription<UserState>? _userStateSubscription;

  bool isConfirmPasswordValid(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  bool _isConfirmPasswordValid = true;
  bool get isConfirmPasswordValidState => _isConfirmPasswordValid;
  bool isPasswordValid(String password) {
    // At least 8 chars, no spaces, contains both letters and numbers
    final hasMinLength = password.length >= 8;
    final hasNoSpaces = !password.contains(' ');
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    return hasMinLength && hasNoSpaces && hasLetter && hasNumber;
  }

  bool _isPasswordValid = true;
  bool get isPasswordValidState => _isPasswordValid;
  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  bool isUsernameValid(String username) {
    // Username must be at least 5 chars and contain no spaces
    return username.length >= 5 && !username.contains(' ');
  }

  bool _isEmailValid = true;
  bool _isUsernameValid = true;
  bool get isEmailValidState => _isEmailValid;
  bool get isUsernameValidState => _isUsernameValid;

  RegisterCubit() : super(RegisterInitial()) {
    void emitLatest() {
      final emailText = state.emailController.text;
      final usernameText = state.usernameController.text;
      final passwordText = state.passwordController.text;
      final confirmPasswordText = state.confirmPasswordController.text;
      _isEmailValid = isEmailValid(emailText);
      _isUsernameValid = isUsernameValid(usernameText);
      _isPasswordValid = isPasswordValid(passwordText);
      _isConfirmPasswordValid = isConfirmPasswordValid(passwordText, confirmPasswordText);
      emit(
        RegisterChange(
          email: emailText,
          password: passwordText,
          username: usernameText,
          confirmPassword: confirmPasswordText,
          emailController: state.emailController,
          passwordController: state.passwordController,
          usernameController: state.usernameController,
          confirmPasswordController: state.confirmPasswordController,
        ),
      );
    }
    state.emailController.addListener(emitLatest);
    state.passwordController.addListener(emitLatest);
    state.usernameController.addListener(emitLatest);
    state.confirmPasswordController.addListener(emitLatest);
  }

  void register(BuildContext context) async {
    final email = state.emailController.text;
    final username = state.usernameController.text;
    final password = state.passwordController.text;
    final confirmPassword = state.confirmPasswordController.text;
    final validEmail = isEmailValid(email);
    final validUsername = isUsernameValid(username);
    final validPassword = isPasswordValid(password);
    final validConfirmPassword = isConfirmPasswordValid(password, confirmPassword);

    if (!validEmail || !validUsername || !validPassword || !validConfirmPassword) {
      return;
    }
    emit(
      RegisterLoading(
        email: email,
        password: password,
        username: username,
        confirmPassword: confirmPassword,
        emailController: state.emailController,
        passwordController: state.passwordController,
        usernameController: state.usernameController,
        confirmPasswordController: state.confirmPasswordController,
      ),
    );

    _userStateSubscription?.cancel();
    _userStateSubscription = UserBloc.i.stream.listen((userState) {
      if (userState is RegisterFetched) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (context.mounted) {
              context.go('/login');
            }
          });
        _userStateSubscription?.cancel();
      } else if (userState is RegisterFailed) {
        _userStateSubscription?.cancel();
      }
    });

    UserBloc.i.add(
      RegisterFetch(
        RegisterParams(
          email: email,
          password: password,
          username: username,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _userStateSubscription?.cancel();
    state.emailController.dispose();
    state.passwordController.dispose();
    state.usernameController.dispose();
    state.confirmPasswordController.dispose();
    return super.close();
  }
}
