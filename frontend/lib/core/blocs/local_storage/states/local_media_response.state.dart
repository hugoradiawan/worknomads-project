import 'package:frontend/core/blocs/local_storage/states/local_storage.state.dart' show LocalStorageState;
import 'package:frontend/core/typedef.dart' show Json;

class LocalMediaResponseLoading extends LocalStorageState {}

class LocalMediaResponseLoaded extends LocalStorageState {
  final Json data;

  LocalMediaResponseLoaded({required this.data});
}

class LocalMediaResponseNotFound extends LocalStorageState {}

class LocalMediaResponseSaved extends LocalStorageState {}