import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nostrrdr/src/core/presentation/responsive_view.dart';
import 'package:nostrrdr/src/features/auth/domain/usecase/create_identity.dart';
import 'package:nostrrdr/src/features/auth/domain/usecase/nsec_login.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_state.dart';

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        nsecLoginUseCase: GetIt.I.get<NsecLoginUseCase>(),
        createIdentityUseCase: GetIt.I.get<CreateIdentityUseCase>(),
      ),
      child: const AuthView(),
    );
  }
}

class AuthView extends ResponsiveView {
  const AuthView({super.key});

  @override
  Widget buildMobile(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return const SingleChildScrollView();
        },
      ),
    );
  }

  @override
  Widget buildDesktop(BuildContext context) {
    return  Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return const Row();
        },
      ),
    );
  }
}
