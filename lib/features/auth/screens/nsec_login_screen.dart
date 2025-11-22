import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nostrrdr/core/services/toast_service.dart';
import 'package:nostrrdr/features/auth/providers/auth_provider.dart';

class NsecLoginScreen extends ConsumerStatefulWidget {
  final String mode;

  const NsecLoginScreen({super.key, this.mode = 'login'});

  @override
  ConsumerState<NsecLoginScreen> createState() => _NsecLoginScreenState();
}

class _NsecLoginScreenState extends ConsumerState<NsecLoginScreen> {
  late TextEditingController _nsecController;
  String? _errorMessage;
  String? _generatedNsec;
  String? _generatedNpub;

  @override
  void initState() {
    super.initState();
    _nsecController = TextEditingController();
  }

  @override
  void dispose() {
    _nsecController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    try {
      setState(() => _errorMessage = null);
      final result = await ref
          .read(authStateProvider.notifier)
          .registerNewAccount();
      setState(() {
        _generatedNsec = result.nsec;
        _generatedNpub = result.npub;
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }
  }

  void _handleLogin() async {
    final nsec = _nsecController.text.trim();
    if (nsec.isEmpty) {
      setState(() => _errorMessage = 'NSEC cannot be empty');
      return;
    }

    try {
      setState(() => _errorMessage = null);
      await ref.read(authStateProvider.notifier).loginWithNsec(nsec);
      if (mounted) {
        context.goNamed('home');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context);
    if (context.mounted) {
      ToastService.showSuccess(context, 'Copied to clipboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final isRegistering = widget.mode == 'register';

    return Scaffold(
      appBar: AppBar(
        title: Text(isRegistering ? 'Create New Account' : 'Login with NSEC'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_generatedNsec == null) ...[
                  Text(
                    isRegistering
                        ? 'Create a New Nostr Account'
                        : 'Enter your private key (NSEC)',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isRegistering
                        ? 'A new private key will be generated for you'
                        : 'Keep this secret. Never share it.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!isRegistering)
                    TextField(
                      controller: _nsecController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'nsec1... or 64 character hex string',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: _errorMessage,
                      ),
                    ),
                  if (_errorMessage != null && authState is! AsyncError)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        _errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  if (authState is AsyncError)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        authState.error.toString(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: authState is AsyncLoading
                        ? null
                        : (isRegistering ? _handleRegister : _handleLogin),
                    child: authState is AsyncLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isRegistering ? 'Generate Keys' : 'Login'),
                  ),
                ] else ...[
                  Text(
                    'Account Created Successfully!',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Private Key (NSEC)',
                          style: theme.textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          _generatedNsec!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _copyToClipboard(_generatedNsec!),
                          icon: const Icon(Icons.copy),
                          label: const Text('Copy NSEC'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Public Key (NPUB)',
                          style: theme.textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          _generatedNpub!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _copyToClipboard(_generatedNpub!),
                          icon: const Icon(Icons.copy),
                          label: const Text('Copy NPUB'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Save your private key (NSEC) in a safe place. You will need it to login again.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.goNamed('home'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Go to Home'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
