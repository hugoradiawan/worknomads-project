import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget, Builder;
import 'package:flutter_bloc/flutter_bloc.dart'
    show MultiBlocProvider, BlocProvider, ReadContext;
import 'package:frontend/core/layered_context.dart' show LayeredContext;
import 'package:frontend/core/router/app_router.dart' show AppRouter;
import 'package:frontend/core/router/router_cubit.dart' show RouterCubit;
import 'package:frontend/shared/blocs/user.bloc.dart';

class InfrastructureProvider extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  const InfrastructureProvider({super.key, required this.builder});
  @override
  Widget build(_) => MultiBlocProvider(
        providers: [
          UserBloc.provide,
          BlocProvider(
            create: (context) =>
                RouterCubit(AppRouter(context.read<UserBloc>()).router),
          ),
        ],
        child: Builder(
          builder: (context) {
            LayeredContext.infrastructure = context;
            return builder(context);
          },
        ),
      );
}
