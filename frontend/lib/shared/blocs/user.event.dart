import 'package:frontend/features/login/domain/params/login.params.dart'
    show LoginParams;
import 'package:frontend/features/login/domain/params/refresh_token.params.dart' show RefreshTokenParams;
import 'package:frontend/features/login/domain/params/register.params.dart'
    show RegisterParams;

abstract class UserEvent {}

class LoginFetch extends UserEvent {
  final LoginParams params;

  LoginFetch(this.params);
}

class RegisterFetch extends UserEvent {
  final RegisterParams params;

  RegisterFetch(this.params);
}

class RefreshFetch extends UserEvent {
  final RefreshTokenParams params;

  RefreshFetch(this.params);
}