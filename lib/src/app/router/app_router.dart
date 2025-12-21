import 'package:auto_route/auto_route.dart';
import 'package:nostrrdr/src/app/presentation/screen/app_root_screen.dart';
import 'package:nostrrdr/src/features/auth/presentation/screen/auth_screen.dart';
import 'package:nostrrdr/src/features/home/presentation/screen/screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: AppRootRoute.page,
      initial: true,
      children: [
        AutoRoute(page: AuthRoute.page),
        AutoRoute(
          page: AuthenticatedShellRoute.page,
          children: [AutoRoute(page: HomeRoute.page, initial: true)],
        ),
      ],
    ),
  ];
}
