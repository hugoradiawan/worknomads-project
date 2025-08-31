import 'package:equatable/equatable.dart' show Equatable;

abstract class UseCase<T, P extends Params> {
  Stream<({Failure? fail, BaseResponse<T> ok})> call(P params);
}

abstract class Params extends Equatable {}

class BaseResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;
  final String? errorCode;
  final String? serverId;
  final bool success;

  BaseResponse({
    this.data,
    this.message,
    this.statusCode,
    this.errorCode,
    this.serverId,
    required this.success,
  });
}

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
