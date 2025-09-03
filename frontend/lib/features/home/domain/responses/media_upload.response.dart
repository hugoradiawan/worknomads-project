// import 'package:frontend/core/typedef.dart' show Json;
// import 'package:frontend/core/usecase.dart' show BaseResponse;
// import 'package:frontend/features/home/data/models/media.model.dart'
//     show MediaModel;

// class UploadMediaResponse extends BaseResponse<MediaModel> {
//   final MediaModel? media;

//   UploadMediaResponse({this.media, required super.success});

//   static UploadMediaResponse? fromJson(Json? json) {
//     if (json == null || json.isEmpty) return null;
//     print('JSON data: $json');
//     return UploadMediaResponse(
//       media: json['data'] != null ? MediaModel.fromJson(json['data']) : null,
//       success: json['success'] ?? false,
//     );
//   }

//   @override
//   MediaModel? get data => media;

//   Json toJson() => {'data': media?.toJson(), 'success': success};
// }
