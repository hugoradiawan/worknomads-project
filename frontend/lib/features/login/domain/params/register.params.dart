import 'package:frontend/core/params.dart' show Params;
import 'package:frontend/core/typedef.dart' show Json;

class RegisterParams extends Params {
  final String? email, username, password;

  RegisterParams({
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [email, username, password];

  Json toJson() => {
      'email': email,
      'username': username,
      'password': password,
    };
}
