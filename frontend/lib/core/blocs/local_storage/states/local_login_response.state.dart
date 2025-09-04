import 'package:frontend/core/blocs/local_storage/states/local_storage.state.dart'
    show LocalStorageState;

class LocalLoginResponseNotFound extends LocalStorageState {}

class LocalLoginResponseLoading extends LocalStorageState {}

class LocalRegisterResponseLoading extends LocalStorageState {}

class LocalRefreshResponseLoading extends LocalStorageState {}

class LocalRegisterResponseNotFound extends LocalStorageState {}

class LocalRefreshResponseNotFound extends LocalStorageState {}
