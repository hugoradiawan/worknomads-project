import 'package:flutter/material.dart'
    show StatelessWidget, Widget;
import 'package:flutter/widgets.dart' show Builder;
import 'package:flutter_bloc/flutter_bloc.dart' show MultiBlocProvider;
import 'package:frontend/core/blocs/http_client/http_client.bloc.dart';
import 'package:frontend/core/blocs/local_storage/local_storage.bloc.dart'
    show LocalStorageBloc;
import 'package:frontend/core/layered_context.dart' show LayeredContext;

class CoreProvider extends StatelessWidget {
  final Widget child;
  const CoreProvider({super.key, required this.child});
  @override
  Widget build(_) => MultiBlocProvider(
    providers: [LocalStorageBloc.provide, HttpBloc.provide],
    child: Builder(
      builder: (context) {
        LayeredContext.core = context;
        return child;
      },
    ),
  );
}
