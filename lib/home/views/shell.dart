import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rooms_vital_assignment/home/home.dart';

const navigationBarDestinations = [
  NavigationDestination(
    icon: Icon(Icons.home),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.family_restroom),
    label: 'Family',
  ),
  NavigationDestination(
    icon: Icon(Icons.settings_rounded),
    label: 'Settings',
  ),
];

class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key, required this.navigatorShell});

  final StatefulNavigationShell navigatorShell;

  int get index => navigatorShell.currentIndex;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeBloc()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(navigationBarDestinations[index].label),
        ),
        body: navigatorShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigatorShell.currentIndex,
          destinations: navigationBarDestinations,
          onDestinationSelected: onNavigationBarClicked,
        ),
      ),
    );
  }

  void onNavigationBarClicked(int index) {
    navigatorShell.goBranch(
      index,
      initialLocation: index == navigatorShell.currentIndex,
    );
  }
}
