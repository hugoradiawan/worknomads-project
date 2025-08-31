import 'package:frontend/core/blocs/local_storage/states/local_storage.state.dart'
    show LocalStorageState;
import 'package:frontend/features/login/domain/responses/login.response.dart';

class LocalLoginResponseSaved extends LocalStorageState {}

class LocalLoginResponseFetched extends LocalStorageState {
  final LoginResponse? response;

  LocalLoginResponseFetched(this.response);
}

class LocalLoginResponseNotFound extends LocalStorageState {}

class LocalLoginResponseLoading extends LocalStorageState {}
