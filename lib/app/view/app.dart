import 'package:authentication_client/authentication_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooms_vital_assignment/app/bloc/app.bloc.dart';
import 'package:rooms_vital_assignment/app/router.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required AuthenticationClient authenticationClient,
    required UserModel? user,
  })  : _authenticationClient = authenticationClient,
        _user = user;

  final AuthenticationClient _authenticationClient;
  final UserModel? _user;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationClient),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppBloc(
              authenticationClient: _authenticationClient,
              user: _user,
            ),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getRouter(appBloc: context.read<AppBloc>());
    return MaterialApp.router(
      themeMode: ThemeMode.system,
      routerConfig: router,
      theme: ThemeData.light().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
