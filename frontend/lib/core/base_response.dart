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