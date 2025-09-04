import 'dart:io' show File;

import 'package:frontend/core/params.dart' show Params;
import 'package:frontend/core/typedef.dart' show Json;

enum MediaUploadType {
  image,
  audio;

  static MediaUploadType? fromString(String? value) => switch (value) {
    'image' => MediaUploadType.image,
    'audio' => MediaUploadType.audio,
    _ => null,
  };
}

class UploadMediaParams extends Params {
  final File file;
  final MediaUploadType type;
  final Json metadata;

  UploadMediaParams({
    required this.file,
    required this.type,
    required this.metadata,
  });

  @override
  List<Object?> get props => [file, type, metadata];

  Json toJson() => {
    'file': file.path,
    'media_type': type.name,
    'metadata': metadata,
  };
}
