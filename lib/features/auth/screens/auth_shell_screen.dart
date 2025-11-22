import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nostrrdr/features/auth/providers/auth_provider.dart';
import 'package:nostrrdr/features/auth/screens/splash_screen.dart';

class AuthShellScreen extends ConsumerWidget {
  const AuthShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.maybeWhen(
      data: (npub) {
        if (npub != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed('home');
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed('auth');
          });
        }
        return const SplashScreen();
      },
      loading: () => const SplashScreen(),
      error: (error, stack) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.goNamed('auth');
        });
        return const SplashScreen();
      },
      orElse: () => const SplashScreen(),
    );
  }
}
