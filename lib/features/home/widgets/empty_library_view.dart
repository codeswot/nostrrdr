import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostrrdr/core/services/toast_service.dart';
import 'package:nostrrdr/features/auth/providers/auth_provider.dart';
import 'package:nostrrdr/features/sync/providers/sync_provider.dart';

class EmptyLibraryView extends ConsumerWidget {
  const EmptyLibraryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books,
            size: 64,
            color: theme.colorScheme.tertiary,
          ),
          const SizedBox(height: 16),
          Text('No documents yet', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Add a PDF to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
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
            child: const Text('Sync now'),
          ),
        ],
      ),
    );
  }
}
