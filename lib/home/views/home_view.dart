import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooms_vital_assignment/app/bloc/app_bloc.dart';

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
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return Center(
          child: FilledButton(
            child: const Text("Logout"),
            onPressed: () async {
              context.read<AppBloc>().add(const AppLogoutRequested());
            },
          ),
        );
      },
    );
  }
}
