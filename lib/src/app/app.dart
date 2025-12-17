import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nostrrdr/src/app/router/app_router.dart';
import 'package:nostrrdr/src/app/theme/app_theme.dart';
import 'package:nostrrdr/src/core/utils/layout_utils.dart';

class NostrDrApp extends StatelessWidget {
  NostrDrApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ScreenUtilInit(
          designSize: getDesignSize(constraints),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              title: 'NostrRDR',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              routerConfig: _appRouter.config(),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
