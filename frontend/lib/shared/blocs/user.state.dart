import 'package:equatable/equatable.dart' show Equatable;
import 'package:frontend/shared/data/user.model.dart' show UserModel;
import 'package:frontend/shared/domain/entities/token.dart' show Token;

class UserInitial extends UserState {
  const UserInitial() : super(user: null);
}

abstract class UserState extends Equatable {
  final UserModel? user;
  final Token? token;

  const UserState({this.user, this.token});

  @override
  List<Object?> get props => [user, token];
}

class LoginFetched extends UserState {
  const LoginFetched(UserModel? user, Token? token)
    : super(user: user, token: token);
}

class LoginFailed extends UserState {
  const LoginFailed() : super(user: null, token: null);
}

class RegisterFetched extends UserState {
  const RegisterFetched() : super(user: null, token: null);
}

class RegisterFailed extends UserState {
  const RegisterFailed() : super(user: null, token: null);
}
