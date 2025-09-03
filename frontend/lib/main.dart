import 'package:flutter/material.dart';
import 'package:frontend/app.dart' show MyApp;
import 'package:frontend/core/blocs/app_bloc_observer.dart';
import 'package:frontend/core/widgets/core_provider.dart' show CoreProvider;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
  Bloc.observer = AppBlocObserver();
  runApp(CoreProvider(child: const MyApp()));
}
