import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostrrdr/core/routing/app_router.dart';
import 'package:nostrrdr/core/theme/app_theme.dart';
import 'package:nostrrdr/core/providers/theme_mode_provider.dart';
import 'package:nostrrdr/features/sync/providers/sync_provider.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(nostrRelayServiceProvider).connect();
    ref.read(uploadRetryServiceProvider).startPeriodicRetry();
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'NostrRdr',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode.themeMode,
        routerConfig: router,
      ),
    );
  }
}
