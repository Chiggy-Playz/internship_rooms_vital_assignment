import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rooms_vital_assignment/app/app.dart';
import 'package:rooms_vital_assignment/app/loading/views/loading_page.dart';

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

      // TODO: Remove hard-coded routes
      final isLoading = state.matchedLocation == LoadingPage.routePath;
      final isLoggingIn = state.matchedLocation == "/login";

      if (isLoading) {
        if (!isAuth) return "/login";
        return "/";
      }

      if (isLoggingIn) {
        if (isAuth) return "/";
        return null;
      }

      return isAuth ? null : "/login";

    },
    routes: [
      GoRoute(
        path: LoadingPage.routePath,
        builder: (context, state) => const LoadingPage(),
      ),
    ],
  );
}
