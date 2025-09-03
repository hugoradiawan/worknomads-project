import 'package:equatable/equatable.dart' show Equatable;
import 'package:frontend/shared/data/user.model.dart' show UserModel;
import 'package:frontend/shared/domain/entities/token.dart' show Token;

class UserInitial extends UserState {
  const UserInitial({super.token, super.user});
}

abstract class UserState extends Equatable {
  final UserModel? user;
  final Token? token;

  const UserState({this.user, this.token});

  @override
  List<Object?> get props => [user, token];
}

class LoginFetched extends UserState {
  const LoginFetched({super.user, super.token});
}

class LoginFailed extends UserState {
  const LoginFailed({super.user, super.token});
}

class RegisterFetched extends UserState {
  const RegisterFetched({super.user, super.token});
}

class RegisterFailed extends UserState {
  const RegisterFailed({super.user, super.token});
}

class RefreshFetched extends UserState {
  const RefreshFetched({super.user, super.token});
}

class RefreshFailed extends UserState {
  const RefreshFailed({super.user, super.token});
}
