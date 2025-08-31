import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart' show Dio, BaseOptions;
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc;
import 'package:frontend/core/blocs/http_client/http_client.event.dart'
    show HttpEvent, HttpSetup, HttpResponseEvent, HttpErrorEvent, HttpReady;
import 'package:frontend/core/usecase.dart'
    show Failure, Params, UseCase, BaseResponse, ServerFailure;
import 'package:frontend/shared/data/model.dart';
import 'package:frontend/shared/domain/entities/token.dart' show Token;

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  final UserLocalDataSource userLocalDataSource;

  UserRepositoryImpl({
    required this.userRemoteDataSource,
    required this.userLocalDataSource,
  });

  @override
  Future<BaseResponse<LoginResponse>> login(LoginParams params) async {
    return await userRemoteDataSource.login(params);
  }
}

abstract class UserRemoteDataSource {
  Future<BaseResponse<LoginResponse>> login(LoginParams params);
}

abstract class UserLocalDataSource {}

class UserLocalDataSourceImpl implements UserLocalDataSource {}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final UserApiService userApiService;

  UserRemoteDataSourceImpl({required this.userApiService});

  @override
  Future<BaseResponse<LoginResponse>> login(LoginParams params) async {
    try {
      final response = await userApiService.login(
        email: params.email,
        username: params.username,
        password: params.password,
      );
      if (response.statusCode == 200) {
        return BaseResponse<LoginResponse>(
          data: LoginResponse.fromJson(response.data),
          message: response.data['message'],
          statusCode: response.statusCode,
          success: true,
        );
      } else {
        return BaseResponse<LoginResponse>(
          data: null,
          message: response.data['message'],
          statusCode: response.statusCode,
          errorCode: response.data['error_code'],
          serverId: response.data['server_id'],
          success: false,
        );
      }
    } catch (e) {
      return BaseResponse<LoginResponse>(
        data: null,
        message: e.toString(),
        statusCode: 500,
        success: false,
      );
    }
  }
}

class HttpBloc extends Bloc<HttpEvent, HttpState> {
  late final Dio _client;

  HttpBloc() : super(HttpInitial()) {
    _setup();
    on<HttpSetup>((event, emit) => emit(HttpSettingUp()));
    on<HttpResponseEvent<LoginResponse>>((event, emit) {
      emit(HttpLoaded(event.response));
    }, transformer: concurrent());
    on<HttpErrorEvent>((event, emit) {
      emit(HttpError(event.message));
    });
  }

  Future<void> _setup() async {
    add(HttpSetup());
    _client = Dio(BaseOptions(baseUrl: 'http://localhost:8000'));
    add(HttpReady());
  }
}

class HttpInitial extends HttpState {}

class HttpSettingUp extends HttpState {}

class HttpIsReady extends HttpState {}

class HttpLoading extends HttpState {}

class HttpLoaded extends HttpState {
  final BaseResponse<LoginResponse> response;

  HttpLoaded(this.response);
}

class HttpError extends HttpState {
  final String message;

  HttpError(this.message);
}

abstract class HttpState {}

abstract class UserRepository {
  Future<BaseResponse<LoginResponse>> login(LoginParams params);
}

class LoginUseCase extends UseCase<LoginResponse, LoginParams> {
  final UserRepository userRepository;

  static LoginUseCase? _instance;

  LoginUseCase._internal({required this.userRepository});

  factory LoginUseCase({required UserRepository userRepository}) {
    _instance ??= LoginUseCase._internal(userRepository: userRepository);
    return _instance!;
  }

  @override
  Future<({Failure? fail, BaseResponse<LoginResponse> ok})> call(
    LoginParams params,
  ) async {
    final BaseResponse<LoginResponse> response = await userRepository.login(
      params,
    );
    if (response.success) {
      return (fail: null, ok: response);
    } else {
      return (fail: ServerFailure(null), ok: response);
    }
  }
}

class LoginResponse {
  final UserModel? user;
  final Token? token;

  LoginResponse({this.user, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    user: UserModel.fromJson(json['user']),
    token: Token.fromJson(json['token']),
  );
}

class LoginParams extends Params {
  final String? email;
  final String? username;
  final String? password;

  LoginParams({
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [email, username, password];
}
