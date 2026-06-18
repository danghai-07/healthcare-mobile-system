import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/route_paths.dart';

/// Contract for reading authentication state in navigation guards.
///
/// Auth feature modules will provide a concrete implementation.
abstract interface class AuthStateReader {
  bool get isAuthenticated;

  /// Called when navigation should re-evaluate redirects.
  Listenable get listenable;
}

/// No-op auth reader used until the auth feature is implemented.
class GuestAuthStateReader implements AuthStateReader {
  @override
  bool get isAuthenticated => false;

  @override
  Listenable get listenable => Listenable.merge(const []);
}

/// Centralized redirect logic for protected and auth-only routes.
class AuthGuard {
  const AuthGuard({required this.authStateReader});

  final AuthStateReader authStateReader;

  String? redirect(BuildContext context, GoRouterState state) {
    final location = state.uri.path;
    final isAuthenticated = authStateReader.isAuthenticated;
    final isAuthRoute = RoutePaths.authOnlyRoutes.contains(location);

    if (!isAuthenticated && RoutePaths.isProtected(location)) {
      return RoutePaths.login;
    }

    if (isAuthenticated && isAuthRoute) {
      return RoutePaths.home;
    }

    if (location == RoutePaths.splash) {
      return isAuthenticated ? RoutePaths.home : RoutePaths.login;
    }

    return null;
  }
}
