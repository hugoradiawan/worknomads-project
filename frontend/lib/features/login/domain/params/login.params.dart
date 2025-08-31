import 'package:frontend/core/typedef.dart' show Json;
import 'package:frontend/core/usecase.dart' show Params;

class LoginParams extends Params {
  final String? email;
  final String? password;

  LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];

  Json toJson() => {'email': email, 'password': password};
}
