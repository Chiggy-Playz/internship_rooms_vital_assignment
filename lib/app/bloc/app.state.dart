part of 'app.bloc.dart';

class AppState extends Equatable {
  const AppState({
    this.user,
  });

  final UserModel? user;

  @override
  List<Object?> get props => [user];

  AppState copyWith({
    UserModel? user,
  }) {
    return AppState(
      user: user ?? this.user,
    );
  }
}
