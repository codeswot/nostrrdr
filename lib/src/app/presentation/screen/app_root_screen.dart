import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostrrdr/src/app/presentation/bloc/app_bloc.dart';
import 'package:nostrrdr/src/app/presentation/bloc/app_state.dart';
import 'package:nostrrdr/src/app/router/app_router.dart';

@RoutePage()
class AppRootScreen extends StatelessWidget {
  const AppRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return AutoRouter.declarative(
          routes: (_) => [
            if (state.activePubKey != null &&
                state.activePubKey?.isEmpty == false)
              const AuthenticatedShellRoute()
            else
              const AuthRoute(),
          ],
        );
      },
    );
  }
}

@RoutePage()
class AuthenticatedShellScreen extends StatelessWidget {
  const AuthenticatedShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoRouter();
  }
}
