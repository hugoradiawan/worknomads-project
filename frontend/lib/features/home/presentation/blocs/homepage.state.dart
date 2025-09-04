import 'package:equatable/equatable.dart' show Equatable;
import 'package:frontend/features/home/data/models/media.model.dart' show MediaModel;

abstract class HomePageState extends Equatable {
  const HomePageState({required this.mediaList});
  final List<MediaModel> mediaList;

  @override
  List<Object?> get props => [mediaList];
}

class HomePageInitial extends HomePageState {
  const HomePageInitial({required super.mediaList});
}

class HomePageLoading extends HomePageState {
  const HomePageLoading({required super.mediaList});
}

class HomePageStateData extends HomePageState {
  const HomePageStateData({required super.mediaList});
}