import 'package:frontend/core/blocs/local_storage/events/local_storage.event.dart' show LocalStorageEvent;
import 'package:frontend/shared/data/model.dart' show UserModel;

class SaveUser extends LocalStorageEvent {
  final UserModel user;

  SaveUser(this.user);
}

class FetchUser extends LocalStorageEvent {}