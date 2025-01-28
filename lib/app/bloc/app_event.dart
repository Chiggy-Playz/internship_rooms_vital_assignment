part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final UserModel? user;
  
  @override
  List<Object?> get props => [user];
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}