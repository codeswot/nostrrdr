import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostrrdr/core/services/toast_service.dart';
import 'package:nostrrdr/features/auth/providers/auth_provider.dart';
import 'package:nostrrdr/features/sync/providers/sync_provider.dart';

class LibraryErrorView extends ConsumerWidget {
  const LibraryErrorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Unable to load library',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () async {
              final npub = ref.read(currentNpubProvider);
              if (npub != null) {
                ToastService.showInfo(context, 'Syncing...');
                await ref
                    .read(syncStateProvider.notifier)
                    .syncAllDocuments(npub);
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
