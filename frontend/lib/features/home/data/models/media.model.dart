import 'package:frontend/core/typedef.dart' show Json;
import 'package:frontend/features/home/domain/entities/media.entity.dart'
    show MediaEntity;

class MediaModel extends MediaEntity {
  MediaModel({
    super.userId,
    super.fileUrl,
    super.mediaType,
    super.uploadedAt,
    super.metadata,
  });

  factory MediaModel.fromJson(Json json) {
    return MediaModel(
      userId: json['user_id'],
      fileUrl: json['file'],
      mediaType: json['media_type'],
      uploadedAt: DateTime.parse(json['uploaded_at']),
      metadata: json['metadata'],
    );
  }

  Json toJson() {
    return {
      'user_id': userId,
      'file': fileUrl,
      'media_type': mediaType,
      'uploaded_at': uploadedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }
}
