part of 'app.bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final UserModel? user;
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}