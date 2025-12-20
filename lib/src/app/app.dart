import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:nostrrdr/src/app/presentation/bloc/app_bloc.dart';
import 'package:nostrrdr/src/app/presentation/bloc/app_state.dart';
import 'package:nostrrdr/src/app/router/app_router.dart';
import 'package:nostrrdr/src/app/theme/app_theme.dart';
import 'package:nostrrdr/src/core/utils/layout_utils.dart';

class NostrDrApp extends StatelessWidget {
  NostrDrApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<AppBloc>(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ScreenUtilInit(
            designSize: getDesignSize(constraints),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  return MaterialApp.router(
                    title: 'NostrRDR',
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: state.themeMode.toThemeMode(),
                    routerConfig: _appRouter.config(),
                    debugShowCheckedModeBanner: false,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
