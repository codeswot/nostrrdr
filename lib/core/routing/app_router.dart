import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nostrrdr/features/auth/providers/auth_provider.dart';
import 'package:nostrrdr/features/auth/screens/auth_shell_screen.dart';
import 'package:nostrrdr/features/auth/screens/auth_screen.dart';
import 'package:nostrrdr/features/auth/screens/nsec_login_screen.dart';
import 'package:nostrrdr/features/auth/screens/amber_login_screen.dart';
import 'package:nostrrdr/features/home/screens/home_screen.dart';
import 'package:nostrrdr/features/reader/screens/reader_screen.dart';
import 'package:nostrrdr/features/debug/screens/playground_screen.dart';
import 'package:nostrrdr/features/profile/screens/profile_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: ValueNotifier(authState),
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn =
          state.uri.path == '/' ||
          state.uri.path == '/login' ||
          state.uri.path.startsWith('/login/');

      if (!isLoggedIn && !isLoggingIn) {
        return '/';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'auth-shell',
        builder: (context, state) => const AuthShellScreen(),
        routes: [
          GoRoute(
            path: 'login',
            name: 'auth',
            builder: (context, state) => const AuthScreen(),
            routes: [
              GoRoute(
                path: 'nsec-login',
                name: 'nsec-login',
                builder: (context, state) {
                  final mode = state.uri.queryParameters['mode'] ?? 'login';
                  return NsecLoginScreen(mode: mode);
                },
              ),
              GoRoute(
                path: 'amber-login',
                name: 'amber-login',
                builder: (context, state) => const AmberLoginScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/reader/:documentId',
        name: 'reader',
        builder: (context, state) {
          final documentId = int.parse(
            state.pathParameters['documentId'] ?? '0',
          );
          return ReaderScreen(documentId: documentId);
        },
      ),
      GoRoute(
        path: '/playground',
        name: 'playground',
        builder: (context, state) => const PlaygroundScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});


