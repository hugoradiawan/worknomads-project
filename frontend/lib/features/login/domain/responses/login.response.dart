import 'package:frontend/core/typedef.dart';
import 'package:frontend/shared/data/user.model.dart' show UserModel;
import 'package:frontend/shared/domain/entities/token.dart' show Token;

class LoginResponse {
  final UserModel? user;
  final Token? token;

  LoginResponse({this.user, this.token});

  static LoginResponse? fromJson(Json? json) {
    if (json == null) return null;
    return LoginResponse(
      user: UserModel.fromJson(json['user']),
      token: Token.fromJson(json['token']),
    );
  }

  Json toJson() => {'user': user?.toJson(), 'token': token?.toJson()};
}
