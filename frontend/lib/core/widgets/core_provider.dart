import 'package:flutter/material.dart'
    show StatelessWidget, Widget, BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart' show MultiBlocProvider;
import 'package:frontend/core/blocs/local_storage/local_storage.bloc.dart'
    show LocalStorageBloc;
import 'package:frontend/core/layered_context.dart' show LayeredContext;

class CoreProvider extends StatelessWidget {
  final Widget child;
  const CoreProvider({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    LayeredContext.core = context;
    return MultiBlocProvider(
      providers: [LocalStorageBloc.provide],
      child: child,
    );
  }
}
