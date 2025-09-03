import 'dart:io';

import 'package:file_picker/file_picker.dart' show FilePicker, FileType;
import 'package:flutter/material.dart' show BuildContext;
import 'package:frontend/core/usecase.dart' show Failure, BaseResponse;
import 'package:frontend/features/home/data/models/media.model.dart'
    show MediaModel;
import 'package:frontend/features/home/domain/params/upload_media.params.dart'
    show UploadMediaParams, MediaUploadType;
import 'package:frontend/features/home/domain/responses/media_upload.response.dart'
    show UploadMediaResponse;
import 'package:frontend/features/home/domain/usecases/upload_media.usecase.dart'
    show UploadMediaUseCase;
import 'package:frontend/features/home/presentation/blocs/media_bottomsheet/media_bottomsheet.state.dart'
    show
        MediaBottomSheetFailure,
        MediaBottomSheetInitial,
        MediaBottomSheetState,
        MediaBottomSheetLoading,
        MediaBottomSheetSuccess;
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:hydrated_bloc/hydrated_bloc.dart' show Cubit;
import 'package:image_picker/image_picker.dart' show ImageSource, ImagePicker;

class MediaBottomSheetCubit extends Cubit<MediaBottomSheetState> {
  MediaBottomSheetCubit() : super(const MediaBottomSheetInitial());
  final ImagePicker picker = ImagePicker();

  void pickAudio(BuildContext context) async {
    emit(const MediaBottomSheetLoading());
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result?.isSinglePick ?? true) {
      emit(const MediaBottomSheetFailure('No audio file selected'));
      return;
    }
    if (result?.files.first.path == null) {
      emit(const MediaBottomSheetFailure('No audio file path found'));
      return;
    }
    if (!context.mounted) {
      emit(MediaBottomSheetFailure('Failed to upload audio'));
      return;
    }
    _onFile(context, MediaUploadType.audio, File(result!.files.first.path!));
  }

  void takePhoto(BuildContext context) async {
    final result = await picker.pickImage(source: ImageSource.camera);
    if (result?.path == null) return;
    if (!context.mounted) {
      emit(MediaBottomSheetFailure('Failed to upload camera photo'));
      return;
    }
    _onFile(context, MediaUploadType.image, File(result!.path));
  }

  void pickFromGallery(BuildContext context) async {
    final result = await picker.pickImage(source: ImageSource.gallery);
    if (result?.path == null) return;
    if (!context.mounted) {
      emit(MediaBottomSheetFailure('Failed to upload audio'));
      return;
    }
    _onFile(context, MediaUploadType.image, File(result!.path));
  }

  void _onFile(BuildContext context, MediaUploadType type, File file) async {
    final ({Failure? fail, BaseResponse<UploadMediaResponse> ok}) response =
        await UploadMediaUseCase()
            .call(
              UploadMediaParams(
                file: file,
                type: MediaUploadType.audio,
                metadata: {},
              ),
            )
            .first;
    if (response.fail != null) {
      emit(MediaBottomSheetFailure(response.fail.toString()));
      return;
    }
    if (!context.mounted) {
      emit(MediaBottomSheetFailure('Failed to upload media'));
      return;
    }
    emit(const MediaBottomSheetSuccess());
    GoRouter.of(context).pop<MediaModel>(response.ok.data!.media);
  }
}
