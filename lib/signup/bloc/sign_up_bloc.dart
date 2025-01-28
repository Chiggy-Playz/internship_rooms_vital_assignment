import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(AuthenticationClient authenticationClient)
      : _authenticationClient = authenticationClient,
        super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  AuthenticationClient _authenticationClient;

  void _onSignUpSubmitted(SignUpSubmitted event, Emitter<SignUpState> emit) {
    emit(SignUpInProgress());

    try {
      _authenticationClient.signUpWithEmailPassword(
          email: event.email, password: event.password);
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
}
