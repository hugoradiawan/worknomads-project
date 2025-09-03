import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocObserver, BlocBase, Change, Bloc;

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('onEvent -- ${bloc.runtimeType}, event: $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('onChange -- ${bloc.runtimeType}, change: $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('onError -- ${bloc.runtimeType}, error: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    debugPrint('onClose -- ${bloc.runtimeType}');
  }
}
