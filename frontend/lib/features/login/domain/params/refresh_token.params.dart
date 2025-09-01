import 'package:frontend/core/typedef.dart' show Json;
import 'package:frontend/core/usecase.dart' show Params;

class RefreshTokenParams extends Params {
  final String refreshToken;

  RefreshTokenParams({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];

  Json toJson() => {'refresh': refreshToken};
}
