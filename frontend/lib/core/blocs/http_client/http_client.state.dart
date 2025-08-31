import 'package:frontend/core/usecase.dart' show BaseResponse;

class HttpInitial extends HttpState {}

class HttpSettingUp extends HttpState {}

class HttpIsReady extends HttpState {}

class HttpLoading extends HttpState {}

class HttpLoaded extends HttpState {}

class HttpSuccess<T> extends HttpState {
  final BaseResponse<T> response;

  HttpSuccess(this.response);
}

class HttpError extends HttpState {
  final String message;

  HttpError(this.message);
}

abstract class HttpState {}