import 'package:frontend/core/blocs/local_storage/events/local_storage.event.dart' show LocalStorageEvent;
import 'package:frontend/features/login/domain/responses/login.response.dart' show LoginResponse;

class LocalLoginResponseFetch extends LocalStorageEvent {}

class LocalLoginResponseSave extends LocalStorageEvent {
  final LoginResponse response;

  LocalLoginResponseSave(this.response);
}
