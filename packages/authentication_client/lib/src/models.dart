import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    this.name,
    this.email,
  });

  final String id;
  final String? name;
  final String? email;

  static const anonymous = UserModel(id: "");

  bool get isAnonymous => this == anonymous;

  @override
  List<Object?> get props => [id, name, email];
}
