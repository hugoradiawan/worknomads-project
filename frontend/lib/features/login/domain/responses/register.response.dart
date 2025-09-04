import 'package:frontend/core/base_response.dart' show BaseResponse;
import 'package:frontend/core/typedef.dart' show Json;

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
