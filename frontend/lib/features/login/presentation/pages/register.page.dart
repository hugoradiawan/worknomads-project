import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Scaffold,
        Widget,
        Text,
        EdgeInsets,
        InputDecoration,
        SizedBox,
        AppBar,
        MainAxisAlignment,
        OutlineInputBorder,
        TextField,
        ElevatedButton,
        Column,
        Padding;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider, BlocBuilder;
import 'package:frontend/features/login/presentation/blocs/register_cubit/register.cubit.dart'
    show RegisterCubit;
import 'package:frontend/features/login/presentation/blocs/register_cubit/register.state.dart'
    show RegisterState;

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(_) => Scaffold(
    appBar: AppBar(title: const Text('Register')),
    body: BlocProvider<RegisterCubit>(
      create: (_) => RegisterCubit(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  final cubit = BlocProvider.of<RegisterCubit>(context);
                  return TextField(
                    controller: state.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      errorText:
                          cubit.isEmailValidState ||
                              state.emailController.text.isEmpty
                          ? null
                          : 'Invalid email',
                    ),
                  );
                },
              ),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  final cubit = BlocProvider.of<RegisterCubit>(context);
                  return TextField(
                    controller: state.usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: const OutlineInputBorder(),
                      errorText:
                          cubit.isUsernameValidState ||
                              state.usernameController.text.isEmpty
                          ? null
                          : 'Username must be at least 5 characters with no spaces',
                    ),
                  );
                },
              ),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  final cubit = BlocProvider.of<RegisterCubit>(context);
                  return TextField(
                    controller: state.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      errorText:
                          cubit.isPasswordValidState ||
                              state.passwordController.text.isEmpty
                          ? null
                          : 'Password must be at least 8 characters, no spaces, and contain letters and numbers',
                    ),
                    obscureText: true,
                  );
                },
              ),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  final cubit = BlocProvider.of<RegisterCubit>(context);
                  return TextField(
                    controller: state.confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: const OutlineInputBorder(),
                      errorText:
                          cubit.isConfirmPasswordValidState ||
                              state.confirmPasswordController.text.isEmpty
                          ? null
                          : 'Passwords do not match',
                    ),
                    obscureText: true,
                  );
                },
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, _) => ElevatedButton(
                    onPressed: BlocProvider.of<RegisterCubit>(context).register,
                    child: const Text('Register'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
