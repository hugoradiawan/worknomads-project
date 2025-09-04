import 'package:equatable/equatable.dart';
import 'package:frontend/core/usecase.dart' show BaseResponse;
import 'package:frontend/shared/domain/entities/token.dart' show Token;

class HttpInitial extends HttpState {
  const HttpInitial({super.token});
}

class HttpSettingUp extends HttpState {
  const HttpSettingUp({super.token});
}

class HttpIsReady extends HttpState {
  const HttpIsReady({super.token});
}

class HttpLoading extends HttpState {
  const HttpLoading({super.token});
}

class HttpLoaded extends HttpState {
  const HttpLoaded({super.token});
}

class HttpSuccess<T> extends HttpState {
  final BaseResponse<T> response;

  const HttpSuccess(this.response, {super.token});
}

class HttpError extends HttpState {
  final String message;

  const HttpError(this.message, {super.token});
}

abstract class HttpState extends Equatable {
  final Token? token;

  const HttpState({this.token});

  @override
  List<Object?> get props => [token];
}
