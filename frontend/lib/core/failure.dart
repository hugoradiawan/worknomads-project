import 'package:equatable/equatable.dart' show Equatable;
import 'package:frontend/core/base_response.dart' show BaseResponse;

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final BaseResponse? baseResponse;
  const ServerFailure(this.baseResponse);

  @override
  List<Object?> get props => [baseResponse];
}
