import 'package:frontend/core/blocs/local_storage/states/local_storage.state.dart'
    show LocalStorageState;
import 'package:frontend/shared/data/model.dart' show UserModel;

class LocalStorageUserSaved extends LocalStorageState {}

class UserFetched extends LocalStorageState {
  final UserModel? user;

  UserFetched(this.user);
}

class LoadingUser extends LocalStorageState {}
