import 'package:frontend/core/typedef.dart' show Json;
import 'package:frontend/features/home/domain/params/upload_media.params.dart';

class MediaEntity {
  final int? id;
  final String? fileUrl;
  final DateTime? uploadedAt;
  final Json? metadata;
  final MediaUploadType? mediaType;

  MediaEntity({
    this.id,
    this.fileUrl,
    this.mediaType,
    this.uploadedAt,
    this.metadata,
  });
}
