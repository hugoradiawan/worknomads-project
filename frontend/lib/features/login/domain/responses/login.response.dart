import 'package:frontend/core/typedef.dart';
import 'package:frontend/core/usecase.dart';
import 'package:frontend/shared/data/user.model.dart' show UserModel;
import 'package:frontend/shared/domain/entities/token.dart' show Token;

class LoginResponse extends BaseResponse<LoginResponse> {
  final UserModel? user;
  final Token? token;

  LoginResponse({this.user, this.token, required super.success});

  static LoginResponse? fromJson(Json? json) {
    if (json == null) return null;
    return LoginResponse(
      user: UserModel.fromJson(json['data']?['user']),
      token: Token.fromJson(json['data']?['token']),
      success: json['success'],
    );
  }

  Json toJson() => {
    'data': {'user': user?.toJson(), 'token': token?.toJson()},
    'success': success,
  };
}
