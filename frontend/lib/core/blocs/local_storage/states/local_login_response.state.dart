import 'package:frontend/core/blocs/local_storage/states/local_storage.state.dart'
    show LocalStorageState;
import 'package:frontend/features/login/domain/responses/refresh.response.dart' show RefreshResponse;
import 'package:frontend/features/login/domain/responses/register.response.dart' show RegisterResponse;

class LocalLoginResponseSaved extends LocalStorageState {}

class LocalRegisterResponseSaved extends LocalStorageState {}

class LocalRegisterResponseFetched extends LocalStorageState {
  final RegisterResponse? response;

  LocalRegisterResponseFetched(this.response);
}

class LocalRefreshResponseFetched extends LocalStorageState {
  final RefreshResponse? response;

  LocalRefreshResponseFetched(this.response);
}

class LocalLoginResponseNotFound extends LocalStorageState {}

class LocalLoginResponseLoading extends LocalStorageState {}

class LocalRegisterResponseLoading extends LocalStorageState {}

class LocalRefreshResponseLoading extends LocalStorageState {}

class LocalRegisterResponseNotFound extends LocalStorageState {}

class LocalRefreshResponseNotFound extends LocalStorageState {}
