import 'package:flutter/material.dart'
    show StatelessWidget, Widget, ColorScheme, Colors, ThemeData, MaterialApp;
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:frontend/core/router/router_cubit.dart';
import 'package:frontend/core/widgets/infrastructure_provider.dart'
    show InfrastructureProvider;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(_) => InfrastructureProvider(
    builder: (context) => MaterialApp.router(
      routerConfig: context.read<RouterCubit>().state,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    ),
  );
}
