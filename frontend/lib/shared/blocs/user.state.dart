import 'package:equatable/equatable.dart' show Equatable;
import 'package:frontend/shared/data/model.dart' show UserModel;

class UserInitial extends UserState {
  const UserInitial() : super(user: null);
}

class UserState extends Equatable {
  final UserModel? user;

  const UserState({this.user});

  @override
  List<Object?> get props => [user];

  UserState copyWith({UserModel? user}) => UserState(user: user ?? this.user);
}