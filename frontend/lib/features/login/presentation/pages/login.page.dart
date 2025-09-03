import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Scaffold,
        Widget,
        Text,
        EdgeInsets,
        TextEditingController,
        InputDecoration,
        SizedBox,
        AppBar,
        MainAxisAlignment,
        OutlineInputBorder,
        TextField,
        ElevatedButton,
        Column,
        Padding,
        TextButton;
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, BlocSelector, BlocBuilder;
import 'package:frontend/features/login/presentation/blocs/login_cubit/login.cubit.dart'
    show LoginCubit;
import 'package:frontend/features/login/presentation/blocs/login_cubit/login.state.dart'
    show LoginState;
import 'package:go_router/go_router.dart' show GoRouter;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(context) => Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: BlocProvider(
          create: (_) => LoginCubit(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocSelector<LoginCubit, LoginState, TextEditingController>(
                  selector: (state) => state.emailOrUsernameController,
                  builder: (_, emailOrUsernameController) => TextField(
                    controller: emailOrUsernameController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BlocSelector<LoginCubit, LoginState, TextEditingController>(
                  selector: (state) => state.passwordController,
                  builder: (_, passwordController) => TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, _) => ElevatedButton(
                      onPressed: BlocProvider.of<LoginCubit>(context).login,
                      child: const Text('Login'),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => GoRouter.of(context).go('/register'),
                  child: const Text('Don\'t have an account? Register'),
                ),
              ],
            ),
          ),
        ),
      );
}
