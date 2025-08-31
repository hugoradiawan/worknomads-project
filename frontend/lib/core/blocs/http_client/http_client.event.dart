import 'package:frontend/core/usecase.dart' show Params, BaseResponse;

abstract class HttpEvent {}

class GetEvent extends HttpEvent {
  final Params params;

  GetEvent(this.params);
}

class PostEvent extends HttpEvent {
  final Params params;

  PostEvent(this.params);
}

class HttpResponseEvent<T> extends HttpEvent {
  final BaseResponse<T> response;

  HttpResponseEvent(this.response);
}

class HttpErrorEvent extends HttpEvent {
  final String message;

  HttpErrorEvent(this.message);
}

class HttpSetup extends HttpEvent {}

class HttpReady extends HttpEvent {}