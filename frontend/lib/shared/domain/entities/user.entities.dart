import 'package:equatable/equatable.dart' show Equatable;

class UserEntity extends Equatable {
  final int? id;
  final String? email, username;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
  });

  @override
  List<Object?> get props => [id, email, username];
}
