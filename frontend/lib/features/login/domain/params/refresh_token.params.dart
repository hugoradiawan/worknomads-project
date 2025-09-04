import 'package:frontend/core/params.dart' show Params;
import 'package:frontend/core/typedef.dart' show Json;

class RefreshTokenParams extends Params {
  final String refreshToken;

  RefreshTokenParams({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];

  Json toJson() => {'refresh': refreshToken};
}
