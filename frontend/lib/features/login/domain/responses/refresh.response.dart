import 'package:frontend/core/typedef.dart';
import 'package:frontend/core/usecase.dart';
import 'package:frontend/shared/domain/entities/token.dart' show Token;

class RefreshResponse extends BaseResponse<RefreshResponse> {
  final Token? token;

  RefreshResponse({this.token, required super.success});

  static RefreshResponse? fromJson(Json? json) {
    if (json == null) return null;
    return RefreshResponse(
      token: Token.fromJson(json['data']?['token']),
      success: json['success'],
    );
  }

  Json toJson() => {'data': token?.toJson(), 'success': success};
}
