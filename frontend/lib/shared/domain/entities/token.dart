import 'package:equatable/equatable.dart' show Equatable;
import 'package:frontend/core/typedef.dart';

class Token extends Equatable {
  final String? accessToken;
  final String? refreshToken;

  const Token({required this.accessToken, required this.refreshToken});

  static Token? fromJson(Json? json) {
    if (json == null) return null;
    return Token(accessToken: json['access'], refreshToken: json['refresh']);
  }

  Json toJson() => {'access': accessToken, 'refresh': refreshToken};

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
