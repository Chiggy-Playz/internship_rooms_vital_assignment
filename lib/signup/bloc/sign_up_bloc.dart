import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:database_handler/database_handler.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required AuthenticationClient authenticationClient,
    required DatabaseHandler databaseHandler,
  })  : _authenticationClient = authenticationClient,
        _databaseHandler = databaseHandler,
        super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  final AuthenticationClient _authenticationClient;
  final DatabaseHandler _databaseHandler;

  void _onSignUpSubmitted(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpInProgress());

    try {
      final creds = await _authenticationClient.signUpWithEmailPassword(
          email: event.email, password: event.password);
      await _databaseHandler.createUserDocument(creds.user);
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
}
