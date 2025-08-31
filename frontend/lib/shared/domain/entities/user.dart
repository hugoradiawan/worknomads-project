import 'package:equatable/equatable.dart' show Equatable;

class UserEntity extends Equatable {
  final String? id, email, username;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
  });

  @override
  List<Object?> get props => [id, email, username];
}
