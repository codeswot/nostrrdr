import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:nostrrdr/src/app/router/app_router.dart';
import 'package:nostrrdr/src/core/presentation/responsive_view.dart';
import 'package:nostrrdr/src/features/auth/domain/usecase/create_identity.dart';
import 'package:nostrrdr/src/features/auth/domain/usecase/nsec_login.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:nostrrdr/src/features/auth/presentation/widgets/widgets.dart';
import 'package:nostrrdr/src/core/presentation/extensions/toast_extension.dart';

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
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.router.replace(const HomeRoute());
          } else if (state is AuthFailure) {
            context.showErrorToast(
              title: 'Authentication Failed',
              description: state.message,
            );
          }
        },
        child: const AuthView(),
      ),
    );
  }
}

class AuthView extends ResponsiveView {
  const AuthView({super.key});

  @override
  Widget buildMobile(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 24.h),
        child: ListView(
          children: [
            AuthBranding(),
            SizedBox(height: 64.h),
            AuthForm(),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildDesktop(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 24.h),
          child: Row(
            children: [
              Expanded(flex: 3, child: AuthBranding()),
              SizedBox(width: 8.w),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(child: AuthForm()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
