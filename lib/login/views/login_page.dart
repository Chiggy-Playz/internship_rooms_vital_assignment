import 'package:authentication_client/authentication_client.dart';
import 'package:database_handler/database_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooms_vital_assignment/login/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const routePath = "/login";
  static const routeName = "login";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        authenticationClient: context.read<AuthenticationClient>(),
        databaseHandler: context.read<DatabaseHandler>()
      ),
      child: const LoginView(),
    );
  }
}
