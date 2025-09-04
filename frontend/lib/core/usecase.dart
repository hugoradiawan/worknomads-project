import 'package:frontend/core/base_response.dart' show BaseResponse;
import 'package:frontend/core/failure.dart' show Failure;
import 'package:frontend/core/params.dart' show Params;

abstract class UseCase<T, P extends Params> {
  Stream<({Failure? fail, BaseResponse<T> ok})> call(P params);
}
