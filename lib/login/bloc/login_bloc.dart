import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required authenticationClient})
      : _authenticationClient = authenticationClient,
        super(LoginInitial()) {
    on<LoginWithGooglePressed>(_onLoginWithGooglePressed);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final AuthenticationClient _authenticationClient;

  Future<void> _onLoginWithGooglePressed(
      LoginWithGooglePressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await _authenticationClient.logInWithGoogle();
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await _authenticationClient.logInWithEmailPassword(
          email: event.email, password: event.password);
      emit(LoginSuccess());
    } on LogInWithGoogleCanceled {
      // pass. This is not an error.
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
