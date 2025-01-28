import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app.event.dart';
part 'app.state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationClient authenticationClient,
    required UserModel? user,
  })  : _authenticationClient = authenticationClient,
        super(
          AppState(user: user),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationClient.user.listen(_userChanged);
  }

  final AuthenticationClient _authenticationClient;
  late StreamSubscription<UserModel?> _userSubscription;

  void _userChanged(UserModel? user) {
    add(AppUserChanged(user));
  }

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    emit(state.copyWith(user: event.user));
  }

  Future<void> _onLogoutRequested(
      AppLogoutRequested event, Emitter<AppState> emit) async {
    await _authenticationClient.logOut();
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
