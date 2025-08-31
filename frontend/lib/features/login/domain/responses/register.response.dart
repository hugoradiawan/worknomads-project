import 'package:frontend/core/typedef.dart' show Json;
import 'package:frontend/core/usecase.dart' show BaseResponse;

class RegisterResponse extends BaseResponse<RegisterResponse> {
  RegisterResponse({required super.success});

  static RegisterResponse? fromJson(Json? json) {
    if (json == null) return null;
    return RegisterResponse(
      success: json['success'] ?? false,
    );
  }

  Json toJson() => {
      'success': success,
    };
}
