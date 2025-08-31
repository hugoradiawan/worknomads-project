import 'package:frontend/shared/data/model.dart' show UserModel;

abstract class UserEvent {}

class OnLocalFetchUserData extends UserEvent {
  final UserModel? user;

  OnLocalFetchUserData(this.user);
}

class OnRemoteFetchUserData extends UserEvent {
  final UserModel? user;

  OnRemoteFetchUserData(this.user);
}

class OnRemoteLoadingUserData extends UserEvent {}