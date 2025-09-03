import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app.dart' show MyApp;
import 'package:frontend/core/blocs/app_bloc_observer.dart';
import 'package:frontend/core/widgets/core_provider.dart' show CoreProvider;

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(CoreProvider(child: const MyApp()));
}
