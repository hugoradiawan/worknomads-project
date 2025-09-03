import 'package:flutter/material.dart' show showModalBottomSheet, BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:frontend/features/home/data/models/media.model.dart' show MediaModel;
import 'package:frontend/features/home/presentation/blocs/homepage.state.dart'
    show HomePageState, HomePageInitial;
import 'package:frontend/features/home/presentation/components/media_bottomsheet.component.dart'
    show MediaBottomSheet;
import 'package:frontend/shared/blocs/user.bloc.dart' show UserBloc;
import 'package:frontend/shared/blocs/user.event.dart' show LogoutUser;

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageInitial());

  void logout() => UserBloc.i.add(LogoutUser());

  void showMediaOptions(BuildContext context) async {
    final result = await showModalBottomSheet<MediaModel>(
      context: context,
      builder: (_) => const MediaBottomSheet(),
    );
    if (result == null) return;
    print(result);
  }
}
