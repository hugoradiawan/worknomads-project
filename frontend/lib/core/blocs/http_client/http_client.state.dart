import 'package:frontend/core/usecase.dart' show BaseResponse;
import 'package:frontend/shared/domain/entities/token.dart' show Token;

class HttpInitial extends HttpState {
  HttpInitial({super.token});
}

class HttpSettingUp extends HttpState {
  HttpSettingUp({super.token});
}

class HttpIsReady extends HttpState {
  HttpIsReady({super.token});
}

class HttpLoading extends HttpState {
  HttpLoading({super.token});
}

class HttpLoaded extends HttpState {
  HttpLoaded({super.token});
}

class HttpSuccess<T> extends HttpState {
  final BaseResponse<T> response;

  HttpSuccess(this.response, {super.token});
}

class HttpError extends HttpState {
  final String message;

  HttpError(this.message, {super.token});
}

abstract class HttpState {
  final Token? token;

  const HttpState({this.token});
}