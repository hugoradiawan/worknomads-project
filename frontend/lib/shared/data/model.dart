import 'package:frontend/core/typedef.dart' show Json;
import 'package:frontend/shared/domain/entities/user.dart' show UserEntity;

class UserModel extends UserEntity {
  const UserModel({super.id, super.email, super.username});

  static UserModel? fromJson(Json? json) {
    if (json == null || json.isEmpty) return null;
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
    );
  }

  Json? toJson() => {'id': id, 'email': email, 'username': username};

  UserModel copyWith({String? id, String? email, String? username}) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        username: username ?? this.username,
      );
}
