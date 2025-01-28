part of 'login_bloc.dart';


sealed class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginFailure extends LoginState {
  const LoginFailure({required this.error});
  
  final String error;
  
  @override
  List<Object> get props => [error];
}