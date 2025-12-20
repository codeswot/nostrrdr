// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AppRootScreen]
class AppRootRoute extends PageRouteInfo<void> {
  const AppRootRoute({List<PageRouteInfo>? children})
    : super(AppRootRoute.name, initialChildren: children);

  static const String name = 'AppRootRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AppRootScreen();
    },
  );
}

/// generated route for
/// [AuthScreen]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthScreen();
    },
  );
}

/// generated route for
/// [AuthenticatedShellScreen]
class AuthenticatedShellRoute extends PageRouteInfo<void> {
  const AuthenticatedShellRoute({List<PageRouteInfo>? children})
    : super(AuthenticatedShellRoute.name, initialChildren: children);

  static const String name = 'AuthenticatedShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthenticatedShellScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}
