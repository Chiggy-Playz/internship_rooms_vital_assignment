import 'package:authentication_client/authentication_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const routePath = "/home";
  static const routeName = "home";

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        child: const Text("Logout"),
        onPressed: () async {
          await context.read<AuthenticationClient>().logOut();
        },
      ),
    );
  }
}
