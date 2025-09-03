import 'package:frontend/core/typedef.dart' show Json;

class MediaEntity {
  final String? userId, fileUrl, mediaType;
  final DateTime? uploadedAt;
  final Json? metadata;

  MediaEntity({
    this.userId,
    this.fileUrl,
    this.mediaType,
    this.uploadedAt,
    this.metadata,
  });
}
