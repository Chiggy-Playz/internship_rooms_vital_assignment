import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rooms_vital_assignment/app/app.dart';
import 'package:rooms_vital_assignment/home/home.dart';
import 'package:rooms_vital_assignment/loading/views/loading_page.dart';
import 'package:rooms_vital_assignment/login/login.dart';
import 'package:rooms_vital_assignment/signup/signup.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

GoRouter getRouter({
  required AppBloc appBloc,
}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    refreshListenable: GoRouterRefreshStream(appBloc.stream),
    initialLocation: LoadingPage.routePath,
    redirect: (context, state) {
      final isAuth = appBloc.state.user != null;

      final isLoading = state.matchedLocation == LoadingPage.routePath;
      final isLoggingIn = state.matchedLocation == LoginPage.routePath;
      final isRegistering = state.matchedLocation == SignUpPage.routePath;

      if (isLoading) {
        if (!isAuth) return LoginPage.routePath;
        return HomeView.routePath;
      }

      if (isLoggingIn) {
        if (isAuth) return HomeView.routePath;
        return null;
      }

      if (isRegistering) {
        if (isAuth) return HomeView.routePath;
        return null;
      }

      return isAuth ? null : LoginPage.routePath;
    },
    routes: [
      GoRoute(
        path: LoadingPage.routePath,
        builder: (context, state) => const LoadingPage(),
      ),
      GoRoute(
        path: LoginPage.routePath,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: SignUpPage.routePath,
        builder: (context, state) => const SignUpPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeShellPage(navigatorShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomeView.routePath,
                name: HomeView.routeName,
                builder: (context, state) => const HomeView(),
              ),
            ],
          )
        ],
      ),
    ],
  );
}
