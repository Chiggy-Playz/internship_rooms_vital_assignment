import 'package:authentication_client/authentication_client.dart';
import 'package:database_handler/database_handler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooms_vital_assignment/signup/signup.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static const String routePath = '/sign-up';
  static const String routeName = 'signup';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(
          authenticationClient: context.read<AuthenticationClient>(),
          databaseHandler: context.read<DatabaseHandler>()),
      child: const SignUpView(),
    );
  }
}
