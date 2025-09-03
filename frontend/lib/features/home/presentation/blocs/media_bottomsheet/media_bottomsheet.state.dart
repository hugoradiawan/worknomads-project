class MediaBottomSheetState {
  const MediaBottomSheetState();
}

class MediaBottomSheetInitial extends MediaBottomSheetState {
  const MediaBottomSheetInitial();
}

class MediaBottomSheetLoading extends MediaBottomSheetState {
  const MediaBottomSheetLoading();
}

class MediaBottomSheetSuccess extends MediaBottomSheetState {
  const MediaBottomSheetSuccess();
}

class MediaBottomSheetFailure extends MediaBottomSheetState {
  final String message;
  const MediaBottomSheetFailure(this.message);
}