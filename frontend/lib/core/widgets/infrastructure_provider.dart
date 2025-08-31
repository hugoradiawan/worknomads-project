import 'package:flutter/material.dart'
    show StatelessWidget, Widget, BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart' show MultiBlocProvider;
import 'package:frontend/core/layered_context.dart' show LayeredContext;
import 'package:frontend/shared/blocs/user.bloc.dart';

class InfrastructureProvider extends StatelessWidget {
  final Widget child;
  const InfrastructureProvider({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    LayeredContext.infrastructure = context;
    return MultiBlocProvider(providers: [UserBloc.provide], child: child);
  }
}
