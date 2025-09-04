import 'package:frontend/core/typedef.dart' show Json;
import 'package:frontend/features/home/domain/entities/media.entity.dart'
    show MediaEntity;
import 'package:frontend/features/home/domain/params/upload_media.params.dart';

class MediaModel extends MediaEntity {
  MediaModel({
    super.id,
    super.fileUrl,
    super.mediaType,
    super.uploadedAt,
    super.metadata,
  });

  static MediaModel fromJson(Json json) => MediaModel(
    id: int.tryParse(json['id']?.toString() ?? ''),
    fileUrl: json['file'],
    mediaType: MediaUploadType.fromString(json['media_type']),
    uploadedAt: DateTime.parse(json['uploaded_at']),
    metadata: json['metadata'],
  );

  Json toJson() => {
    'id': id,
    'file': fileUrl,
    'media_type': mediaType,
    'uploaded_at': uploadedAt?.toIso8601String(),
    'metadata': metadata,
  };
}
