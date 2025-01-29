import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:rooms_vital_assignment/app/app.dart';
import 'package:rooms_vital_assignment/device_details/views/device_details_page.dart';
import 'package:rooms_vital_assignment/home/home.dart';
import 'package:rooms_vital_assignment/loading/views/loading_page.dart';
import 'package:rooms_vital_assignment/login/login.dart';
import 'package:rooms_vital_assignment/mqtt/mqtt.dart';
import 'package:rooms_vital_assignment/shared_devices/shared_devices.dart';
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
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: MqttPage.routePath,
                name: MqttPage.routeName,
                builder: (context, state) => const MqttPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: SharedDevicesPage.routePath,
                name: SharedDevicesPage.routeName,
                builder: (context, state) => const SharedDevicesPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: DeviceDetailsPage.routePath,
        name: DeviceDetailsPage.routeName,
        builder: (context, state) {
          final device = state.extra as BluetoothDevice;
          return DeviceDetailsPage(device: device);
        },
      )
    ],
  );
}
