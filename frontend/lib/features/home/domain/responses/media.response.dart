import 'package:frontend/core/typedef.dart' show Json;
import 'package:frontend/core/usecase.dart' show BaseResponse;
import 'package:frontend/features/home/data/models/media.model.dart' show MediaModel;

class MediaResponse extends BaseResponse<List<MediaModel>> {
  final List<MediaModel>? media;
  MediaResponse({this.media, required super.success});

  factory MediaResponse.fromJson(Json json) {
    return MediaResponse(
      media: (json['data'] as List<dynamic>?)
          ?.map((item) => MediaModel.fromJson(item))
          .toList(),
      success: json['success'] ?? false,
    );
  }

  @override
  List<MediaModel>? get data => media;

  Json toJson() => {
    'data': media?.map((item) => item.toJson()).toList(),
    'success': success,
  };
}
