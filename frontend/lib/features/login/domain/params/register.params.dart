import 'package:frontend/core/usecase.dart' show Params;

class RegisterParams extends Params {
  final String email, username, password;

  RegisterParams({
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [email, username, password];
}
