import 'package:amberflutter/amberflutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nostrrdr/features/auth/providers/auth_provider.dart';

class AmberLoginScreen extends ConsumerStatefulWidget {
  const AmberLoginScreen({super.key});

  @override
  ConsumerState<AmberLoginScreen> createState() => _AmberLoginScreenState();
}

class _AmberLoginScreenState extends ConsumerState<AmberLoginScreen> {
  String? _errorMessage;

  void _handleLogin() async {
    try {
      setState(() => _errorMessage = null);

      final amber = Amberflutter();

      final publicKeyResponse = await amber.getPublicKey(
        permissions: [
          Permission(type: "sign_event"),
        ],
      );

      final publicKey = publicKeyResponse['signature']?.toString().trim();

      if (publicKey == null || publicKey.isEmpty) {
        throw Exception('Public key is empty');
      }

      try {
        final notifier = ref.read(authStateProvider.notifier);
        await notifier.loginWithAmber(publicKey);
      } catch (loginError) {
        throw Exception('Login failed: $loginError');
      }

      if (mounted) {
        context.goNamed('home');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Amber'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wallet,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Login with Amber',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the button below to connect your Amber wallet.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                if (authState is AsyncError)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      authState.error.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                if (_errorMessage != null || authState is AsyncError)
                  const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: authState is AsyncLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: authState is AsyncLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.login),
                            const SizedBox(width: 8),
                            const Text('Connect Amber'),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
