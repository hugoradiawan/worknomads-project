import 'package:frontend/features/login/domain/params/login.params.dart' show LoginParams;

abstract class UserEvent {}

class LoginFetch extends UserEvent {
  final LoginParams params;

  LoginFetch(this.params);
}