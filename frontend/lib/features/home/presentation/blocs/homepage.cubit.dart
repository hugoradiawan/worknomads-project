import 'package:flutter/material.dart' show showModalBottomSheet, BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:frontend/features/home/data/models/media.model.dart'
    show MediaModel;
import 'package:frontend/features/home/domain/params/fetch_media.params.dart'
    show FetchMediaParams;
import 'package:frontend/features/home/domain/usecases/fetch_media.usecase.dart'
    show FetchMediaUseCase;
import 'package:frontend/features/home/presentation/blocs/homepage.state.dart'
    show HomePageState, HomePageInitial, HomePageLoading, HomePageStateData;
import 'package:frontend/features/home/presentation/components/media_bottomsheet.component.dart'
    show MediaBottomSheet;
import 'package:frontend/shared/blocs/user.bloc.dart' show UserBloc;
import 'package:frontend/shared/blocs/user.event.dart' show LogoutUser;

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageInitial(mediaList: [])) {
    loadMedia();
  }

  void logout() => UserBloc.i.add(LogoutUser());

  void showMediaOptions(BuildContext context) async {
    final result = await showModalBottomSheet<MediaModel>(
      context: context,
      builder: (_) => const MediaBottomSheet(),
    );
    if (result == null) return;
    loadMedia();
  }

  void loadMedia() async {
    emit(HomePageLoading(mediaList: state.mediaList));
    await for (final result in FetchMediaUseCase().call(FetchMediaParams())) {
      if (result.fail == null && result.ok.success && result.ok.data != null) {
        final List<MediaModel> mediaList = result.ok.data ?? [];
        emit(HomePageStateData(mediaList: mediaList));
      } else {
        emit(HomePageStateData(mediaList: []));
      }
    }
  }
}
