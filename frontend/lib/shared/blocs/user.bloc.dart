import 'package:flutter_bloc/flutter_bloc.dart' show Bloc, BlocProvider;
import 'package:frontend/shared/blocs/user.event.dart'
    show UserEvent, OnLocalFetchUserData, OnRemoteFetchUserData;
import 'package:frontend/shared/blocs/user.state.dart'
    show UserState, UserInitial;

class UserBloc extends Bloc<UserEvent, UserState> {
  static BlocProvider<UserBloc> get provide =>
      BlocProvider(create: (_) => UserBloc());

  UserBloc() : super(const UserInitial()) {
    on<OnLocalFetchUserData>(
      (event, emit) => emit(state.copyWith(user: event.user)),
    );
    on<OnRemoteFetchUserData>(
      (event, emit) => emit(state.copyWith(user: event.user)),
    );
  }
}
