import 'package:frontend/core/typedef.dart' show Json;

class MediaEntity {
  final int? id;
  final String? fileUrl, mediaType;
  final DateTime? uploadedAt;
  final Json? metadata;

  MediaEntity({
    this.id,
    this.fileUrl,
    this.mediaType,
    this.uploadedAt,
    this.metadata,
  });
}
